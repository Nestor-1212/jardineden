plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.jardindeleden.app"
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
        applicationId = "com.jardindeleden.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO(DevOps): reemplazar por un signingConfig real de release
            // antes de distribuir staging/production fuera del equipo — ver
            // core/config/app_config.dart y la explicación de ambientes para
            // el resto de la infraestructura ya preparada. Firmar con la key
            // de debug es aceptable SOLO mientras nada sale del dispositivo
            // de desarrollo (situación actual: únicamente development en uso).
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // ── Flavors por Ambiente ───────────────────────────────────────────────
    //
    // Los 4 ambientes del proyecto (ver core/config/app_environment.dart)
    // como flavors NATIVOS de Android — permite instalar los 4 a la vez en
    // el mismo dispositivo/emulador (cada uno con su propio applicationId,
    // así que Android los trata como apps distintas) y que QA/staging
    // prueben un APK con el mismo tipo de build (`release`) que producción,
    // no un debug build disfrazado.
    //
    // El nombre del flavor SIEMPRE se empareja con `--dart-define=ENV=...`
    // y con el entry point lib/main_<flavor>.dart correspondiente — ver
    // bootstrap.dart. Gradle no sabe nada de AppEnvironment; son dos
    // mecanismos independientes que el desarrollador (o .vscode/launch.json)
    // mantiene sincronizados al invocar `flutter run`/`flutter build`.
    flavorDimensions += "environment"
    productFlavors {
        create("development") {
            dimension = "environment"
            // Sufijo de id y de nombre para que development/qa/staging
            // convivan instaladas junto a production sin sobreescribirse.
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue(type = "string", name = "app_name", value = "Jardín del Edén Dev")
        }
        create("qa") {
            dimension = "environment"
            applicationIdSuffix = ".qa"
            versionNameSuffix = "-qa"
            resValue(type = "string", name = "app_name", value = "Jardín del Edén QA")
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue(type = "string", name = "app_name", value = "Jardín del Edén Staging")
        }
        create("production") {
            dimension = "environment"
            // Sin sufijo — production es el único id que se publica en
            // Google Play, debe coincidir con AppConfig.packageName para
            // AppEnvironment.prod ('com.jardindeleden.app').
            resValue(type = "string", name = "app_name", value = "Jardín del Edén")
        }
    }
}

flutter {
    source = "../.."
}
