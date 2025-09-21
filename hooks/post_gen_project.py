#!/usr/bin/env python3
"""
Post-generation hook for Flutter Starter Template
This script runs after cookiecutter generates the project files.
"""

import os
import shutil
import subprocess


def create_env_file():
    """Create .env file from template values"""
    env_content = """# Environment variables for {{ cookiecutter.project_name }}
API_BASE_URL={{ cookiecutter.api_base_url }}
API_TIMEOUT=30000
APP_NAME={{ cookiecutter.project_name }}
APP_VERSION=1.0.0
DEBUG_MODE=true
ENABLE_LOGGING={{ cookiecutter.enable_logging }}
ENABLE_CRASH_REPORTING={{ cookiecutter.enable_crash_reporting }}
ENABLE_ANALYTICS={{ cookiecutter.enable_analytics }}
FIREBASE_API_KEY=
SENTRY_DSN=
MIXPANEL_TOKEN=
"""
    
    with open('.env', 'w') as f:
        f.write(env_content)
    print("✅ Created .env file")


def setup_android_structure():
    """Set up Android package structure"""
    package_name = "{{ cookiecutter.package_name }}"
    package_path = package_name.replace('.', '/')
    
    # Remove any old directory structure first (but preserve template)
    old_kotlin_dir = "android/app/src/main/kotlin/com"
    if os.path.exists(old_kotlin_dir):
        shutil.rmtree(old_kotlin_dir)
        print("✅ Cleaned up old Android package structure")
    
    # Create package directory structure
    kotlin_dir = f"android/app/src/main/kotlin/{package_path}"
    os.makedirs(kotlin_dir, exist_ok=True)
    print(f"✅ Created kotlin directory: {kotlin_dir}")
    
    # Move MainActivity.kt.template to correct location or create if missing
    template_path = "android/app/src/main/kotlin/MainActivity.kt.template"
    target_path = f"{kotlin_dir}/MainActivity.kt"
    
    if os.path.exists(template_path):
        # Move the template file to the correct package location
        shutil.move(template_path, target_path)
        print(f"✅ Moved MainActivity.kt from template to {kotlin_dir}")
    else:
        # Fallback: create MainActivity.kt directly if template is missing
        main_activity_content = (
            f"package {package_name}\n\n"
            "import io.flutter.embedding.android.FlutterActivity\n\n"
            "class MainActivity : FlutterActivity()\n"
        )
        with open(target_path, "w") as f:
            f.write(main_activity_content)
        print(f"✅ Created MainActivity.kt in {kotlin_dir} (fallback)")
    
    # Verify the file was created
    if os.path.exists(target_path):
        print(f"✅ MainActivity.kt verified at: {target_path}")
        with open(target_path, 'r') as f:
            content = f.read()
            print(f"📄 Content preview: {content[:100]}...")
    else:
        print(f"❌ MainActivity.kt NOT found at: {target_path}")


def clean_generated_files():
    """Clean up template and generated files"""
    files_to_remove = [
        "android/app/src/main/kotlin/MainActivity.kt.template",
        # Remove any .g.dart files that need regeneration
        "lib/core/config/env.g.dart",
        "lib/data/models/todo_model.g.dart",
        "lib/data/datasources/remote/todo_remote_datasource.g.dart",
    ]
    
    for file_path in files_to_remove:
        if os.path.exists(file_path):
            os.remove(file_path)
            print(f"✅ Removed {file_path}")


def setup_gitignore():
    """Ensure .env is in .gitignore"""
    gitignore_path = ".gitignore"
    env_entry = "\n# Environment variables\n.env\n"
    
    if os.path.exists(gitignore_path):
        with open(gitignore_path, 'r') as f:
            content = f.read()
        
        if '.env' not in content:
            with open(gitignore_path, 'a') as f:
                f.write(env_entry)
            print("✅ Added .env to .gitignore")
    else:
        with open(gitignore_path, 'w') as f:
            f.write(env_entry)
        print("✅ Created .gitignore with .env entry")


def show_next_steps():
    """Display next steps for the user"""
    project_name = "{{ cookiecutter.project_name }}"
    project_slug = "{{ cookiecutter.project_slug }}"
    
    print("\n" + "="*60)
    print(f"🎉 {project_name} Flutter project created successfully!")
    print("="*60)
    print("\n📋 Next Steps:")
    print(f"1. cd {project_slug}")
    print("2. flutter pub get")
    print("3. flutter packages pub run build_runner build")
    print("4. flutter pub run flutter_native_splash:create")
    print("5. flutter run")
    
    print("\n🔧 Configuration:")
    print("• Update .env file with your API keys and settings")
    print("• Replace splash screen images in assets/images/")
    print("• Customize colors in pubspec.yaml flutter_native_splash section")
    
    print("\n📚 Architecture Features:")
    print("• ✅ Clean Architecture (Domain, Data, Presentation)")
    print("• ✅ BLoC State Management")
    print("• ✅ Dependency Injection (get_it + injectable)")
    print("• ✅ Local Storage (Hive)")
    print("• ✅ Network Layer (Dio + Retrofit)")
    print("• ✅ Environment Configuration (Envied)")
    print("• ✅ Native Splash Screens")
    print("• ✅ Responsive Design (ScreenUtil)")
    print("• ✅ Form Validation (Formz)")
    print("• ✅ Flutter Hooks")
    print("• ✅ Advanced Logging (Talker)")
    print("• ✅ Navigation (GoRouter)")
    print("• ✅ Internationalization (EasyLocalization)")
    
    print("\n🚀 Happy Coding!")
    print("="*60)


def main():
    """Main post-generation script"""
    print("🔧 Setting up Flutter project...")
    
    try:
        create_env_file()
        setup_android_structure()
        clean_generated_files()
        setup_gitignore()
        show_next_steps()
    except Exception as e:
        print(f"❌ Error during setup: {e}")
        return 1
    
    return 0


if __name__ == "__main__":
    exit(main())
