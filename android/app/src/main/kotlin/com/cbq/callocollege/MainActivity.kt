package com.cbq.callocollege

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.cbq.callocollege/shortcut"
        const val ACTION_ADD_COURSE_WIDGET = "com.cbq.callocollege.action.ADD_COURSE_WIDGET"
        private const val SCHEME = "callo"
        private const val HOST_ADD_COURSE_WIDGET = "add_course_widget"

        // 冷启动时快捷方式标记（同一进程内多个实例共享）
        @Volatile
        private var pendingAddWidget = false
    }

    private var shortcutChannel: MethodChannel? = null
    private var shortcutIntentConsumed = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        shortcutChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        shortcutChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "consumeAddWidget" -> {
                    val fromIntent = !shortcutIntentConsumed && isAddWidgetIntent(intent)
                    val consumed = pendingAddWidget || fromIntent
                    pendingAddWidget = false
                    shortcutIntentConsumed = true
                    result.success(consumed)
                }
                "refreshCourseWidget" -> {
                    // App 内更新课表后主动刷新桌面课表小组件（进程内，避免广播被系统限制）
                    CourseWidgetProvider.updateAll(applicationContext)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
        // 冷启动：Flutter 引擎初始化时就能拿到快捷方式意图
        if (isAddWidgetIntent(intent)) {
            pendingAddWidget = true
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        // 热启动：App 已在后台/前台时通过快捷方式进入
        if (isAddWidgetIntent(intent)) {
            pendingAddWidget = true
            shortcutIntentConsumed = false
            shortcutChannel?.invokeMethod("addWidgetShortcut", null)
        }
    }

    override fun onResume() {
        super.onResume()
        // 回到前台时校正一次课表小组件，避免个别系统丢失刷新
        CourseWidgetProvider.updateAll(applicationContext)
    }

    private fun isAddWidgetIntent(intent: Intent?): Boolean {
        if (intent == null) return false
        if (intent.action == ACTION_ADD_COURSE_WIDGET) return true
        val data = intent.data ?: return false
        return data.scheme == SCHEME && data.host == HOST_ADD_COURSE_WIDGET
    }
}
