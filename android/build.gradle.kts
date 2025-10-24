// <<<<<<< 1. دو خط import زیر اضافه شده است >>>>>>>>>
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    // id("dev.flutter.flutter-gradle-plugin") // <<<<<<<<<< این خط برای رفع خطا حذف شد
}

// <<<<<<< 2. این بلوک با سینتکس Kotlin بازنویسی شده است >>>>>>>>>
// کد خواندن فایل key.properties
val keystorePropertiesFile = rootProject.file("../android/key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
// <<<<<<< پایان تغییر 2 >>>>>>>>>


android {
    namespace = "com.example.aquaviva"
    compileSdk = 35
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.aquaviva"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // <<<<<<< 3. این بلوک با سینتکس Kotlin اضافه شده است >>>>>>>>>
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }
    // <<<<<<< پایان تغییر 3 >>>>>>>>>

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.

            // <<<<<<< 4. این خط برای استفاده از امضای release تغییر کرده است >>>>>>>>>
            // signingConfig = signingConfigs.getByName("debug") // خط قبلی
            signingConfig = signingConfigs.getByName("release") // خط جدید
        }
    }
}

flutter {
    source = "../.."
}