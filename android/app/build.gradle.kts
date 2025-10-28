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
        minSdk = (rootProject.extra["flutter.minSdkVersion"] as? String ?: "23").toInt()
        targetSdk = (rootProject.extra["flutter.targetSdkVersion"] as? String ?: "35").toInt()
        versionCode = (rootProject.extra["flutter.versionCode"] as? String ?: "1").toInt()
        versionName = rootProject.extra["flutter.versionName"] as? String ?: "1.0.0"
    }

    signingConfigs {
        create("release") {
            storeFile = file(rootProject.extra["KEYSTORE_FILE"] as? String ?: "keystore.jks")
            storePassword = rootProject.extra["KEYSTORE_PASSWORD"] as? String ?: ""
            keyAlias = rootProject.extra["KEY_ALIAS"] as? String ?: ""
            keyPassword = rootProject.extra["KEY_PASSWORD"] as? String ?: ""
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

