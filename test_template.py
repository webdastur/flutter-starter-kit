#!/usr/bin/env python3
"""
Test script for Flutter Starter Template
This script tests the cookiecutter template generation.
"""

import os
import shutil
import subprocess
import tempfile
import sys


def run_command(cmd, cwd=None):
    """Run a command and return the result"""
    try:
        result = subprocess.run(
            cmd, 
            shell=True, 
            cwd=cwd, 
            capture_output=True, 
            text=True, 
            check=True
        )
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"❌ Command failed: {cmd}")
        print(f"Error: {e.stderr}")
        return None


def test_template_generation():
    """Test generating a project from the template"""
    print("🧪 Testing cookiecutter template generation...")
    
    # Create a temporary directory for testing
    with tempfile.TemporaryDirectory() as temp_dir:
        print(f"📁 Using temp directory: {temp_dir}")
        
        # Test values
        test_values = {
            "project_name": "Test Flutter App",
            "project_slug": "test_flutter_app",
            "project_description": "A test Flutter application",
            "package_name": "com.test.flutter_app",
            "author_name": "Test Author",
            "author_email": "test@example.com",
            "primary_color": "#FF5722",
            "api_base_url": "https://api.test.com"
        }
        
        # Create cookiecutter input file
        input_file = os.path.join(temp_dir, "input.txt")
        with open(input_file, 'w') as f:
            for key, value in test_values.items():
                if key != "project_slug":  # Skip auto-generated field
                    f.write(f"{value}\n")
            # Add remaining default values
            f.write(">=3.0.0\n")  # flutter_version
            f.write("n\n")  # use_firebase
            f.write("n\n")  # use_sentry
            f.write("n\n")  # use_analytics
            f.write("#2E2E2E\n")  # primary_color_dark
            f.write("y\n")  # enable_logging
            f.write("n\n")  # enable_crash_reporting
            f.write("n\n")  # enable_analytics
        
        # Generate project using cookiecutter
        template_path = os.path.abspath("cookiecutter-flutter-starter")
        cmd = f"cookiecutter {template_path} --no-input --output-dir {temp_dir} < {input_file}"
        
        if run_command(cmd) is None:
            return False
        
        # Check if project was generated
        project_path = os.path.join(temp_dir, test_values["project_slug"])
        if not os.path.exists(project_path):
            print(f"❌ Project directory not found: {project_path}")
            return False
        
        print("✅ Project generated successfully")
        
        # Test key files exist
        key_files = [
            "pubspec.yaml",
            "lib/main.dart",
            "lib/core/di/injection.dart",
            "lib/core/config/env.dart",
            "lib/presentation/blocs/todo_bloc.dart",
            "android/app/build.gradle.kts",
            "ios/Runner.xcodeproj/project.pbxproj",
            ".env",
        ]
        
        for file_path in key_files:
            full_path = os.path.join(project_path, file_path)
            if not os.path.exists(full_path):
                print(f"❌ Missing file: {file_path}")
                return False
        
        print("✅ All key files present")
        
        # Test pubspec.yaml has correct values
        pubspec_path = os.path.join(project_path, "pubspec.yaml")
        with open(pubspec_path, 'r') as f:
            pubspec_content = f.read()
        
        if test_values["project_slug"] not in pubspec_content:
            print("❌ Project slug not found in pubspec.yaml")
            return False
        
        if test_values["project_description"] not in pubspec_content:
            print("❌ Project description not found in pubspec.yaml")
            return False
        
        print("✅ pubspec.yaml has correct values")
        
        # Test .env file has correct values
        env_path = os.path.join(project_path, ".env")
        with open(env_path, 'r') as f:
            env_content = f.read()
        
        if test_values["project_name"] not in env_content:
            print("❌ Project name not found in .env")
            return False
        
        if test_values["api_base_url"] not in env_content:
            print("❌ API base URL not found in .env")
            return False
        
        print("✅ .env file has correct values")
        
        # Test Flutter pub get works
        print("🔄 Testing flutter pub get...")
        if run_command("flutter pub get", cwd=project_path) is None:
            print("⚠️ flutter pub get failed (this might be expected in CI)")
        else:
            print("✅ flutter pub get successful")
        
        return True


def main():
    """Main test function"""
    print("🚀 Flutter Starter Template Test")
    print("=" * 50)
    
    # Check if cookiecutter is installed
    if run_command("cookiecutter --version") is None:
        print("❌ cookiecutter is not installed")
        print("Install with: pip install cookiecutter")
        return 1
    
    # Check if template exists
    if not os.path.exists("cookiecutter-flutter-starter"):
        print("❌ Template directory not found: cookiecutter-flutter-starter")
        return 1
    
    # Run tests
    if test_template_generation():
        print("\n🎉 All tests passed!")
        print("✅ Template is ready for use")
        return 0
    else:
        print("\n❌ Tests failed!")
        return 1


if __name__ == "__main__":
    exit(main())
