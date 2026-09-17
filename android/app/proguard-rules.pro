# ===== Flutter =====
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.**

# ===== 保留 native 方法 =====
-keepclasseswithmembernames class * {
    native <methods>;
}

# 保留反射/注解相关属性
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod

# ===== HMS ScanKit（打水扫码，内含 j2v8 反射调用）=====
-keep class com.huawei.** { *; }
-keep class com.eclipsesource.v8.** { *; }
-dontwarn com.huawei.**
-dontwarn com.eclipsesource.v8.**

# ===== 腾讯 SDK（QQ 登录/分享 tencent_kit）=====
-keep class com.tencent.** { *; }
-keep class com.tauth.** { *; }
-dontwarn com.tencent.**
-dontwarn com.tauth.**

# ===== 微信 SDK（fluwx）=====
-keep class com.tencent.mm.opensdk.** { *; }
-keep class com.tencent.wxop.** { *; }
-keep class com.tencent.mm.** { *; }
-keep class net.sourceforge.simcpux.** { *; }

# ===== 桌面小组件（home_widget）=====
-keep class es.antonborri.home_widget.** { *; }

# ===== sqflite / floor 数据库 =====
-keep class com.tekartik.sqflite.** { *; }

# ===== 其它常见反射库 =====
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**
-keep class org.json.** { *; }
-dontwarn org.json.**
-dontwarn okhttp3.**
-dontwarn okio.**
