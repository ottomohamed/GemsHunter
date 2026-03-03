<<<<<<< HEAD
import java.util.Properties
import java.io.FileInputStream

=======
>>>>>>> 0b27c079cf8b9a58e434594887fafe3da769a182
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

<<<<<<< HEAD
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

=======
>>>>>>> 0b27c079cf8b9a58e434594887fafe3da769a182
android {
    namespace = "com.otto.neon.gems"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.otto.neon.gems"
<<<<<<< HEAD
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = 7 // Incremented for the new store upload attempt
        versionName = "1.3.0"
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
=======
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = 6
        versionName = "1.2.0"
>>>>>>> 0b27c079cf8b9a58e434594887fafe3da769a182
    }

    buildTypes {
        release {
<<<<<<< HEAD
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true // Enabled for production
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
=======
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
>>>>>>> 0b27c079cf8b9a58e434594887fafe3da769a182
        }
    }
}

flutter {
    source = "../.."
}
