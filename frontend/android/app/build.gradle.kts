import java.util.Properties

val keystoreProperties = Properties().apply {
    val keystoreFile = file("../key.properties")
    if (keystoreFile.exists()) {
        keystoreFile.inputStream().use { this.load(it) }
    }
}

val dotenv = Properties().apply {
    val envFile = file("../../asset/config/.env")
    if (envFile.exists()) {
        envFile.inputStream().use { this.load(it) }
    }
}


plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {

    signingConfigs {
        create("release") {
            println("storeFile: ${keystoreProperties["storeFile"]}")
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
    }

    namespace = "com.bapful.onbapsang"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    buildFeatures {
        buildConfig = true;
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.bapful.onbapsang"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // BuildConfig에 추가 (네이티브 코드에서 사용)
        buildConfigField("String", "GOOGLE_MAPS_API_KEY", "\"${dotenv.getProperty("GOOGLE_MAPS_API_KEY", "")}\"")

        // 매니페스트에서 사용할 수 있도록 resValue로도 추가
        resValue("string", "google_maps_api_key", dotenv.getProperty("GOOGLE_MAPS_API_KEY", ""))

        println("🌍 GOOGLE_MAPS_API_KEY from dotenv = ${dotenv.getProperty("GOOGLE_MAPS_API_KEY")}")
    }

}

flutter {
    source = "../.."
}
