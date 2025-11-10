# Firebase Setup Guide for DailyPulse

This guide will walk you through setting up Firebase for the DailyPulse app.

---

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** or **"Create a project"**
3. Enter project name: `DailyPulse` (or any name you prefer)
4. (Optional) Enable Google Analytics
5. Click **"Create project"** and wait for it to complete

---

## Step 2: Enable Authentication

1. In your Firebase project, click **"Authentication"** in the left sidebar
2. Click **"Get started"**
3. Go to the **"Sign-in method"** tab
4. Click on **"Email/Password"**
5. Toggle **"Enable"** to ON
6. Click **"Save"**

---

## Step 3: Enable Cloud Firestore

1. In your Firebase project, click **"Firestore Database"** in the left sidebar
2. Click **"Create database"**
3. Choose **"Start in test mode"** (for development)
4. Select a location (choose one closest to you)
5. Click **"Enable"**

### Set Firestore Security Rules

After Firestore is created, go to the **"Rules"** tab and replace with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read/write only their own mood entries
    match /users/{userId}/moods/{moodId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

Click **"Publish"** to save the rules.

---

## Step 4: Add Firebase to Your Flutter App

### For Android

1. In Firebase Console, click the **Android icon** (or "Add app" if no apps exist yet)
2. Enter your Android package name: `com.example.flutter_application_1`
   - (You can find this in `android/app/build.gradle.kts` under `namespace` or `applicationId`)
3. (Optional) Enter app nickname: `DailyPulse Android`
4. Click **"Register app"**
5. **Download** the `google-services.json` file
6. Place the file in: `android/app/google-services.json`
7. Click **"Next"** and **"Continue to console"**

### For iOS (if testing on iOS)

1. In Firebase Console, click the **iOS icon** (or "Add app")
2. Enter your iOS bundle ID: `com.example.flutterApplication1`
   - (You can find this in `ios/Runner.xcodeproj/project.pbxproj`)
3. (Optional) Enter app nickname: `DailyPulse iOS`
4. Click **"Register app"**
5. **Download** the `GoogleService-Info.plist` file
6. Open Xcode: `open ios/Runner.xcworkspace`
7. Drag the `GoogleService-Info.plist` file into the `Runner` folder in Xcode
8. Make sure **"Copy items if needed"** is checked
9. Click **"Finish"**

### For Web (if testing on web)

1. In Firebase Console, click the **Web icon** `</>`
2. Enter app nickname: `DailyPulse Web`
3. Click **"Register app"**
4. Copy the Firebase configuration object
5. Open `web/index.html` and add before the closing `</body>` tag:

```html
<script type="module">
  import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
  
  const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT_ID.appspot.com",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID"
  };
  
  initializeApp(firebaseConfig);
</script>
```

---

## Step 5: Run the App

### Option 1: Run on Web (Easiest)

```powershell
flutter run -d chrome
```

### Option 2: Run on Android Emulator

1. **Install Android Studio** from [developer.android.com](https://developer.android.com/studio)
2. Open Android Studio → **Tools** → **SDK Manager**
3. Install:
   - Android SDK Platform (API 33 or higher)
   - Android SDK Build-Tools
   - Android Emulator
4. Create a virtual device: **Tools** → **Device Manager** → **Create Device**
5. Set `ANDROID_HOME` environment variable:
   ```powershell
   [System.Environment]::SetEnvironmentVariable("ANDROID_HOME", "C:\Users\YourUsername\AppData\Local\Android\Sdk", [System.EnvironmentVariableTarget]::User)
   ```
6. Restart your terminal and run:
   ```powershell
   flutter run
   ```

### Option 3: Run on Physical Device

1. Enable **Developer Options** on your Android phone:
   - Go to **Settings** → **About phone**
   - Tap **Build number** 7 times
2. Enable **USB Debugging** in **Developer Options**
3. Connect your phone via USB
4. Run:
   ```powershell
   flutter devices
   flutter run
   ```

---

## Step 6: Test the App

1. **Sign up** with a test email (e.g., `test@example.com` / password: `test123`)
2. **Log a mood** by selecting an emoji and adding a note
3. **View history** to see your saved entries
4. **Check analytics** to see your mood distribution
5. **Toggle dark mode** using the icon in the app bar

---

## Troubleshooting

### Firebase not initialized error

- Make sure `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is in the correct location
- Run `flutter clean` and `flutter pub get`

### Authentication error

- Verify Email/Password sign-in method is enabled in Firebase Console
- Check Firebase project configuration

### Firestore permission denied

- Verify Firestore rules allow authenticated users to access their data
- Make sure you're logged in before trying to save moods

### Android SDK not found

- Install Android Studio and Android SDK
- Set `ANDROID_HOME` environment variable
- Or use web/iOS instead for testing

---

## Firebase Console URLs (Quick Access)

- **Console**: [https://console.firebase.google.com/](https://console.firebase.google.com/)
- **Authentication**: `https://console.firebase.google.com/project/YOUR_PROJECT_ID/authentication`
- **Firestore**: `https://console.firebase.google.com/project/YOUR_PROJECT_ID/firestore`

---

## Next Steps

Once Firebase is configured:

1. Test all features (signup, login, mood logging, history, analytics)
2. Add screenshots to the main README.md
3. (Optional) Deploy to production:
   - Change Firestore rules to production mode
   - Build release APK: `flutter build apk --release`
4. Push to GitHub and submit your assignment!

---

**Need help?** Check the [Firebase Flutter documentation](https://firebase.google.com/docs/flutter/setup) or [FlutterFire documentation](https://firebase.flutter.dev/).
