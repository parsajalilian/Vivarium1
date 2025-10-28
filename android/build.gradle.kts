import java.io.FileInputStream
import java.util.Properties

val localProperties = Properties()
val localPropertiesFile = project.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { localProperties.load(it) }
}

val keystoreProperties = Properties()
val keystorePropertiesFile = project.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

extra.apply {
    set("flutter.ndkVersion", localProperties.getProperty("flutter.ndkVersion"))
    set("flutter.minSdkVersion", localProperties.getProperty("flutter.minSdkVersion"))
    set("flutter.targetSdkVersion", localProperties.getProperty("flutter.targetSdkVersion"))
    set("flutter.versionCode", localProperties.getProperty("flutter.versionCode"))
    set("flutter.versionName", localProperties.getProperty("flutter.versionName"))

    set("KEYSTORE_FILE", keystoreProperties.getProperty("storeFile"))
    set("KEYSTORE_PASSWORD", keystoreProperties.getProperty("storePassword"))
    set("KEY_ALIAS", keystoreProperties.getProperty("keyAlias"))
    set("KEY_PASSWORD", keystoreProperties.getProperty("keyPassword"))
}

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.4.2")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0")

    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}