<<<<<<< HEAD
﻿pluginManagement {
=======
pluginManagement {
>>>>>>> 0b27c079cf8b9a58e434594887fafe3da769a182
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }
<<<<<<< HEAD
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
=======

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

>>>>>>> 0b27c079cf8b9a58e434594887fafe3da769a182
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
<<<<<<< HEAD
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.1.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.0" apply false
}
=======

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

>>>>>>> 0b27c079cf8b9a58e434594887fafe3da769a182
include(":app")
