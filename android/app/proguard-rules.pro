# ---------------------------------------------------------------------------
# flutter_local_notifications (Protección estricta para producción)
# ---------------------------------------------------------------------------
-keep class com.dexterous.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }

-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable

# ---------------------------------------------------------------------------
# GSON (usado internamente por el plugin de notificaciones)
# ---------------------------------------------------------------------------
-keepclassmembers class com.google.gson.** { *; }
-keep class com.google.gson.stream.** { *; }
-dontwarn org.checkerframework.**
-dontwarn com.google.errorprone.annotations.**