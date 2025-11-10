# Setup Android SDK WITHOUT Android Studio

This guide shows you how to install just the Android SDK command-line tools (without the full Android Studio IDE).

---

## Option 1: Install Android SDK Command-Line Tools Only

### Step 1: Download Command-Line Tools

1. Go to: https://developer.android.com/studio#command-line-tools-only
2. Scroll down to **"Command line tools only"**
3. Download: **commandlinetools-win-XXXXXX_latest.zip** (for Windows)

### Step 2: Extract and Setup

1. **Create SDK folder**:
   ```powershell
   mkdir C:\Android\Sdk
   mkdir C:\Android\Sdk\cmdline-tools
   ```

2. **Extract the downloaded ZIP**:
   - Extract the contents to a temporary folder
   - You'll see a folder called `cmdline-tools`
   - Rename it to `latest`
   - Move it to: `C:\Android\Sdk\cmdline-tools\latest`

3. **Final structure should look like**:
   ```
   C:\Android\Sdk\
   └── cmdline-tools\
       └── latest\
           ├── bin\
           ├── lib\
           └── ...
   ```

### Step 3: Set Environment Variables

1. Press `Win + R`, type `sysdm.cpl`, press Enter
2. Advanced tab → Environment Variables
3. Create new **User variable**:
   - Name: `ANDROID_HOME`
   - Value: `C:\Android\Sdk`
4. Edit **Path** variable, add these lines:
   ```
   C:\Android\Sdk\cmdline-tools\latest\bin
   C:\Android\Sdk\platform-tools
   C:\Android\Sdk\emulator
   ```
5. Click OK to save

### Step 4: Install Required SDK Components

Close all terminals, open a NEW PowerShell, and run:

```powershell
# Install SDK platform and build tools
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# Install emulator (optional, if you want to use emulator)
sdkmanager "emulator" "system-images;android-33;google_apis;x86_64"

# Accept licenses
sdkmanager --licenses
```

Type `y` for each license prompt.

### Step 5: Verify Setup

```powershell
flutter doctor -v
```

You should see Android toolchain installed!

---

## Option 2: Use a Physical Android Device (EASIEST!)

If you have an Android phone, you don't need an emulator at all:

### Step 1: Enable Developer Mode on Your Phone

1. Go to **Settings** → **About phone**
2. Tap **Build number** 7 times rapidly
3. You'll see "You are now a developer!"

### Step 2: Enable USB Debugging

1. Go to **Settings** → **System** → **Developer options**
2. Toggle **USB debugging** to ON
3. (Optional) Toggle **Install via USB** to ON

### Step 3: Install USB Drivers (if needed)

Windows usually installs drivers automatically, but if not:

- **Samsung**: Install Samsung USB Driver
- **Google Pixel**: Should work automatically
- **Other brands**: Search "[Brand] USB driver" and install

### Step 4: Connect Phone and Test

1. Connect your phone to PC with USB cable
2. On your phone, tap **"Allow"** when prompted for USB debugging
3. Check if detected:
   ```powershell
   adb devices
   ```
   You should see your device listed.

4. Run your app:
   ```powershell
   cd C:\Users\rajpu\OneDrive\Desktop\assignment
   flutter run
   ```

---

## Option 3: Run on Web Browser (NO Android SDK needed!)

The simplest option - no Android SDK required:

```powershell
# Just run on Chrome
flutter run -d chrome
```

**Note**: Firebase works on web too! Just make sure you've configured Firebase for web platform.

---

## Which Option Should You Choose?

### ✅ **Recommended: Physical Device (Option 2)**
- Fastest performance
- No emulator overhead
- Easiest to set up
- Real-world testing

### ✅ **Good: Web Browser (Option 3)**
- No setup required
- Works immediately
- Good for development

### ⚠️ **Advanced: Command-line tools (Option 1)**
- Smaller download than Android Studio
- Still need to setup emulator
- More complex setup

---

## Quick Start with Physical Device

If you have an Android phone right now:

1. **Enable USB debugging** (see Option 2 above)
2. **Connect phone to PC**
3. **Run these commands**:
   ```powershell
   # Check if phone is detected
   adb devices
   
   # If not detected, restart adb
   adb kill-server
   adb start-server
   adb devices
   
   # Run the app
   cd C:\Users\rajpu\OneDrive\Desktop\assignment
   flutter run
   ```

That's it! No Android Studio needed.

---

## Troubleshooting

### "adb: command not found"

You need platform-tools. Download from:
https://developer.android.com/studio/releases/platform-tools

Extract to `C:\Android\Sdk\platform-tools` and add to PATH.

### Phone not detected

1. Make sure USB debugging is enabled
2. Try a different USB cable (some cables are charge-only)
3. Install USB drivers for your phone brand
4. Run: `adb kill-server` then `adb start-server`

### "Waiting for another flutter command to release the startup lock"

```powershell
taskkill /F /IM dart.exe
```

### Firebase doesn't work on web

Make sure you've added Firebase config to `web/index.html` (see FIREBASE_SETUP.md)

---

## Still Want Android Studio for Emulator?

If you really need an emulator and don't have Android Studio:

**Install Bluestacks or NoxPlayer** (third-party Android emulators):
- Bluestacks: https://www.bluestacks.com/
- NoxPlayer: https://www.bignox.com/

Then run:
```powershell
adb connect 127.0.0.1:5555
flutter devices
flutter run
```

---

## Summary

**For fastest setup RIGHT NOW:**

1. Connect your Android phone
2. Enable USB debugging
3. Run: `flutter run`

**For web testing:**

1. Run: `flutter run -d chrome`

No Android Studio installation needed! 🎉
