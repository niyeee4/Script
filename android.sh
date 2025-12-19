echo "Installing Skiko Native Library (Fixing Compose/AWT Error)"

# --- Patch Start ---

# Skiko Version corresponding to the platform version (0.9.33 is a known working version)
SKIKO_VERSION="0.9.33"
SKIKO_BASE_URL="https://maven.pkg.jetbrains.space/public/p/compose/dev/org/jetbrains/skiko/skiko-awt-runtime-linux-arm64"
SKIKO_URL="${SKIKO_BASE_URL}/${SKIKO_VERSION}/skiko-awt-runtime-linux-arm64-${SKIKO_VERSION}.jar"

# Define the target directory expected by the IDE
SKIKO_TARGET_DIR="${AS_ROOT_DIR}/lib/skiko-awt-runtime-all"
mkdir -p "$SKIKO_TARGET_DIR"

# Download the Skiko JAR using the existing curl_resume function
SKIKO_JAR_FILE="${CACHE_DIR}/skiko-linux-arm64.jar"
curl_resume "$SKIKO_URL" "$SKIKO_JAR_FILE"

# The native library is at the root of the JAR, named 'libskiko-linux-arm64.so'.
# Use 'unzip -j' to extract the file directly into the target directory, ignoring internal paths.
MISSING_FILE="libskiko-linux-arm64.so"
unzip -o -j "$SKIKO_JAR_FILE" "$MISSING_FILE" -d "$SKIKO_TARGET_DIR"

echo "Successfully installed ${MISSING_FILE}"

# --- Patch End ---
