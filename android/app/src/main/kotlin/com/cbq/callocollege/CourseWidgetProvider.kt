package com.cbq.callocollege

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray
import org.json.JSONObject

/**
 * 桌面课表小组件：展示今日课程
 * - Android 12+：课程行通过 RemoteCollectionItems 直接随 RemoteViews 下发，任何数据变化都能立即生效
 * - Android 12 以下：使用 RemoteViewsService（集合部件）+ 主动通知刷新
 */
class CourseWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val root = CourseWidgetData.read(widgetData)
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId, root)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle?,
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        // 尺寸变化时重新布局（紧凑模式/内边距）
        val root = CourseWidgetData.read(HomeWidgetPlugin.getData(context))
        updateWidget(context, appWidgetManager, appWidgetId, root)
    }

    companion object {
        private const val TAG = "CourseWidget"

        /**
         * 进程内刷新全部课表小组件（App 内更新课表后调用，比广播更可靠）
         */
        fun updateAll(context: Context) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val component = ComponentName(context, CourseWidgetProvider::class.java)
            val ids = appWidgetManager.getAppWidgetIds(component)
            Log.i(TAG, "updateAll widgets=${ids.size}")
            if (ids.isEmpty()) return
            val root = CourseWidgetData.read(HomeWidgetPlugin.getData(context))
            Log.i(
                TAG,
                "updateAll open=${root?.optString("open")} ans=${root?.optInt("ans")} " +
                    "v=${root?.optLong("v")} week=${CourseWidgetData.weekLabel(root)} " +
                    "todayRows=${CourseWidgetData.todayRows(root)?.length() ?: -1}"
            )
            for (appWidgetId in ids) {
                updateWidget(context, appWidgetManager, appWidgetId, root)
            }
        }

        private fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
            root: JSONObject?,
        ) {
            val views = RemoteViews(context.packageName, R.layout.course_widget_layout)
            try {
                bindViews(context, views, root, appWidgetId, appWidgetManager)
            } catch (e: Exception) {
                Log.e(TAG, "bindViews failed", e)
                bindFallback(views)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        private fun notifyListChanged(appWidgetManager: AppWidgetManager, ids: IntArray) {
            try {
                appWidgetManager.notifyAppWidgetViewDataChanged(ids, R.id.course_list)
            } catch (_: Exception) {
            }
            // 部分桌面（如 MIUI）对紧接着的刷新不敏感，稍后再补一次
            Handler(Looper.getMainLooper()).postDelayed({
                try {
                    appWidgetManager.notifyAppWidgetViewDataChanged(ids, R.id.course_list)
                } catch (_: Exception) {
                }
            }, 800)
        }

        private fun bindViews(
            context: Context,
            views: RemoteViews,
            root: JSONObject?,
            appWidgetId: Int,
            appWidgetManager: AppWidgetManager,
        ) {
            views.setOnClickPendingIntent(
                R.id.widget_root,
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
            )

            val textColor = CourseWidgetData.textColor(root)
            val subColor = CourseWidgetData.subColor(root)
            val accentColor = CourseWidgetData.accentColor(root)
            val dark = CourseWidgetData.isDark(root)
            val plan = CourseWidgetData.plan(root)
            val rows = plan.rows

            // 高度很小时进入紧凑模式：隐藏周次行、分隔线并缩小内边距，把空间留给课程列表
            val minHeight = try {
                appWidgetManager.getAppWidgetOptions(appWidgetId)
                    .getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 110)
            } catch (e: Exception) {
                110
            }
            val compact = minHeight < 120
            val padding =
                ((if (compact) 10 else 14) * context.resources.displayMetrics.density).toInt()
            //内边距加在内容层，背景图才能铺满整个组件
            views.setViewPadding(R.id.widget_content, padding, padding, padding, padding)

            views.setInt(
                R.id.widget_root,
                "setBackgroundResource",
                if (CourseWidgetData.isDark(root)) R.drawable.widget_card_bg_dark
                else R.drawable.widget_card_bg_light
            )

            //自定义背景图：在 App 进程解码后随 RemoteViews 下发，透明度按设置应用
            val bgPath = root?.optString("bgPath", "") ?: ""
            val bgAlpha = root?.optDouble("bgAlpha", 0.0) ?: 0.0
            val bgBitmap =
                if (bgPath.isNotEmpty() && bgAlpha > 0.01)
                    loadWidgetBackground(
                        context, bgPath,
                        widgetSizePx(appWidgetManager, appWidgetId, true),
                        widgetSizePx(appWidgetManager, appWidgetId, false)
                    )
                else null
            if (bgBitmap != null) {
                views.setImageViewBitmap(R.id.widget_bg, bgBitmap)
                views.setFloat(
                    R.id.widget_bg, "setAlpha",
                    bgAlpha.toFloat().coerceIn(0f, 1f)
                )
                views.setViewVisibility(R.id.widget_bg, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.widget_bg, View.GONE)
            }
            views.setTextColor(R.id.tv_date, textColor)
            views.setTextColor(R.id.tv_week, subColor)
            views.setTextColor(R.id.tv_count, accentColor)
            views.setTextColor(R.id.tv_empty, subColor)
            views.setInt(
                R.id.divider,
                "setBackgroundColor",
                CourseWidgetData.withAlpha(textColor, 0.08f)
            )
            //今天没课且明天也没课时预显示明天的空状态提示
            val dayOffset = if (plan.showTomorrow) 1 else 0
            val weekText = CourseWidgetData.weekLabel(root, dayOffset)
            views.setTextViewText(R.id.tv_date, CourseWidgetData.dayTitle(dayOffset))
            views.setTextViewText(R.id.tv_week, weekText)
            //周次做成小胶囊，观感更柔和
            views.setInt(
                R.id.tv_week, "setBackgroundResource",
                if (dark) R.drawable.widget_chip_dark else R.drawable.widget_chip_light
            )
            views.setViewVisibility(
                R.id.tv_week,
                if (compact || weekText.isEmpty()) View.GONE else View.VISIBLE
            )
            views.setViewVisibility(R.id.divider, if (compact) View.GONE else View.VISIBLE)

            if (root == null) {
                views.setTextViewText(R.id.tv_date, CourseWidgetData.todayTitle())
                views.setTextViewText(R.id.tv_week, "")
                views.setViewVisibility(R.id.tv_week, View.GONE)
                views.setTextViewText(R.id.tv_count, "打开App同步")
                views.setTextViewText(R.id.tv_empty, "打开「恰啰校园」同步课表后，这里会显示今日课程")
                showEmpty(views)
                return
            }
            if (rows == null || rows.length() == 0) {
                views.setTextViewText(
                    R.id.tv_count,
                    when {
                        plan.emptyText == null -> "今日无课"
                        plan.todayEmpty -> "今明两天都无课"
                        else -> "今日课程已结束"
                    }
                )
                views.setTextViewText(
                    R.id.tv_empty,
                    plan.emptyText ?: "今天没有课，好好休息~"
                )
                showEmpty(views)
                return
            }

            val usesService = setCourseListAdapter(
                context, views, rows, appWidgetId,
                root.optLong("v", 0L), textColor, subColor, accentColor, plan, dark,
                root.optBoolean("noon", true)
            )
            if (usesService) {
                notifyListChanged(appWidgetManager, intArrayOf(appWidgetId))
            }

            views.setTextViewText(
                R.id.tv_count,
                (if (plan.showTomorrow) "明日 " else "今日 ") + "${rows.length()} 门课"
            )
            views.setViewVisibility(R.id.tv_empty, View.GONE)
            views.setViewVisibility(R.id.course_list, View.VISIBLE)
        }

        /**
         * 设置课程列表
         * @return true 表示使用了 RemoteViewsService（需要额外通知刷新）
         */
        private fun setCourseListAdapter(
            context: Context,
            views: RemoteViews,
            rows: JSONArray,
            appWidgetId: Int,
            version: Long,
            textColor: Int,
            subColor: Int,
            accentColor: Int,
            plan: CourseWidgetData.DayPlan,
            dark: Boolean,
            showNoon: Boolean,
        ): Boolean {
            val launchIntent =
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
            if (Build.VERSION.SDK_INT >= 31) {
                // Android 12+：直接携带课程行，数据变化随 updateAppWidget 立即生效
                val builder = RemoteViews.RemoteCollectionItems.Builder()
                    .setHasStableIds(false)
                for (i in 0 until rows.length()) {
                    val course = rows.optJSONObject(i) ?: continue
                    val highlight = i == plan.highlightIndex
                    //下午第一节且上面还有课程时，显示午休分割线（nr 为午休标记，n 是课程名）
                    val noonDivider =
                        showNoon && i > 0 && course.optInt("nr", 0) == 1
                    val row = CourseWidgetData.buildRow(
                        context, course, textColor, subColor, accentColor,
                        statusText = if (highlight) plan.highlightText else null,
                        highlight = highlight,
                        dark = dark,
                        noonDivider = noonDivider,
                    )
                    row.setOnClickPendingIntent(R.id.item_root, launchIntent)
                    builder.addItem(i.toLong(), row)
                }
                views.setRemoteAdapter(R.id.course_list, builder.build())
                return false
            }
            // 旧系统：集合部件 + 通知刷新；data 带版本号，数据变化时会重建适配器
            views.setPendingIntentTemplate(
                R.id.course_list,
                mutableLaunchPendingIntent(context)
            )
            val serviceIntent = Intent(context, CourseWidgetService::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                data = Uri.parse("callo://course_widget/$appWidgetId/$version")
            }
            views.setRemoteAdapter(appWidgetId, R.id.course_list, serviceIntent)
            return true
        }

        /** 小组件当前尺寸（px）：width=true 取宽，否则取高 */
        private fun widgetSizePx(
            manager: AppWidgetManager,
            appWidgetId: Int,
            width: Boolean,
        ): Int {
            val options = try {
                manager.getAppWidgetOptions(appWidgetId)
            } catch (e: Exception) {
                Bundle()
            }
            val dp = if (width) {
                options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 250)
            } else {
                options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 110)
            }
            return dp
        }

        /**
         * 解码小组件背景图并裁切为小组件尺寸后做圆角：
         * 先按目标比例 centerCrop 缩放，再以 20dp 圆角裁切，
         * 保证图片圆角与卡片圆角一致（否则会露出直角边，看起来像直角阴影）
         */
        private fun loadWidgetBackground(
            context: Context,
            path: String,
            targetWidthDp: Int,
            targetHeightDp: Int,
        ): android.graphics.Bitmap? {
            return try {
                val density = context.resources.displayMetrics.density
                val targetW = (targetWidthDp * density).toInt().coerceIn(64, 1600)
                val targetH = (targetHeightDp * density).toInt().coerceIn(64, 1600)
                val bounds = android.graphics.BitmapFactory.Options().apply {
                    inJustDecodeBounds = true
                }
                android.graphics.BitmapFactory.decodeFile(path, bounds)
                if (bounds.outWidth <= 0 || bounds.outHeight <= 0) return null
                var sample = 1
                while (bounds.outWidth / sample > targetW * 2 ||
                    bounds.outHeight / sample > targetH * 2
                ) {
                    sample *= 2
                }
                val options = android.graphics.BitmapFactory.Options().apply {
                    inSampleSize = sample
                }
                val source = android.graphics.BitmapFactory.decodeFile(path, options)
                    ?: return null
                //centerCrop：按目标比例裁出中间区域
                val sourceRatio = source.width.toFloat() / source.height
                val targetRatio = targetW.toFloat() / targetH
                val cropW: Int
                val cropH: Int
                if (sourceRatio > targetRatio) {
                    cropH = source.height
                    cropW = (source.height * targetRatio).toInt().coerceAtLeast(1)
                } else {
                    cropW = source.width
                    cropH = (source.width / targetRatio).toInt().coerceAtLeast(1)
                }
                val cropX = (source.width - cropW) / 2
                val cropY = (source.height - cropH) / 2
                val cropped = android.graphics.Bitmap.createBitmap(
                    source, cropX, cropY, cropW, cropH
                )
                val scaled = android.graphics.Bitmap.createScaledBitmap(
                    cropped, targetW, targetH, true
                )
                if (scaled !== source) source.recycle()
                if (cropped !== source && cropped !== scaled) cropped.recycle()
                roundCorners(scaled, 20f * density)
            } catch (e: Exception) {
                Log.e(TAG, "loadWidgetBackground failed", e)
                null
            }
        }

        /** 把背景图圆角裁切，与卡片圆角保持一致（避免出现直角白边） */
        private fun roundCorners(
            source: android.graphics.Bitmap,
            radiusPx: Float,
        ): android.graphics.Bitmap {
            val width = source.width
            val height = source.height
            if (width <= 0 || height <= 0) return source
            val output = android.graphics.Bitmap.createBitmap(
                width, height, android.graphics.Bitmap.Config.ARGB_8888
            )
            val canvas = android.graphics.Canvas(output)
            val paint = android.graphics.Paint(android.graphics.Paint.ANTI_ALIAS_FLAG)
            val path = android.graphics.Path().apply {
                addRoundRect(
                    android.graphics.RectF(0f, 0f, width.toFloat(), height.toFloat()),
                    radiusPx, radiusPx, android.graphics.Path.Direction.CW
                )
            }
            canvas.drawARGB(0, 0, 0, 0)
            paint.color = android.graphics.Color.BLACK
            canvas.drawPath(path, paint)
            paint.xfermode = android.graphics.PorterDuffXfermode(
                android.graphics.PorterDuff.Mode.SRC_IN
            )
            canvas.drawBitmap(source, 0f, 0f, paint)
            return output
        }

        private fun showEmpty(views: RemoteViews) {
            views.setViewVisibility(R.id.course_list, View.GONE)
            views.setViewVisibility(R.id.tv_empty, View.VISIBLE)
        }

        private fun bindFallback(views: RemoteViews) {
            try {
                views.setTextViewText(R.id.tv_count, "")
                views.setTextViewText(R.id.tv_empty, "课表加载失败，请打开App重新同步")
                showEmpty(views)
            } catch (_: Exception) {
                // 忽略：极少见情况下 RemoteViews 本身不可用
            }
        }

        /**
         * 列表点击模板：Android 12+ 必须使用可变 PendingIntent，才能与行点击的 fillInIntent 合并
         */
        private fun mutableLaunchPendingIntent(context: Context): PendingIntent {
            val intent = Intent(context, MainActivity::class.java)
            var flags = PendingIntent.FLAG_UPDATE_CURRENT
            flags = if (Build.VERSION.SDK_INT >= 31) {
                flags or PendingIntent.FLAG_MUTABLE
            } else {
                flags or PendingIntent.FLAG_IMMUTABLE
            }
            return PendingIntent.getActivity(context, 100, intent, flags)
        }
    }
}
