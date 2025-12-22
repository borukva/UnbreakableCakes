#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <new-project-name>"
    echo "Example: $0 my-cool-mod"
    exit 1
fi

NEW_NAME="$1"
NEW_NAME_UNDERSCORE="${NEW_NAME//-/_}"

OLD_NAME="mod_template"
OLD_NAME_DASH="template-mod"
OLD_ROOT_NAME="mod-template"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PARENT_DIR="$(dirname "$PROJECT_ROOT")"

echo "Renaming project from '$OLD_NAME' to '$NEW_NAME_UNDERSCORE'"
echo "Project root: $PROJECT_ROOT"

# Rename package directory
OLD_PKG_DIR="$PROJECT_ROOT/src/main/java/ua/borukva/$OLD_NAME"
NEW_PKG_DIR="$PROJECT_ROOT/src/main/java/ua/borukva/$NEW_NAME_UNDERSCORE"

if [ -d "$OLD_PKG_DIR" ]; then
    echo "Renaming package directory..."
    mv "$OLD_PKG_DIR" "$NEW_PKG_DIR"
else
    echo "Warning: Package directory not found at $OLD_PKG_DIR"
fi

# Update package declarations in Java files
echo "Updating package declarations in Java files..."
find "$PROJECT_ROOT/src/main/java" -name "*.java" -type f | while read -r file; do
    sed -i "s/ua\.borukva\.$OLD_NAME/ua.borukva.$NEW_NAME_UNDERSCORE/g" "$file"
done

# Update MOD_ID in ModInit.java
MOD_INIT="$PROJECT_ROOT/src/main/java/ua/borukva/$NEW_NAME_UNDERSCORE/ModInit.java"
if [ -f "$MOD_INIT" ]; then
    echo "Updating MOD_ID in ModInit.java..."
    sed -i "s/MOD_ID = \"$OLD_NAME_DASH\"/MOD_ID = \"$NEW_NAME\"/g" "$MOD_INIT"
fi

# Update gradle.properties
GRADLE_PROPS="$PROJECT_ROOT/gradle.properties"
if [ -f "$GRADLE_PROPS" ]; then
    echo "Updating gradle.properties..."
    sed -i "s/archives_base_name=$OLD_NAME_DASH/archives_base_name=$NEW_NAME/g" "$GRADLE_PROPS"
fi

# Update fabric.mod.json
FABRIC_JSON="$PROJECT_ROOT/src/main/resources/fabric.mod.json"
if [ -f "$FABRIC_JSON" ]; then
    echo "Updating fabric.mod.json..."
    sed -i "s/\"id\": \"$OLD_NAME_DASH\"/\"id\": \"$NEW_NAME\"/g" "$FABRIC_JSON"
    sed -i "s/ua\.borukva\.$OLD_NAME/ua.borukva.$NEW_NAME_UNDERSCORE/g" "$FABRIC_JSON"
    sed -i "s/$OLD_NAME_DASH\.mixins\.json/$NEW_NAME.mixins.json/g" "$FABRIC_JSON"
    sed -i "s|assets/$OLD_NAME_DASH/|assets/$NEW_NAME/|g" "$FABRIC_JSON"
fi

# Rename and update mixins json file
OLD_MIXIN_FILE="$PROJECT_ROOT/src/main/resources/$OLD_NAME_DASH.mixins.json"
NEW_MIXIN_FILE="$PROJECT_ROOT/src/main/resources/$NEW_NAME.mixins.json"

if [ -f "$OLD_MIXIN_FILE" ]; then
    echo "Updating and renaming mixins.json..."
    sed -i "s/ua\.borukva\.$OLD_NAME/ua.borukva.$NEW_NAME_UNDERSCORE/g" "$OLD_MIXIN_FILE"
    mv "$OLD_MIXIN_FILE" "$NEW_MIXIN_FILE"
fi

# Rename assets directory if it exists
OLD_ASSETS_DIR="$PROJECT_ROOT/src/main/resources/assets/$OLD_NAME_DASH"
NEW_ASSETS_DIR="$PROJECT_ROOT/src/main/resources/assets/$NEW_NAME"

if [ -d "$OLD_ASSETS_DIR" ]; then
    echo "Renaming assets directory..."
    mv "$OLD_ASSETS_DIR" "$NEW_ASSETS_DIR"
fi

# Remove git remote origin
echo "Removing git remote origin..."
git -C "$PROJECT_ROOT" remote remove origin 2>/dev/null || echo "No remote origin to remove"

# Clear README
README="$PROJECT_ROOT/README.md"
if [ -f "$README" ]; then
    echo "Clearing README.md..."
    > "$README"
fi

# Rename root directory
NEW_ROOT="$PARENT_DIR/$NEW_NAME"
if [ "$PROJECT_ROOT" != "$NEW_ROOT" ]; then
    echo "Renaming root directory to $NEW_NAME..."
    cd "$PARENT_DIR"
    mv "$PROJECT_ROOT" "$NEW_ROOT"
    echo "Root directory renamed. New location: $NEW_ROOT"
fi

echo "Done! Project renamed to '$NEW_NAME'"
