# DailyPulse – Personal Wellness Tracker App

**DailyPulse** is a Flutter-based mobile application that empowers users to log their daily moods, track emotional patterns over time, and gain insights into their overall mental wellness. In an age of remote work and digital overload, DailyPulse provides a clean, intuitive interface to help users stay connected with their emotions.

---

## Overview

Mental health and daily emotional awareness are critical aspects of overall well-being. DailyPulse helps users:

- **Log daily moods** with emoji selection and optional notes
- **View mood history** with a chronological list of past entries
- **Analyze emotional patterns** with basic insights (positive vs negative days, most common mood, visual charts)
- **Persist data locally** using Hive for offline access
- **Sync to the cloud** via Firebase Authentication and Cloud Firestore

---

## Features

### Core Functionality

1. **Mood Logging Interface**
   - Select a mood from 6 emoji options (Happy, Cool, Sad, Angry, Anxious, Tired)
   - Add an optional note describing the day
   - Auto-select the current date (or pick a past date)
   - Save entries locally and sync to Firestore

2. **Mood History**
   - View a scrollable list of past mood entries
   - Display date, time, emoji, and note for each entry
   - Delete entries with confirmation dialog
   - Pull-to-refresh functionality

3. **Basic Analytics**
   - Total entries count
   - Positive vs negative days breakdown
   - Most common mood indicator
   - Pie chart showing mood distribution
   - Percentage breakdown by mood type

4. **Data Persistence**
   - Local storage using Hive (offline-first approach)
   - Cloud sync using Firebase Cloud Firestore
   - Automatic sync on each mood entry submission

5. **Clean UI/UX**
   - Material Design 3 with custom color scheme
   - Google Fonts (Poppins) for typography
   - Responsive layouts for various screen sizes
   - Bottom navigation for easy screen switching

### Bonus Features

- **Dark Mode Toggle**: Switch between light and dark themes
- **Firebase Authentication**: Secure email/password login and signup
- **Mood Trends/Graph**: Visual pie chart using `fl_chart` package
- **Custom Animations**: Smooth mood selection with animated containers

---

## Technical Stack

- **Flutter SDK**: 3.x (tested with 3.9.2+)
- **State Management**: `setState` (built-in)
- **Local Storage**: `hive` + `hive_flutter` with code generation
- **Firebase Services**:
  - `firebase_core` for initialization
  - `firebase_auth` for authentication
  - `cloud_firestore` for data sync
- **UI Libraries**:
  - `google_fonts` for typography
  - `fl_chart` for data visualization
  - `intl` for date/time formatting

---

## Project Structure

```
lib/
├── main.dart                  # App entry point with theme and auth wrapper
├── models/
│   ├── mood_entry.dart        # Hive model for mood entries
│   ├── mood_entry.g.dart      # Generated Hive adapter
│   └── mood_type.dart         # Mood emoji/label definitions
├── screens/
│   ├── analytics_screen.dart  # Mood insights and charts
│   ├── home_screen.dart       # Bottom navigation host
│   ├── login_screen.dart      # User authentication
│   ├── mood_history_screen.dart # List of past entries
│   ├── mood_log_screen.dart   # Mood entry form
│   └── signup_screen.dart     # New user registration
└── services/
    ├── auth_service.dart      # Firebase Auth wrapper
    ├── firestore_service.dart # Firestore CRUD operations
    └── local_storage_service.dart # Hive local storage manager
```

---

## Setup Instructions

### Prerequisites

- Flutter SDK 3.x ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Dart 3.x
- A Firebase project ([Create Firebase project](https://console.firebase.google.com/))

### Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/ashish6318/dailyPulse.git
   cd dailyPulse
   ```

2. **Install dependencies**:
   ```powershell
   flutter pub get
   ```

3. **Configure Environment Variables**:
   - Copy `.env.example` to `.env`:
     ```powershell
     Copy-Item .env.example .env
     ```
   - Open `.env` and replace placeholders with your actual Firebase credentials
   - **IMPORTANT**: Never commit `.env` to Git!

4. **Configure Firebase**:
   - Create a Firebase project at [https://console.firebase.google.com/](https://console.firebase.google.com/)
   - Enable **Authentication** (Email/Password provider)
   - Enable **Cloud Firestore**
   - Add your Firebase credentials to:
     - **`.env` file** (for local development)
     - **`lib/firebase_options.dart`** (replace YOUR_*_KEY placeholders)
     - **`web/index.html`** (replace YOUR_* placeholders)
   - Additional platform files:
     - **Android**: Download `google-services.json` and place in `android/app/`
     - **iOS**: Download `GoogleService-Info.plist` and place in `ios/Runner/`

5. **Generate Hive adapters** (if not already present):
   ```powershell
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app**:
   ```powershell
   flutter run
   ```

   Or for a specific device:
   ```powershell
   flutter run -d chrome      # For web
   flutter run -d android     # For Android emulator
   flutter run -d ios         # For iOS simulator (macOS only)
   ```

---

## Usage

1. **Sign Up / Login**:
   - On first launch, create an account with email and password
   - Or log in if you already have an account

2. **Log a Mood**:
   - Tap the **Log Mood** tab
   - Select your current mood emoji
   - (Optional) Add a note describing your day
   - Tap **Save Mood Entry**

3. **View History**:
   - Tap the **History** tab
   - Scroll through your past mood entries
   - Swipe to delete or tap the delete icon

4. **Analyze Trends**:
   - Tap the **Analytics** tab
   - View your total entries, positive vs negative days
   - See a pie chart of your mood distribution

5. **Toggle Dark Mode**:
   - Tap the theme toggle icon in the app bar (sun/moon icon)

---

## Design Choices

### Emotion Logic

- **6 Moods**: Selected to cover a broad emotional spectrum without overwhelming users
  - Positive: Happy (😊), Cool (😎)
  - Negative: Sad (😔), Angry (😡), Anxious (😰), Tired (😴)

- **Binary Classification**: Each mood is tagged as `isPositive` for simple analytics

### UI/UX Decisions

- **Material 3**: Modern, accessible design language
- **Bottom Navigation**: Quick switching between core screens
- **Color-Coded Entries**: Green for positive, orange for negative moods
- **Pull-to-Refresh**: Intuitive gesture for data updates
- **Card-based Layout**: Clean separation of content with rounded corners

### Data Strategy

- **Local-First**: Hive provides fast, offline access
- **Cloud Sync**: Firestore ensures data persistence across devices
- **User Isolation**: Each user's moods are stored under their Firebase UID

---

## Known Issues & Future Improvements

### Current Limitations

- Analyzer warnings (`use_build_context_synchronously`, deprecated `withOpacity`) are informational and do not break functionality
- Basic widget test covers app initialization only

### Future Enhancements

- **Calendar Integration**: Visual calendar view with mood markers
- **Advanced Charts**: Line graphs for mood trends over time
- **Notifications**: Daily reminders to log moods
- **Journaling**: Rich text editor for detailed notes
- **Export Data**: CSV or PDF export for personal records
- **Social Features**: Share insights (anonymously) with a community

---

## Testing

Run tests with:
```powershell
flutter test
```

Current test coverage includes a basic smoke test for app initialization.

---

## License

This project is created for educational purposes as part of a coding challenge.

---

## Contributors

- **Your Name** – Developer

---

## Screenshots

_(Add screenshots here after running the app)_

---

## Firebase Rules (Example)

For Firestore security, use the following rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/moods/{moodId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## Contact

For questions or feedback, reach out at [your-email@example.com](mailto:your-email@example.com).

---

**Happy tracking your DailyPulse!** 💙
