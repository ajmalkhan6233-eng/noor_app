# Noor app — ProGuard / R8 keep rules
# Generated 2026-09-07. Update if you add a plugin that does reflection
# (check the plugin's own README for its required keep rules).

# ── Flutter engine ────────────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.plugin.** { *; }
-dontwarn io.flutter.**

# ── flutter_local_notifications ───────────────────────────────────────
# Required per https://pub.dev/packages/flutter_local_notifications
-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**

# Gson (used internally by flutter_local_notifications for notification
# scheduling serialisation — must survive shrinking)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# ── sqflite / sqflite_sqlcipher ───────────────────────────────────────
# SQLCipher native bridge — must not be stripped
-keep class net.sqlcipher.** { *; }
-dontwarn net.sqlcipher.**
-keep class com.tekartik.sqflite.** { *; }
-dontwarn com.tekartik.sqflite.**

# ── audioplayers ──────────────────────────────────────────────────────
# Required per https://pub.dev/packages/audioplayers
-keep class xyz.luan.audioplayers.** { *; }
-dontwarn xyz.luan.audioplayers.**

# ── path_provider ─────────────────────────────────────────────────────
-keep class io.flutter.plugins.pathprovider.** { *; }
-dontwarn io.flutter.plugins.pathprovider.**

# ── General Android / Kotlin reflection safety ────────────────────────
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
