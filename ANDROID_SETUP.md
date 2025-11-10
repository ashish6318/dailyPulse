# Android SDK Setup Guide for Windows

Complete guide to install and configure Android SDK for Flutter development on Windows.

---

## Step 1: Install Android Studio

1. **Download Android Studio**:
   - Go to [https://developer.android.com/studio](https://developer.android.com/studio)
   - Click **"Download Android Studio"**
   - Accept the terms and download the `.exe` file

2. **Install Android Studio**:
   - Run the downloaded `android-studio-xxx-windows.exe`
   - Click **"Next"** through the wizard
   - Make sure to select:
     - ✅ Android Studio
     - ✅ Android Virtual Device
   - Choose installation location (default is fine): `C:\Program Files\Android\Android Studio`
   - Click **"Install"**
   - Wait for installation to complete (may take 5-10 minutes)

3. **Complete Setup Wizard**:
   - Launch Android Studio
   - Choose **"Standard"** installation type
   - Select your preferred theme (Light/Dark)
   - Click **"Next"** and then **"Finish"**
   - Android Studio will download Android SDK components (this may take 10-20 minutes)

---

## Step 2: Install Android SDK Components

1. **Open SDK Manager**:
   - In Android Studio, go to **File** → **Settings** (or click the gear icon)
   - Navigate to **Appearance & Behavior** → **System Settings** → **Android SDK**

2. **Install Required SDK Platforms**:
   - Go to the **"SDK Platforms"** tab
   - Check the box for:
     - ✅ **Android 14.0 (API Level 34)** (latest)
     - ✅ **Android 13.0 (API Level 33)**
   - Click **"Apply"** and then **"OK"** to download

3. **Install SDK Build Tools**:
   - Go to the **"SDK Tools"** tab
   - Make sure these are checked:
     - ✅ **Android SDK Build-Tools** (latest version)
     - ✅ **Android SDK Command-line Tools**
     - ✅ **Android Emulator**
     - ✅ **Android SDK Platform-Tools**
     - ✅ **Intel x86 Emulator Accelerator (HAXM)** (for faster emulation)
   - Click **"Apply"** and then **"OK"**

4. **Note Your SDK Location**:
   - In the SDK Manager window, at the top you'll see **"Android SDK Location"**
   - Default location is usually: `C:\Users\YourUsername\AppData\Local\Android\Sdk`
   - Copy this path - you'll need it in the next step

---

## Step 3: Set Environment Variables

1. **Open Environment Variables Settings**:
   - Press `Win + R`, type `sysdm.cpl`, press Enter
   - Go to the **"Advanced"** tab
   - Click **"Environment Variables"**

2. **Create ANDROID_HOME Variable**:
   - In the **"User variables"** section, click **"New"**
   - Variable name: `ANDROID_HOME`
   - Variable value: `C:\Users\YourUsername\AppData\Local\Android\Sdk` (use your actual path)
   - Click **"OK"**

3. **Add to PATH**:
   - In **"User variables"**, find and select **"Path"**
   - Click **"Edit"**
   - Click **"New"** and add these three entries:
     ```
     %ANDROID_HOME%\platform-tools
     %ANDROID_HOME%\cmdline-tools\latest\bin
     %ANDROID_HOME%\emulator
     ```
   - Click **"OK"** on all windows

4. **Verify Installation**:
   - Close ALL PowerShell windows
   - Open a NEW PowerShell window
   - Run these commands to verify:
   ```powershell
   echo $env:ANDROID_HOME
   adb --version
   ```
   - You should see the SDK path and ADB version

---

## Step 4: Accept Android Licenses

Run this command in PowerShell (may take a few minutes):

```powershell
flutter doctor --android-licenses
```

- Type `y` and press Enter for each license prompt
- This accepts all Android SDK licenses required by Flutter

---

## Step 5: Create an Android Virtual Device (Emulator)

1. **Open Device Manager**:
   - In Android Studio, click **Tools** → **Device Manager**
   - Or click the phone icon in the toolbar

2. **Create New Virtual Device**:
   - Click **"Create Device"**
   - Select a device definition (recommended: **Pixel 5**)
   - Click **"Next"**

3. **Select System Image**:
   - Choose a system image (recommended: **API 34** - latest)
   - If not downloaded, click **"Download"** next to the system image
   - Wait for download to complete
   - Click **"Next"**

4. **Configure AVD**:
   - Give it a name (e.g., "Pixel 5 API 34")
   - Leave other settings as default
   - Click **"Finish"**

5. **Launch Emulator**:
   - In Device Manager, click the ▶️ play button next to your device
   - Wait for the emulator to boot (first boot may take 2-3 minutes)

---

## Step 6: Verify Flutter Setup

Run this command to check everything is configured:

```powershell
flutter doctor -v
```

You should see:
- ✅ Flutter SDK
- ✅ Android toolchain - develop for Android devices
- ✅ Android Studio (if you want to use it as IDE)
- ✅ Connected device (if emulator is running)

If you see any ❌ marks, follow the instructions in the output.

---

## Step 7: Run Your DailyPulse App on Android

1. **Make sure emulator is running** (or connect a physical device)

2. **Check connected devices**:
   ```powershell
   flutter devices
   ```
   You should see your emulator or device listed.

3. **Run the app**:
   ```powershell
   cd C:\Users\rajpu\OneDrive\Desktop\assignment
   flutter run
   ```

4. **Select the Android device** when prompted (if multiple devices available)

5. **Wait for build** (first build may take 5-10 minutes)

---

## Using a Physical Android Device (Alternative to Emulator)

If you prefer to test on your real phone instead of emulator:

1. **Enable Developer Options on your phone**:
   - Go to **Settings** → **About phone**
   - Tap **Build number** 7 times quickly
   - You'll see "You are now a developer!"

2. **Enable USB Debugging**:
   - Go to **Settings** → **System** → **Developer options**
   - Toggle **"USB debugging"** to ON

3. **Connect your phone to PC**:
   - Use a USB cable
   - On your phone, tap **"Allow"** when prompted for USB debugging

4. **Verify connection**:
   ```powershell
   adb devices
   ```
   You should see your device listed.

5. **Run the app**:
   ```powershell
   flutter run
   ```

---

## Troubleshooting

### "ANDROID_HOME is not set"

**Solution**:
- Make sure you've set the environment variable correctly
- Close ALL PowerShell/terminal windows and open a new one
- Verify with: `echo $env:ANDROID_HOME`

### "cmdline-tools component is missing"

**Solution**:
```powershell
# Download and install cmdline-tools manually
# Or in Android Studio SDK Manager, install "Android SDK Command-line Tools"
```

### "Unable to locate adb"

**Solution**:
- Make sure `%ANDROID_HOME%\platform-tools` is in your PATH
- Restart your terminal
- Run: `flutter doctor -v` to check

### Emulator is very slow

**Solutions**:
- Install Intel HAXM (Hardware Accelerated Execution Manager)
- Enable Hyper-V in Windows (if using AMD processor)
- Increase emulator RAM in AVD settings
- Use a physical device instead

### "Gradle build failed"

**Solution**:
```powershell
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Firebase initialization error

**Solution**:
- Make sure `google-services.json` is in `android/app/` directory
- Verify the file is not empty and has valid JSON
- Check that the package name matches in Firebase console and `build.gradle.kts`

---

## Quick Command Reference

```powershell
# Check Flutter setup
flutter doctor -v

# List connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Install APK on device
flutter install

# Check ADB devices
adb devices

# Restart ADB server
adb kill-server
adb start-server
```

---

## Next Steps

Once Android SDK is set up and the app runs:

1. ✅ Configure Firebase (see `FIREBASE_SETUP.md`)
2. ✅ Test all features of DailyPulse
3. ✅ Take screenshots for your submission
4. ✅ Build release APK for distribution

---

## System Requirements

**Minimum**:
- Windows 10 (64-bit)
- 8 GB RAM
- 8 GB disk space for Android SDK

**Recommended**:
- Windows 11 (64-bit)
- 16 GB RAM
- SSD with 20 GB free space
- Hardware virtualization enabled in BIOS

---

**Need more help?** Check the [Flutter Android setup docs](https://docs.flutter.dev/get-started/install/windows#android-setup)
