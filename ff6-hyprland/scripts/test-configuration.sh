#!/bin/bash
# FF6-themed Hyprland Configuration Test Script
# This script tests and validates the complete FF6-themed Hyprland configuration

# Set colors for output messages
OK="\033[0;32m[OK]\033[0m"
ERROR="\033[0;31m[ERROR]\033[0m"
INFO="\033[0;34m[INFO]\033[0m"
WARNING="\033[0;33m[WARNING]\033[0m"

# Print header
echo -e "${INFO} FF6-themed Hyprland Configuration Test Script"
echo -e "${INFO} ============================================="

# Define configuration directories
CONFIG_DIR="/home/ubuntu/hyprland-crimson-config"
HYPR_DIR="$CONFIG_DIR/hypr"
WAYBAR_DIR="$CONFIG_DIR/waybar"
ROFI_DIR="$CONFIG_DIR/rofi"
KITTY_DIR="$CONFIG_DIR/kitty"
SWAPPY_DIR="$CONFIG_DIR/swappy"
SWAYNC_DIR="$CONFIG_DIR/swaync"
AGS_DIR="$CONFIG_DIR/ags"
XDG_DIR="$CONFIG_DIR/xdg"
SPRITES_DIR="$CONFIG_DIR/sprites"

# Function to check if a directory exists and has files
check_dir_with_files() {
    if [ -d "$1" ]; then
        file_count=$(find "$1" -type f | wc -l)
        if [ "$file_count" -gt 0 ]; then
            echo -e "${OK} Directory $1 exists and contains $file_count files"
            return 0
        else
            echo -e "${WARNING} Directory $1 exists but is empty"
            return 1
        fi
    else
        echo -e "${ERROR} Directory $1 does not exist"
        return 2
    fi
}

# Function to check if a file exists and has content
check_file_with_content() {
    if [ -f "$1" ]; then
        file_size=$(stat -c%s "$1")
        if [ "$file_size" -gt 0 ]; then
            echo -e "${OK} File $1 exists and has content ($file_size bytes)"
            return 0
        else
            echo -e "${WARNING} File $1 exists but is empty"
            return 1
        fi
    else
        echo -e "${ERROR} File $1 does not exist"
        return 2
    fi
}

# Function to check if a script is executable
check_executable() {
    if [ -f "$1" ]; then
        if [ -x "$1" ]; then
            echo -e "${OK} Script $1 is executable"
            return 0
        else
            echo -e "${WARNING} Script $1 exists but is not executable"
            return 1
        fi
    else
        echo -e "${ERROR} Script $1 does not exist"
        return 2
    fi
}

# Function to validate JSON file
validate_json() {
    if [ -f "$1" ]; then
        if python3 -c "import json; json.load(open('$1'))" 2>/dev/null; then
            echo -e "${OK} JSON file $1 is valid"
            return 0
        else
            echo -e "${ERROR} JSON file $1 is invalid"
            return 1
        fi
    else
        echo -e "${ERROR} JSON file $1 does not exist"
        return 2
    fi
}

# Function to validate Python file
validate_python() {
    if [ -f "$1" ]; then
        if python3 -m py_compile "$1" 2>/dev/null; then
            echo -e "${OK} Python file $1 is valid"
            return 0
        else
            echo -e "${ERROR} Python file $1 is invalid"
            return 1
        fi
    else
        echo -e "${ERROR} Python file $1 does not exist"
        return 2
    fi
}

# Function to check for FF6 theme elements in a file
check_ff6_theme() {
    if [ -f "$1" ]; then
        if grep -q -E "FF6|ff6|Final Fantasy|final fantasy|#112855|#3B7DFF|AtmaWeapon" "$1"; then
            echo -e "${OK} File $1 contains FF6 theme elements"
            return 0
        else
            echo -e "${WARNING} File $1 does not appear to contain FF6 theme elements"
            return 1
        fi
    else
        echo -e "${ERROR} File $1 does not exist"
        return 2
    fi
}

# Test main directories
echo -e "${INFO} Testing main directories..."
DIRS_PASSED=0
DIRS_TOTAL=9

for dir in "$HYPR_DIR" "$WAYBAR_DIR" "$ROFI_DIR" "$KITTY_DIR" "$SWAPPY_DIR" "$SWAYNC_DIR" "$AGS_DIR" "$XDG_DIR" "$SPRITES_DIR"; do
    if check_dir_with_files "$dir"; then
        DIRS_PASSED=$((DIRS_PASSED+1))
    fi
done

echo -e "${INFO} $DIRS_PASSED/$DIRS_TOTAL directories passed the test"

# Test critical configuration files
echo -e "${INFO} Testing critical configuration files..."
FILES_PASSED=0
FILES_TOTAL=17

CRITICAL_FILES=(
    "$HYPR_DIR/hyprland.conf"
    "$HYPR_DIR/colors.conf"
    "$HYPR_DIR/animations.conf"
    "$HYPR_DIR/hyprlock.conf"
    "$HYPR_DIR/hypridle.conf"
    "$WAYBAR_DIR/config-top.jsonc"
    "$WAYBAR_DIR/config-bottom.jsonc"
    "$WAYBAR_DIR/style.css"
    "$KITTY_DIR/kitty.conf"
    "$KITTY_DIR/ff_sprite.py"
    "$ROFI_DIR/config.rasi"
    "$ROFI_DIR/ff6.rasi"
    "$SWAPPY_DIR/config"
    "$SWAYNC_DIR/config.json"
    "$SWAYNC_DIR/style.css"
    "$AGS_DIR/config.js"
    "$XDG_DIR/portals.conf"
)

for file in "${CRITICAL_FILES[@]}"; do
    if check_file_with_content "$file"; then
        FILES_PASSED=$((FILES_PASSED+1))
    fi
done

echo -e "${INFO} $FILES_PASSED/$FILES_TOTAL critical files passed the test"

# Test executable scripts
echo -e "${INFO} Testing executable scripts..."
SCRIPTS_PASSED=0
SCRIPTS_TOTAL=0

# Find all shell scripts
SHELL_SCRIPTS=$(find "$CONFIG_DIR" -name "*.sh")
SCRIPTS_TOTAL=$(echo "$SHELL_SCRIPTS" | wc -l)

for script in $SHELL_SCRIPTS; do
    if check_executable "$script"; then
        SCRIPTS_PASSED=$((SCRIPTS_PASSED+1))
    else
        chmod +x "$script"
        if check_executable "$script"; then
            SCRIPTS_PASSED=$((SCRIPTS_PASSED+1))
            echo -e "${INFO} Fixed permissions for $script"
        fi
    fi
done

echo -e "${INFO} $SCRIPTS_PASSED/$SCRIPTS_TOTAL scripts passed the test"

# Test JSON files
echo -e "${INFO} Testing JSON files..."
JSON_PASSED=0
JSON_TOTAL=0

# Find all JSON files
JSON_FILES=$(find "$CONFIG_DIR" -name "*.json*")
JSON_TOTAL=$(echo "$JSON_FILES" | wc -l)

for json in $JSON_FILES; do
    if validate_json "$json"; then
        JSON_PASSED=$((JSON_PASSED+1))
    fi
done

echo -e "${INFO} $JSON_PASSED/$JSON_TOTAL JSON files passed the test"

# Test Python files
echo -e "${INFO} Testing Python files..."
PYTHON_PASSED=0
PYTHON_TOTAL=0

# Find all Python files
PYTHON_FILES=$(find "$CONFIG_DIR" -name "*.py")
PYTHON_TOTAL=$(echo "$PYTHON_FILES" | wc -l)

for py in $PYTHON_FILES; do
    if validate_python "$py"; then
        PYTHON_PASSED=$((PYTHON_PASSED+1))
    fi
done

echo -e "${INFO} $PYTHON_PASSED/$PYTHON_TOTAL Python files passed the test"

# Test FF6 theming
echo -e "${INFO} Testing FF6 theming..."
THEME_PASSED=0
THEME_TOTAL=0

# Find key theme files
THEME_FILES=(
    "$HYPR_DIR/colors.conf"
    "$WAYBAR_DIR/style.css"
    "$ROFI_DIR/ff6.rasi"
    "$SWAYNC_DIR/style.css"
    "$KITTY_DIR/ff_sprite.py"
)
THEME_TOTAL=${#THEME_FILES[@]}

for theme in "${THEME_FILES[@]}"; do
    if check_ff6_theme "$theme"; then
        THEME_PASSED=$((THEME_PASSED+1))
    fi
done

echo -e "${INFO} $THEME_PASSED/$THEME_TOTAL theme files passed the test"

# Test installer script
echo -e "${INFO} Testing installer script..."
if check_executable "$CONFIG_DIR/install.sh"; then
    echo -e "${OK} Installer script is executable"
    
    # Check if installer has FF6 references
    if check_ff6_theme "$CONFIG_DIR/install.sh"; then
        echo -e "${OK} Installer script contains FF6 theme elements"
    else
        echo -e "${WARNING} Installer script may not contain FF6 theme elements"
    fi
    
    # Check if installer has proper dependency checks
    if grep -q -E "dependencies|packages|apt|pacman|dnf|zypper" "$CONFIG_DIR/install.sh"; then
        echo -e "${OK} Installer script contains package management"
    else
        echo -e "${WARNING} Installer script may not handle dependencies properly"
    fi
else
    echo -e "${ERROR} Installer script is not executable or does not exist"
    if [ -f "$CONFIG_DIR/install.sh" ]; then
        chmod +x "$CONFIG_DIR/install.sh"
        echo -e "${INFO} Fixed permissions for installer script"
    fi
fi

# Test integration script
echo -e "${INFO} Testing integration script..."
if check_executable "$CONFIG_DIR/scripts/integrate-components.sh"; then
    echo -e "${OK} Integration script is executable"
else
    echo -e "${ERROR} Integration script is not executable or does not exist"
    if [ -f "$CONFIG_DIR/scripts/integrate-components.sh" ]; then
        chmod +x "$CONFIG_DIR/scripts/integrate-components.sh"
        echo -e "${INFO} Fixed permissions for integration script"
    fi
fi

# Calculate overall score
TOTAL_PASSED=$((DIRS_PASSED + FILES_PASSED + SCRIPTS_PASSED + JSON_PASSED + PYTHON_PASSED + THEME_PASSED))
TOTAL_TESTS=$((DIRS_TOTAL + FILES_TOTAL + SCRIPTS_TOTAL + JSON_TOTAL + PYTHON_TOTAL + THEME_TOTAL))
SCORE=$((TOTAL_PASSED * 100 / TOTAL_TESTS))

echo -e "${INFO} ============================================="
echo -e "${INFO} Test Results:"
echo -e "${INFO} Directories: $DIRS_PASSED/$DIRS_TOTAL"
echo -e "${INFO} Critical Files: $FILES_PASSED/$FILES_TOTAL"
echo -e "${INFO} Executable Scripts: $SCRIPTS_PASSED/$SCRIPTS_TOTAL"
echo -e "${INFO} JSON Files: $JSON_PASSED/$JSON_TOTAL"
echo -e "${INFO} Python Files: $PYTHON_PASSED/$PYTHON_TOTAL"
echo -e "${INFO} FF6 Theme Elements: $THEME_PASSED/$THEME_TOTAL"
echo -e "${INFO} ============================================="
echo -e "${INFO} Overall Score: $SCORE%"

if [ $SCORE -ge 90 ]; then
    echo -e "${OK} Configuration passed validation with an excellent score!"
    echo -e "${OK} The FF6-themed Hyprland configuration is ready for packaging."
elif [ $SCORE -ge 75 ]; then
    echo -e "${OK} Configuration passed validation with a good score."
    echo -e "${INFO} Consider addressing the warnings before packaging."
else
    echo -e "${WARNING} Configuration has some issues that should be addressed."
    echo -e "${INFO} Please fix the errors and warnings before packaging."
fi

echo -e "${INFO} ============================================="

exit 0
