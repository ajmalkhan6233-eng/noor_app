allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Some plugin modules (e.g. older sensors_plus releases) hardcode their own
// compileSdk, independent of this app module's compileSdk override — a
// mismatch between a plugin's compileSdk and its AndroidX dependencies'
// minimum-required compileSdk fails `checkReleaseAarMetadata` at build time.
// Force every subproject (application and library modules alike) onto the
// same compileSdk/minSdk this app targets, so a plugin's own choice can never
// desync from ours again.
subprojects {
    afterEvaluate {
        extensions.findByType(com.android.build.api.dsl.CommonExtension::class.java)?.let { android ->
            android.compileSdk = 36
            val currentMinSdk = android.defaultConfig.minSdk
            if (currentMinSdk == null || currentMinSdk < 23) {
                android.defaultConfig.minSdk = 23
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
