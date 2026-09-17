package com.cbq.callocollege

import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.RectF
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

/**
 * 课表小组件数据解析与渲染的公共逻辑（Provider 与 RemoteViewsService 共用）
 */
object CourseWidgetData {
    const val DATA_KEY = "course_widget_data"

    val DEFAULT_TEXT = 0xFF222222.toInt()
    val DEFAULT_SUB = 0x99000000.toInt()
    //深色卡片（#1C1C1E）上的高对比默认色，避免文字与背景糊在一起
    val DARK_TEXT = 0xFFEDEDED.toInt()
    val DARK_SUB = 0xFFAFAFAF.toInt()
    val DEFAULT_ACCENT = 0xFF7C4DFF.toInt()

    private val WEEK_NAMES =
        arrayOf("周一", "周二", "周三", "周四", "周五", "周六", "周日")

    fun read(prefs: SharedPreferences?): JSONObject? {
        val raw = prefs?.getString(DATA_KEY, null) ?: return null
        return try {
            JSONObject(raw)
        } catch (e: Exception) {
            null
        }
    }

    fun textColor(root: JSONObject?): Int =
        root?.optInt("text", if (isDark(root)) DARK_TEXT else DEFAULT_TEXT)
            ?: DEFAULT_TEXT

    fun subColor(root: JSONObject?): Int =
        root?.optInt("sub", if (isDark(root)) DARK_SUB else DEFAULT_SUB)
            ?: DEFAULT_SUB

    fun accentColor(root: JSONObject?): Int =
        root?.optInt("accent", DEFAULT_ACCENT) ?: DEFAULT_ACCENT

    fun isDark(root: JSONObject?): Boolean = root?.optBoolean("dark", false) ?: false

    fun todayRows(root: JSONObject?): JSONArray? = rowsForDay(root, 0)

    fun tomorrowRows(root: JSONObject?): JSONArray? = rowsForDay(root, 1)

    /** 取某天（相对今天偏移）的课程行 */
    fun rowsForDay(root: JSONObject?, dayOffset: Int): JSONArray? {
        if (root == null) return null
        val weeks = root.optJSONArray("weeks") ?: return null
        if (weeks.length() == 0) return null
        val open = parseOpenDate(root.optString("open", "")) ?: return null
        val diffDays = daysSince(open) + dayOffset
        val ansWeek = root.optInt("ans", weeks.length())
        val weekIndex = weekIndexFromDiff(diffDays, ansWeek)
        //该周没有课表数据（例如超出总周数）时按无课处理，避免错误地显示最后一周
        if (weekIndex < 1 || weekIndex > weeks.length()) return null
        val week = weeks.optJSONArray(weekIndex - 1) ?: return null
        //与 App 保持一致：列 = 相对开学日期的天数偏移（不是真实星期几）
        val dayIndex = ((diffDays % 7) + 7) % 7
        return week.optJSONArray(dayIndex)
    }

    fun weekLabel(root: JSONObject?, dayOffset: Int = 0): String {
        if (root == null) return ""
        val weeks = root.optJSONArray("weeks") ?: return ""
        val open = parseOpenDate(root.optString("open", "")) ?: return ""
        val diffDays = daysSince(open) + dayOffset
        val ansWeek = root.optInt("ans", weeks.length())
        val index = weekIndexFromDiff(diffDays, ansWeek)
        return "第 $index 周"
    }

    fun todayTitle(): String = dayTitle(0)

    /** 当天/次日的标题：M月d日 周几 */
    fun dayTitle(dayOffset: Int = 0): String {
        val calendar = Calendar.getInstance().apply {
            add(Calendar.DAY_OF_YEAR, dayOffset)
        }
        val format = SimpleDateFormat("M月d日", Locale.CHINA)
        return "${format.format(calendar.time)} ${weekName(calendar.get(Calendar.DAY_OF_WEEK))}"
    }

    /** 小组件的展示方案 */
    data class DayPlan(
        /** 要展示的课程行（today / tomorrow），为空表示无课 */
        val rows: JSONArray?,
        /** true 表示正在预显示明天的课程 */
        val showTomorrow: Boolean,
        /** 需要高亮的行下标（进行中 / 最近一节课），-1 表示无 */
        val highlightIndex: Int,
        /** 高亮行右侧的提示文案（“上课中”“还有 30 分钟”） */
        val highlightText: String?,
        /** 今天已上完但明天无课时的提示 */
        val emptyText: String?,
        /** 今天本来就没有课（区别于“今天的课上完了”） */
        val todayEmpty: Boolean = false,
    )

    /**
     * 计算展示方案：
     * 1）今天还有课没上完 → 显示今天的课表，并高亮“进行中”或“最近一节”的课；
     * 2）今天的课全部上完 → 预显示明天的课表；
     * 3）明天也没有课 → 提示“明天无课”。
     */
    fun plan(root: JSONObject?): DayPlan {
        val today = todayRows(root)
        //已上完的课程不再显示，避免小组件空间被占满
        val remaining = remainingRows(today)
        if (remaining.length() > 0) {
            val now = currentMinutes()
            var ongoingIndex = -1
            var nextIndex = -1
            var nextStart = Int.MAX_VALUE
            for (i in 0 until remaining.length()) {
                val course = remaining.optJSONObject(i) ?: continue
                val start = parseMinutes(course.optString("s", "")) ?: continue
                val end = parseMinutes(course.optString("e", "")) ?: continue
                if (now in start until end) {
                    ongoingIndex = i
                    break
                }
                if (start > now && start < nextStart) {
                    nextStart = start
                    nextIndex = i
                }
            }
            if (ongoingIndex >= 0) {
                return DayPlan(remaining, false, ongoingIndex, "上课中", null)
            }
            if (nextIndex >= 0) {
                val minutes = nextStart - now
                val text =
                    if (minutes >= 60) "还有 ${minutes / 60} 小时" else "还有 $minutes 分钟"
                return DayPlan(remaining, false, nextIndex, text, null)
            }
        }
        //今天没有剩余课程：区分“今天本来没课”和“今天的课上完了”
        val todayEmpty = today == null || today.length() == 0
        val tomorrow = tomorrowRows(root)
        return if (tomorrow != null && tomorrow.length() > 0) {
            DayPlan(tomorrow, true, -1, null, null, todayEmpty = todayEmpty)
        } else {
            DayPlan(null, true, -1, null, "明天无课", todayEmpty = todayEmpty)
        }
    }

    /** 过滤掉已上完（end <= 当前时间）的课程，缺少结束时间的数据保留 */
    private fun remainingRows(today: JSONArray?): JSONArray {
        val result = JSONArray()
        if (today == null) return result
        val now = currentMinutes()
        for (i in 0 until today.length()) {
            val course = today.optJSONObject(i) ?: continue
            val end = parseMinutes(course.optString("e", ""))
            if (end == null || now < end) {
                result.put(course)
            }
        }
        return result
    }

    fun buildRow(
        context: Context,
        course: JSONObject,
        textColor: Int,
        subColor: Int,
        accentColor: Int,
        statusText: String? = null,
        highlight: Boolean = false,
        dark: Boolean = false,
        noonDivider: Boolean = false,
    ): RemoteViews {
        val row = RemoteViews(context.packageName, R.layout.course_widget_item)
        val name = course.optString("n", "课程")
        val room = course.optString("r", "")
        val start = course.optString("s", "")
        val end = course.optString("e", "")
        val period = course.optString("p", "")
        val courseColor = course.optInt("c", accentColor)

        row.setTextViewText(R.id.item_name, name)
        row.setTextColor(R.id.item_name, textColor)
        val info = buildString {
            if (start.isNotEmpty()) {
                append(start)
                if (end.isNotEmpty()) append("-").append(end)
            }
            if (period.isNotEmpty()) {
                if (isNotEmpty()) append(" · ")
                append(period)
            }
        }
        row.setTextViewText(R.id.item_time, info)
        row.setTextColor(R.id.item_time, subColor)
        //教室是关键信息：单独一行展示（最多两行不省略）
        if (room.isNotEmpty()) {
            row.setTextViewText(R.id.item_room, room)
            row.setTextColor(R.id.item_room, withAlpha(textColor, 0.82f))
            row.setViewVisibility(R.id.item_room, android.view.View.VISIBLE)
        } else {
            row.setViewVisibility(R.id.item_room, android.view.View.GONE)
        }
        //左侧色条：圆角色条位图（高亮行用强调色，其余用课程色）
        row.setImageViewBitmap(
            R.id.item_bar,
            roundedBar(context, if (highlight) accentColor else courseColor)
        )

        //状态文案统一由 plan() 计算（避免预显示明天时按今天的时刻误判“上课中”）
        val status = statusText
        if (!status.isNullOrEmpty()) {
            row.setTextViewText(R.id.item_status, status)
            row.setViewVisibility(R.id.item_status, android.view.View.VISIBLE)
            row.setTextColor(R.id.item_status, accentColor)
            row.setInt(
                R.id.item_status, "setBackgroundResource",
                if (dark) R.drawable.widget_chip_dark else R.drawable.widget_chip_light
            )
        } else {
            row.setViewVisibility(R.id.item_status, android.view.View.GONE)
        }
        //高亮行：圆角柔光底（不再是一整块方形色块，减少“阴影”感）
        row.setInt(
            R.id.item_root, "setBackgroundResource",
            if (highlight) {
                if (dark) R.drawable.widget_row_highlight_dark
                else R.drawable.widget_row_highlight_light
            } else {
                0
            }
        )

        //午休分割线：下午第一节上方显示一条细线 + “午休”
        if (noonDivider) {
            row.setViewVisibility(R.id.noon_wrap, android.view.View.VISIBLE)
            row.setTextColor(R.id.noon_text, withAlpha(textColor, 0.5f))
            val lineColor = withAlpha(textColor, 0.14f)
            row.setInt(R.id.noon_line_left, "setBackgroundColor", lineColor)
            row.setInt(R.id.noon_line_right, "setBackgroundColor", lineColor)
        } else {
            row.setViewVisibility(R.id.noon_wrap, android.view.View.GONE)
        }

        //已结束的课程会在 plan() 中被过滤掉，这里不再做淡化处理
        return row
    }

    fun withAlpha(color: Int, alpha: Float): Int {
        val a = (alpha * 255).toInt().coerceIn(0, 255)
        return (a shl 24) or (color and 0x00FFFFFF)
    }

    /** 生成圆角色条位图（RemoteViews 无法直接给 View 设置动态颜色的圆角背景） */
    private fun roundedBar(context: Context, color: Int): Bitmap {
        val density = context.resources.displayMetrics.density
        val width = (4f * density).toInt().coerceAtLeast(1)
        val height = (34f * density).toInt().coerceAtLeast(1)
        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        paint.color = color
        Canvas(bitmap).drawRoundRect(
            RectF(0f, 0f, width.toFloat(), height.toFloat()),
            width / 2f, width / 2f, paint
        )
        return bitmap
    }

    private fun parseOpenDate(openDate: String): Date? {
        if (openDate.isEmpty()) return null
        return try {
            SimpleDateFormat("yyyy/M/d", Locale.CHINA).parse(openDate)
        } catch (e: Exception) {
            null
        }
    }

    /**
     * 今天相对开学日期的天数差（可以为负）
     */
    private fun daysSince(open: Date): Int {
        val today = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis
        val start = Calendar.getInstance().apply {
            timeInMillis = open.time
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis
        return ((today - start) / 86400000L).toInt()
    }

    /**
     * 与 App 的 CourseUtil.getNowWeek 完全一致：1 周起算，超出总周数按总周数算
     */
    private fun weekIndexFromDiff(diffDays: Int, weekCount: Int): Int {
        val dif = diffDays + 1
        if (dif <= 0) return 1
        if (dif > 7 * weekCount) return maxOf(weekCount, 1)
        val week = if (dif % 7 == 0) dif / 7 else dif / 7 + 1
        return week.coerceIn(1, maxOf(weekCount, 1))
    }

    /** Calendar.DAY_OF_WEEK（周日=1）转“周X” */
    private fun weekName(dayOfWeek: Int): String {
        val dayIndex = (dayOfWeek + 5) % 7
        return WEEK_NAMES[dayIndex]
    }

    private fun parseMinutes(time: String): Int? {
        val parts = time.split(":")
        if (parts.size != 2) return null
        val hour = parts[0].trim().toIntOrNull() ?: return null
        val minute = parts[1].trim().toIntOrNull() ?: return null
        return hour * 60 + minute
    }

    private fun currentMinutes(): Int {
        val calendar = Calendar.getInstance()
        return calendar.get(Calendar.HOUR_OF_DAY) * 60 + calendar.get(Calendar.MINUTE)
    }
}
