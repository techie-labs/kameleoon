<p align="center">
  <img src="banner.svg" width="100%" alt="Kameleoon - Kotlin Multiplatform Library Template Banner">
</p>

<p align="center">
  <a href="https://github.com/techie-labs/Kameleoon/actions"><img src="https://img.shields.io/github/actions/workflow/status/techie-labs/Kameleoon/build.yml?branch=main&logo=github&style=flat-square" alt="Build Status"></a>
  <a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=flat-square" alt="License"></a>
  <a href="https://kotlinlang.org"><img src="https://img.shields.io/badge/Kotlin-2.1.0-7F52FF.svg?style=flat-square&logo=kotlin" alt="Kotlin"></a>
  <a href="https://www.jetbrains.com/lp/compose-multiplatform/"><img src="https://img.shields.io/badge/Compose%20Multiplatform-1.7.0-4285F4.svg?style=flat-square&logo=jetpackcompose" alt="Compose Multiplatform"></a>
</p>

# Kameleoon 🦎
### The Ultimate Compose Multiplatform Library Template

**Kameleoon** is a production-ready, adaptive template designed to kickstart your **Kotlin Multiplatform (KMP)** and **Compose Multiplatform** library development. 

Stop wasting time on build configuration. Kameleoon provides a pre-configured environment targeting **Android**, **iOS**, **Desktop (JVM)**, and **Web (Wasm)**, complete with publishing, linting, and documentation tools.

---

## 🚀 Why Use Kameleoon?

*   **⚡️ Zero Configuration Setup**: Start writing code immediately, not Gradle scripts.
*   **📱 Cross-Platform Ready**: Targets Android, iOS, Desktop, and Web (Wasm) out of the box.
*   **📦 Maven Central Publishing**: Automated publishing workflow using `vanniktech-maven-publish`.
*   **Ui Kit Ready**: Pre-configured with Jetpack Compose / Compose Multiplatform for sharing UI.
*   **🛡️ Quality First**: Integrated Spotless (Ktlint), Detekt, and Binary Compatibility Validator.

## 📂 Project Structure

The project is modularized to separate the library logic from the sample applications:

*   **`/library`**: The core KMP module containing your shared code.
    *   `commonMain`: Shared business logic and UI.
    *   `androidMain`, `iosMain`, `jvmMain`, `wasmJsMain`: Platform-specific implementations.
*   **`/sample`**: A playground to test your library across all platforms.
    *   **`:sample:shared`**: Shared UI for the sample app.
    *   **`:sample:androidApp`**: Native Android application.
    *   **`:sample:iosApp`**: Native iOS application (Swift/Xcode).
    *   **`:sample:desktopApp`**: Desktop application (Windows/macOS/Linux).
    *   **`:sample:webApp`**: Web application running on WebAssembly (Wasm).

## 🛠 Tech Stack & Tools

*   **Language**: [Kotlin](https://kotlinlang.org/) (Latest)
*   **UI Framework**: [Compose Multiplatform](https://www.jetbrains.com/lp/compose-multiplatform/)
*   **Build System**: Gradle (Kotlin DSL) with Version Catalogs (`libs.versions.toml`)
*   **Documentation**: [Dokka](https://github.com/Kotlin/dokka)
*   **Code Quality**: [Spotless](https://github.com/diffplug/spotless), [Detekt](https://detekt.dev/)
*   **CI/CD**: GitHub Actions

## 🏁 Getting Started

### 1. Setup Environment

Run the setup script to prepare your local environment (creates `local.properties`, sets up git hooks):
```shell
./scripts/setup.sh
```

### 2. Rename and Configure
Update `library/build.gradle.kts` with your library's identity:
*   `mavenPublishing` block: Update `groupId`, `artifactId`, `version`.
*   `pom` block: Update licenses, developers, and SCM links.
*   `android` block: Update `namespace`.

### 3. Build and Run Sample

Test your library immediately on any platform:

**Android:**
```shell
./gradlew :sample:androidApp:installDebug
```

**iOS:**
Open `sample/iosApp/iosApp.xcodeproj` in Xcode and run on a simulator.

**Desktop:**
```shell
./gradlew :sample:desktopApp:run
```

**Web (Wasm):**
```shell
./gradlew :sample:webApp:wasmJsBrowserRun
```

## ✅ Code Quality & Workflow

Run the full quality check suite before pushing:
```shell
./scripts/run-workflow.sh
```

Or run individual checks:
*   **Format Code:** `./gradlew spotlessApply`
*   **Static Analysis:** `./gradlew detekt`
*   **API Compatibility:** `./gradlew apiCheck`
*   **Generate Docs:** `./gradlew dokkaHtml`

## 📦 Publishing

Kameleoon is pre-configured to publish to **Maven Central** (Sonatype) using the [Vanniktech Maven Publish Plugin](https://github.com/vanniktech/gradle-maven-publish-plugin).

### 1. Manual Publishing (Local)
For local testing or manual publishing:
1.  Configure your Sonatype (OSSRH) credentials in `local.properties` or environment variables.
2.  Run the publish task:
    ```shell
    ./gradlew publishToMavenCentral --no-configuration-cache
    ```

### 2. Automated Publishing (GitHub Actions)
The template includes a robust GitHub Action ([`publish.yml`](.github/workflows/publish.yml)) that is **tag-driven**. 

#### How it works:
*   Creating a **GitHub Release** with a tag like `v1.0.0-beta01` triggers the workflow.
*   The workflow automatically strips the `v` prefix and publishes version `1.0.0-beta01` to Maven Central.
*   This ensures your Git tags follow SemVer (with `v`) while your Maven artifacts follow Maven conventions (no `v`).

#### Required GitHub Secrets:
To use the automated workflow, you **MUST** configure the following [Repository Secrets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions) in your GitHub repository:

| Secret Name | Description |
| :--- | :--- |
| `MAVEN_CENTRAL_USERNAME` | Your Sonatype/Maven Central username. |
| `MAVEN_CENTRAL_PASSWORD` | Your Sonatype/Maven Central password. |
| `SIGNING_KEY` | Your **Base64 encoded** GPG private key. |
| `SIGNING_KEY_ID` | The last 8 characters of your GPG key ID. |
| `SIGNING_PASSWORD` | The passphrase for your GPG key. |

#### 🔑 How to Prepare GPG Keys
1.  **Generate a new key** (if you don't have one):
    ```shell
    gpg --full-generate-key
    ```
    *(Choose RSA/RSA 4096, and set a passphrase)*.

2.  **Get your Key ID**:
    ```shell
    gpg --list-secret-keys --keyid-format LONG
    ```
    Look for a line like: `sec rsa4096/ABCDEF1234567890`. Your ID is the last 8 characters: `34567890`.

3.  **Export and Encode to Base64**:
    ```shell
    gpg --export-secret-keys <YOUR_KEY_ID> | base64
    ```
    Copy the long string output and save it as `SIGNING_KEY` in GitHub Secrets.

4.  **Publish your Public Key** (Maven Central Needs this):
    ```shell
    gpg --keyserver keyserver.ubuntu.com --send-keys <YOUR_KEY_ID>
    ```

> [!TIP]
> You can also use other keyservers like `keys.openpgp.org` or `pgp.mit.edu`.

---

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

---

## 📄 License

Licensed under the [Apache 2.0 License](LICENSE).
