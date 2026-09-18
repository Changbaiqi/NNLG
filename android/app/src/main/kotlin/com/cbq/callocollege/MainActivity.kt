package com.cbq.callocollege

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.cbq.callocollege/shortcut"
        private const val SHARE_CHANNEL = "com.cbq.callocollege/share"
        const val ACTION_ADD_COURSE_WIDGET = "com.cbq.callocollege.action.ADD_COURSE_WIDGET"
        private const val SCHEME = "callo"
        private const val HOST_ADD_COURSE_WIDGET = "add_course_widget"

        // 冷启动时快捷方式标记（同一进程内多个实例共享）
        @Volatile
        private var pendingAddWidget = false

        // 系统分享进来的图片路径（冷启动时暂存，等 Dart 侧取走）
        @Volatile
        private var pendingSharedImagePath: String? = null
    }

    private var shortcutChannel: MethodChannel? = null
    private var shareChannel: MethodChannel? = null
    private var shortcutIntentConsumed = false
    private var shareIntentConsumed = false

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
        // 系统分享图片的通道
        shareChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SHARE_CHANNEL)
        shareChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "consumeSharedImage" -> {
                    if (!shareIntentConsumed) {
                        handleShareIntent(intent)
                    }
                    shareIntentConsumed = true
                    val path = pendingSharedImagePath
                    pendingSharedImagePath = null
                    result.success(path)
                }
                else -> result.notImplemented()
            }
        }
        // 冷启动：Flutter 引擎初始化时就能拿到快捷方式意图
        if (isAddWidgetIntent(intent)) {
            pendingAddWidget = true
        }
        // 冷启动：处理系统分享进来的图片
        if (!shareIntentConsumed) {
            handleShareIntent(intent)
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
        // 热启动：从相册等应用分享图片进来
        val sharedPath = handleShareIntent(intent)
        if (sharedPath != null) {
            shareIntentConsumed = false
            shareChannel?.invokeMethod("sharedImageReceived", sharedPath)
        }
    }

    /**
     * 处理系统分享进来的图片：拷贝到缓存目录并返回路径。
     * 对应的 content:// 只在本 Activity 授权期间可读，必须立即拷贝。
     */
    private fun handleShareIntent(intent: Intent?): String? {
        if (intent == null) return null
        if (intent.action != Intent.ACTION_SEND) return null
        val type = intent.type ?: return null
        if (!type.startsWith("image/")) return null
        val sharedUri: Uri = if (Build.VERSION.SDK_INT >= 33) {
            intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.getParcelableExtra(Intent.EXTRA_STREAM) as? Uri
        } ?: return null
        return try {
            val dir = File(cacheDir, "shared_images").apply { mkdirs() }
            val file = File(dir, "shared_${System.currentTimeMillis()}.jpg")
            contentResolver.openInputStream(sharedUri)?.use { input ->
                file.outputStream().use { output -> input.copyTo(output) }
            } ?: return null
            pendingSharedImagePath = file.absolutePath
            // 避免重复处理同一个意图
            intent.action = null
            file.absolutePath
        } catch (e: Exception) {
            Log.e("MainActivity", "handleShareIntent failed", e)
            null
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
