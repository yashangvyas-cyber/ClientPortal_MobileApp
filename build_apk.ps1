# Helper script to build the CollabCRM APK
# This requires the Android SDK to be installed.

$FLUTTER_PATH = "C:\Users\Best\.gemini\antigravity\scratch\flutter\bin"
$env:Path += ";$FLUTTER_PATH"

Write-Host "--- Starting CollabCRM APK Build ---" -ForegroundColor Cyan

# 1. Clean previous builds
Write-Host "Cleaning work directory..."
flutter clean

# 2. Get dependencies
Write-Host "Fetching project requirements..."
flutter pub get

# 3. Build the APK
Write-Host "Building Installable APK (this may take a few minutes)..."
flutter build apk --release

if ($LASTEXITCODE -eq 0) {
    $APK_PATH = "build\app\outputs\flutter-apk\app-release.apk"
    Write-Host "`nSUCCESS! Your APK is ready." -ForegroundColor Green
    Write-Host "You can find it here: $APK_PATH"
} else {
    Write-Host "`nERROR: Build failed. Please ensure Android SDK is installed and flutter doctor is happy." -ForegroundColor Red
}
