plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseStoreFilePath = System.getenv("ZIMBA_RELEASE_STORE_FILE")
val releaseStorePassword = System.getenv("ZIMBA_RELEASE_STORE_PASSWORD")
val releaseKeyAlias = System.getenv("ZIMBA_RELEASE_KEY_ALIAS")
val releaseKeyPassword = System.getenv("ZIMBA_RELEASE_KEY_PASSWORD")
val hasPersonalReleaseSigning = listOf(
    releaseStoreFilePath,
    releaseStorePassword,
    releaseKeyAlias,
    releaseKeyPassword,
).all { !it.isNullOrBlank() }

android {
    namespace = "br.com.zimbacontrol.zimba_control"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "br.com.zimbacontrol.zimba_control"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    signingConfigs {
        if (hasPersonalReleaseSigning) {
            create("personalRelease") {
                storeFile = file(releaseStoreFilePath!!)
                storePassword = releaseStorePassword
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasPersonalReleaseSigning) {
                signingConfigs.getByName("personalRelease")
            } else {
                logger.warn(
                    "ZimbaControl: variaveis ZIMBA_RELEASE_* ausentes; " +
                        "gerando artefato diagnostico com chave de debug.",
                )
                signingConfigs.getByName("debug")
            }
        }
    }
}

dependencies {
    implementation("androidx.work:work-runtime-ktx:2.9.1")
    androidTestImplementation("androidx.test:core:1.6.1")
    androidTestImplementation("androidx.test.ext:junit:1.2.1")
    androidTestImplementation("androidx.test:runner:1.6.2")
}

flutter {
    source = "../.."
}
