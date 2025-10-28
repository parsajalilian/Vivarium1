plugins {
    id("com.android.application")
    kotlin("android")
    id("dev.flutter.flutter-gradle-plugin")
}
android {
    namespace = "com.example.aquaviva"
    compileSdk = 35
    ndkVersion = "26.1.10909125"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.aquaviva"
        minSdk = (rootProject.extra.get("flutter.minSdkVersion") as String).toInt()
        targetSdk = (rootProject.extra.get("flutter.targetSdkVersion") as String).toInt()
        versionCode = (rootProject.extra.get("flutter.versionCode") as String).toInt()
        versionName = rootProject.extra.get("flutter.versionName") as String
    }

    signingConfigs {
        create("release") {
            storeFile = file(rootProject.extra.get("KEYSTORE_FILE") as String)
            storePassword = rootProject.extra.get("KEYSTORE_PASSWORD") as String
            keyAlias = rootProject.extra.get("KEY_ALIAS") as String
            keyPassword = rootProject.extra.get("KEY_PASSWORD") as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            proguardFiles(
                    getDefaultProguardFile("proguard-android-optimize.txt"),
                    "proguard-rules.pro"
            )
        }
    }
}