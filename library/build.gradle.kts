@file:OptIn(ExperimentalWasmDsl::class)

import org.jetbrains.kotlin.gradle.ExperimentalWasmDsl
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidLibrary)
    alias(libs.plugins.composeMultiplatform)
    alias(libs.plugins.composeCompiler)
    alias(libs.plugins.vanniktech.mavenPublish)
    alias(libs.plugins.dokka)
}

version = project.property("VERSION_NAME") as String
group = "io.techie.kameleoon"

// Maven Publish Configuration
mavenPublishing {
    coordinates(
        groupId = "io.techie.kameleoon",
        artifactId = "library",
    )
    publishToMavenCentral(automaticRelease = false)
    signAllPublications()

    pom {
        name.set("Kameleoon")
        description.set("An adaptive template for Compose Multiplatform Library")
        inceptionYear.set("2024")
        url.set("https://github.com/yourusername/kameleoon")

        licenses {
            license {
                name.set("The Apache License, Version 2.0")
                url.set("https://www.apache.org/licenses/LICENSE-2.0.txt")
                distribution.set("https://www.apache.org/licenses/LICENSE-2.0.txt")
            }
        }

        developers {
            developer {
                id.set("yourusername")
                name.set("Your Name")
                url.set("https://github.com/yourusername")
            }
        }

        scm {
            url.set("https://github.com/yourusername/kameleoon")
            connection.set("scm:git:git://github.com/yourusername/kameleoon.git")
            developerConnection.set("scm:git:ssh://git@github.com/yourusername/kameleoon.git")
        }
    }
}

kotlin {
    androidTarget {
        // Publish only release variant
        publishLibraryVariants("release")
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_11)
        }
    }

    // iOS Targets
    listOf(
        iosX64(),
        iosArm64(),
        iosSimulatorArm64(),
    ).forEach { iosTarget ->
        iosTarget.binaries.framework {
            baseName = "Kameleoon"
            isStatic = true
            // Explicitly set bundle ID to avoid warnings and potential build issues
            freeCompilerArgs += listOf("-Xbinary=bundleId=io.techie.kameleoon")
        }
    }

    // Desktop (JVM) Target
    jvm()

    // Web (Wasm) Target
    wasmJs {
        browser()
    }

    sourceSets {
        commonMain.dependencies {
            implementation(libs.compose.runtime)
            implementation(libs.compose.foundation)
            implementation(libs.compose.material3)
            implementation(libs.material.icons.extended)
            implementation(libs.compose.ui)
            implementation(libs.compose.components.resources)
        }
        commonTest.dependencies {
            implementation(libs.kotlin.test)
        }
    }
}

android {
    namespace = "io.techie.kameleoon"
    compileSdk = libs.versions.android.compileSdk.get().toInt()

    defaultConfig {
        minSdk = libs.versions.android.minSdk.get().toInt()
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
}
