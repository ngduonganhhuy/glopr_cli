# 🕵️ Holmes CLI

A command-line tool to scaffold Flutter apps using a custom template.

## 🚀 Features

- Create a new Flutter project from your own template
- Automatically replace placeholders like project name, bundle ID, description, etc.
- Text and binary file support
- Check development environment with `doctor` command
- Simple and extendable CLI

---

## 🛠 Installation

Clone this repo and activate locally:

```bash
git clone https://github.com/your-org/holmes_cli.git
cd holmes_cli
dart pub global activate --source path .
```

---

## 📦 Usage

### 📁 Create a New Project

Create a new Flutter project from your local template:

```bash
holmes create <project-name> [-o com.example.app]
```

#### Example:
```bash
holmes create my_app -o com.mycompany.myapp
```

You will be prompted to enter:

```bash
📝 App display name: My App
📝 App description: A beautiful Flutter app built with Holmes CLI.
```

Then the CLI will:

- Copy the template from the local `template/` directory
- Replace placeholders in file names and content:
  - `__project_name__` → `my_app`
  - `__app_name__` → `My App`
  - `__description__` → `A beautiful Flutter app built with Holmes CLI.`
  - `__bundle_id__` → `com.mycompany.myapp`
- Print status for each copied file:
  ```bash
  🚀 Generating project "my_app"...
  📄 Copied text:  pubspec.yaml
  📄 Copied text:  lib/main.dart
  🖼️  Copied binary: assets/icon.png
  ✅ Project generated successfully!
  ```

---

### 🩺 Run Doctor

Check your environment for Flutter and Dart:

```bash
holmes doctor
```

#### Output:
```bash
🔍 Running doctor...
Flutter:
Flutter 3.32.7 • channel stable • https://flutter.dev
Dart:
Dart SDK version: 3.8.1 (stable)
✅ Environment check complete.
```

---

### 🔎 Show Version

Check the current CLI version:

```bash
holmes --version
```

#### Output:
```bash
holmes_cli version 1.0.0
```

---

### 🆘 Show Help

Display available commands and options:

```bash
holmes --help
```

#### Output:
```bash
Holmes CLI
Create a Flutter project from your custom template

Usage:
  holmes create <project_name> [-o com.example.app]
  holmes -v | --version
  holmes -h | --help
  holmes doctor

Options:
  -o, --org       Set the bundleId (e.g., com.example.app)
  -v, --version   Show CLI version
  -h, --help      Show this help message

Commands:
  create          Generate a new Flutter project based on template
  doctor          Check system requirements
```

---

## 🧪 Example Template Structure

```
template/
├── main.dart                        # Entry point of the app
├── injection_container.dart         # Dependency injection setup (e.g., GetIt)
├── core/                            # Core-level utilities and services
│   ├── constants/                   # App-wide constant values
│   ├── env/                         # Environment-specific configuration
│   ├── error/                       # Error handling and exceptions
│   ├── extensions/                  # Dart extensions (e.g., StringX)
│   ├── impl/                        # Concrete implementations of services
│   ├── services/                    # Abstract service definitions
│   ├── themes/                      # App themes and color schemes
│   └── utils/                       # Generic utility functions
├── core_bloc/                       # Global BLoC (e.g., theme switching)
│   └── theme/                       # Theme-related BLoC logic
├── data/                            # Data layer of Clean Architecture
│   ├── data_sources/                # Remote/local data fetching logic
│   ├── models/                      # Data models and DTOs
│   └── repositories/                # Data access abstraction
├── dialogs/                         # Global/custom dialogs
│   └── alert_dialog/               # Custom alert dialog implementation
├── domain/                          # Domain layer: business logic
│   ├── entities/                    # Core business entities
│   └── usecases/                    # Application-specific use cases
├── presentation/                    # UI and BLoC logic
│   ├── bloc/                        # Presentation-specific BLoC
│   └── pages/                       # Screens and pages
├── root/                            # App configuration and entry points
│   ├── app/                         # App widget and app-level config
│   ├── bootstrap.dart               # Bootstrapping the app
│   ├── l10n/                        # Localization support
│   ├── main_development.dart        # Entry point for development build
│   └── main_production.dart         # Entry point for production build
├── widgets/                         # Reusable UI components
│   ├── app_safe_area.dart           # Wrapper for safe UI rendering
│   └── app_text.dart                # Custom text widget

```

---

## ✅ License

MIT — feel free to use, modify, and distribute.

---

## 👨‍💻 Author

Made with ❤️ by [Holmes](https://github.com/ngduonganhhuy)

---

## 👨‍💻 Portfolio

[Holmes](https://holmes.id.vn)
