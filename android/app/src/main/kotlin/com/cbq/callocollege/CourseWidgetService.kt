package com.cbq.callocollege

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray

/**
 * 课表小组件的课程列表服务：为集合部件（ListView）提供课程行，
 * 组件高度不足时可在组件内滑动查看全部课程
 */
class CourseWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory =
        CourseRowFactory(applicationContext)
}

class CourseRowFactory(private val context: Context) :
    RemoteViewsService.RemoteViewsFactory {

    private var rows: JSONArray? = null
    private var textColor = CourseWidgetData.DEFAULT_TEXT
    private var subColor = CourseWidgetData.DEFAULT_SUB
    private var accentColor = CourseWidgetData.DEFAULT_ACCENT

    override fun onCreate() {
        load()
    }

    override fun onDataSetChanged() {
        load()
    }

    private fun load() {
        val root = CourseWidgetData.read(HomeWidgetPlugin.getData(context))
        rows = CourseWidgetData.todayRows(root)
        textColor = CourseWidgetData.textColor(root)
        subColor = CourseWidgetData.subColor(root)
        accentColor = CourseWidgetData.accentColor(root)
    }

    override fun getCount(): Int = rows?.length() ?: 0

    override fun getViewAt(position: Int): RemoteViews? {
        val course = rows?.optJSONObject(position) ?: return null
        val row = CourseWidgetData.buildRow(context, course, textColor, subColor, accentColor)
        // 与 ListView 的 PendingIntent 模板配合，点击整行打开 App
        row.setOnClickFillInIntent(R.id.item_root, Intent(Intent.ACTION_VIEW))
        return row
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = false

    override fun onDestroy() {
        rows = null
    }
}
