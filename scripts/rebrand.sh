#!/bin/bash

# Exit on error
set -e

echo "🦎 Project Rebranding Tool for Kameleoon Template"
echo "------------------------------------------------"

# 1. Gather Input
read -p "Enter New Project Name (e.g., MyLibrary) [Kameleoon]: " PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-Kameleoon}

read -p "Enter New Package Name (e.g., io.techie.mylibrary) [io.techie.kameleoon]: " PACKAGE_NAME
PACKAGE_NAME=${PACKAGE_NAME:-io.techie.kameleoon}

read -p "Enter Repository URL [https://github.com/yourusername/kameleoon]: " REPO_URL
REPO_URL=${REPO_URL:-https://github.com/yourusername/kameleoon}

read -p "Enter Developer Name [Your Name]: " DEV_NAME
DEV_NAME=${DEV_NAME:-Your Name}

read -p "Enter Developer ID [your-id]: " DEV_ID
DEV_ID=${DEV_ID:-your-id}

echo ""
echo "Configuration Summary:"
echo "Project Name: $PROJECT_NAME"
echo "Package Name: $PACKAGE_NAME"
echo "Repository URL: $REPO_URL"
echo "Developer Name: $DEV_NAME"
echo "Developer ID: $DEV_ID"
echo ""

read -p "Proceed with rebranding? (y/n): " PROCEED
if [[ ! $PROCEED =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# 2. String Replacements
OLD_PROJECT="Kameleoon"
OLD_PACKAGE="io.techie.kameleoon"
OLD_PROJECT_LOWER=$(echo "$OLD_PROJECT" | tr '[:upper:]' '[:lower:]')
PROJECT_NAME_LOWER=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]')

echo "Refactoring strings..."

# Replace package name in all files
grep -rli "$OLD_PACKAGE" . --exclude-dir={.git,.gradle,.idea,build} | xargs -I@ sed -i '' "s/$OLD_PACKAGE/$PACKAGE_NAME/g" @

# Replace project name in all files (case-sensitive)
# Note: This might replace common words, but in this template "Kameleoon" is specific enough.
grep -rli "$OLD_PROJECT" . --exclude-dir={.git,.gradle,.idea,build,scripts} | xargs -I@ sed -i '' "s/$OLD_PROJECT/$PROJECT_NAME/g" @

# Replace lower-case project name (often used in artifacts/folders)
grep -rli "$OLD_PROJECT_LOWER" . --exclude-dir={.git,.gradle,.idea,build,scripts} | xargs -I@ sed -i '' "s/$OLD_PROJECT_LOWER/$PROJECT_NAME_LOWER/g" @

# Update Repository and Developer Info (specific replacements for library/build.gradle.kts)
sed -i '' "s|https://github.com/yourusername/kameleoon|$REPO_URL|g" library/build.gradle.kts
# Match the dummy developer lines if they exist, or just rely on the general replacement if they are placeholders.

# 3. Directory Refactoring
echo "Refactoring directories..."

OLD_PACKAGE_PATH=$(echo "$OLD_PACKAGE" | tr '.' '/')
NEW_PACKAGE_PATH=$(echo "$PACKAGE_NAME" | tr '.' '/')

# Find all directories that match the old package path structure
# and move files to the new structure.
find . -type d -path "*/src/*/kotlin/$OLD_PACKAGE_PATH" | while read -r source_dir; do
    target_root=$(echo "$source_dir" | sed "s|$OLD_PACKAGE_PATH||")
    target_dir="$target_root$NEW_PACKAGE_PATH"
    
    echo "Moving $source_dir to $target_dir"
    mkdir -p "$target_dir"
    mv "$source_dir"/* "$target_dir" 2>/dev/null || true
    # Remove old empty parent directories if they are empty
    rmdir -p "$source_dir" 2>/dev/null || true
done

# Handle other cases like androidApp where path might be different or special
# (The above find handles mostly standard source sets)

echo ""
echo "✅ Rebranding complete! Please verify with: './gradlew build'"
echo "You may want to remove this script now."
