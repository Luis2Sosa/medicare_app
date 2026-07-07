# ---------------------------------------------------------------------------
# flutter_local_notifications
# ---------------------------------------------------------------------------
-keep class com.dexterous.** { *; }
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable

# ---------------------------------------------------------------------------
# GSON (usado internamente por flutter_local_notifications)
# ---------------------------------------------------------------------------
-keepclassmembers class com.google.gson.** { *; }
-keep class com.google.gson.stream.** { *; }
-dontwarn org.checkerframework.**
-dontwarn com.google.errorprone.annotations.**