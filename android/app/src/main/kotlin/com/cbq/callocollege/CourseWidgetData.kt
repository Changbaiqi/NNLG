package com.cbq.callocollege

import android.content.Context
import android.content.SharedPreferences
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
        root?.optInt("text", DEFAULT_TEXT) ?: DEFAULT_TEXT

    fun subColor(root: JSONObject?): Int =
        root?.optInt("sub", DEFAULT_SUB) ?: DEFAULT_SUB

    fun accentColor(root: JSONObject?): Int =
        root?.optInt("accent", DEFAULT_ACCENT) ?: DEFAULT_ACCENT

    fun isDark(root: JSONObject?): Boolean = root?.optBoolean("dark", false) ?: false

    fun todayRows(root: JSONObject?): JSONArray? {
        if (root == null) return null
        val weeks = root.optJSONArray("weeks") ?: return null
        if (weeks.length() == 0) return null
        val open = parseOpenDate(root.optString("open", "")) ?: return null
        val diffDays = daysSince(open)
        val ansWeek = root.optInt("ans", weeks.length())
        val weekIndex = weekIndexFromDiff(diffDays, ansWeek)
        //该周没有课表数据（例如超出总周数）时按无课处理，避免错误地显示最后一周
        if (weekIndex < 1 || weekIndex > weeks.length()) return null
        val week = weeks.optJSONArray(weekIndex - 1) ?: return null
        //与 App 保持一致：列 = 今天相对开学日期的天数偏移（不是真实星期几）
        val dayIndex = ((diffDays % 7) + 7) % 7
        return week.optJSONArray(dayIndex)
    }

    fun weekLabel(root: JSONObject?): String {
        if (root == null) return ""
        val weeks = root.optJSONArray("weeks") ?: return ""
        val open = parseOpenDate(root.optString("open", "")) ?: return ""
        val diffDays = daysSince(open)
        val ansWeek = root.optInt("ans", weeks.length())
        val index = weekIndexFromDiff(diffDays, ansWeek)
        return "第 $index 周"
    }

    fun todayTitle(): String {
        val format = SimpleDateFormat("M月d日", Locale.CHINA)
        return "${format.format(Date())} ${todayWeekName()}"
    }

    fun buildRow(
        context: Context,
        course: JSONObject,
        textColor: Int,
        subColor: Int,
        accentColor: Int,
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
            if (room.isNotEmpty()) {
                if (isNotEmpty()) append(" · ")
                append(room)
            }
        }
        row.setTextViewText(R.id.item_info, info)
        row.setTextColor(R.id.item_info, subColor)
        row.setInt(R.id.item_bar, "setBackgroundColor", courseColor)

        if (isOngoing(start, end)) {
            row.setViewVisibility(R.id.item_status, android.view.View.VISIBLE)
            row.setTextColor(R.id.item_status, accentColor)
        } else {
            row.setViewVisibility(R.id.item_status, android.view.View.GONE)
        }

        val alpha = if (isFinished(end)) 0.45f else 1f
        row.setFloat(R.id.item_name, "setAlpha", alpha)
        row.setFloat(R.id.item_info, "setAlpha", alpha)
        row.setFloat(R.id.item_bar, "setAlpha", alpha)
        return row
    }

    fun withAlpha(color: Int, alpha: Float): Int {
        val a = (alpha * 255).toInt().coerceIn(0, 255)
        return (a shl 24) or (color and 0x00FFFFFF)
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

    private fun todayWeekName(): String {
        val dayIndex = (Calendar.getInstance().get(Calendar.DAY_OF_WEEK) + 5) % 7
        return WEEK_NAMES[dayIndex]
    }

    private fun isOngoing(start: String, end: String): Boolean {
        val startMinutes = parseMinutes(start) ?: return false
        val endMinutes = parseMinutes(end) ?: return false
        val now = currentMinutes()
        return now in startMinutes until endMinutes
    }

    private fun isFinished(end: String): Boolean {
        val endMinutes = parseMinutes(end) ?: return false
        return currentMinutes() >= endMinutes
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
