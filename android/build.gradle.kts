import java.util.Properties
import java.io.FileInputStream

// <<<<<<< 1. این قسمت برای خواندن local.properties اضافه شده است >>>>>>>>>
val localPropertiesFile = rootProject.file("../android/local.properties")
val localProperties = Properties()
if (localPropertiesFile.exists()) {
    localProperties.load(FileInputStream(localPropertiesFile))
}
// <<<<<<< پایان قسمت 1 >>>>>>>>>


plugins {
    id("com.android.application")
    id("kotlin-android")
    // id("dev.flutter.flutter-gradle-plugin") // این خط همانطور که گفتیم حذف می‌ماند
}

// <<<<<<< 2. این قسمت برای خواندن key.properties (امضا) است >>>>>>>>>
val keystorePropertiesFile = rootProject.file("../android/key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
// <<<<<<< پایان قسمت 2 >>>>>>>>>


android {
    namespace = "com.example.aquaviva"

    // <<<<<<< 3. مقادیر از local.properties خوانده می‌شوند >>>>>>>>>
    compileSdk = 35 // این مقدار ثابت است
    ndkVersion = localProperties.getProperty("flutter.ndkVersion")
    // <<<<<<< پایان قسمت 3 >>>>>>>>>

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.aquaviva"

        // <<<<<<< 4. مقادیر از local.properties خوانده می‌شوند >>>>>>>>>
        minSdk = localProperties.getProperty("flutter.minSdkVersion").toInt()
        targetSdk = localProperties.getProperty("flutter.targetSdkVersion").toInt()
        versionCode = localProperties.getProperty("flutter.versionCode").toInt()
        versionName = localProperties.getProperty("flutter.versionName")
        // <<<<<<< پایان قسمت 4 >>>>>>>>>
    }

    // <<<<<<< 5. قسمت امضا (این قسمت صحیح بود) >>>>>>>>>
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
    // <<<<<<< پایان قسمت 5 >>>>>>>>>

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

// <<<<<<< 6. بلوک flutter { ... } در این ساختار جدید حذف می‌شود >>>>>>>>>
// flutter {
//     source = "../.."
// }