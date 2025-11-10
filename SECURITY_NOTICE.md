# Security Notice - Firebase Credentials

## ⚠️ IMPORTANT: Credentials Have Been Exposed

The Firebase API keys and configuration were accidentally pushed to the public GitHub repository in the initial commit. 

### Immediate Actions Required:

1. **Rotate Firebase API Keys** (Recommended)
   - Go to Firebase Console: https://console.firebase.google.com/
   - Select your project: `dailypulse-82f54`
   - Go to **Project Settings** → **General**
   - Under **Your apps**, find your Web app
   - Click **Delete app** or regenerate keys
   - Create a new Web app with fresh credentials

2. **Restrict API Keys** (Critical)
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Navigate to **APIs & Services** → **Credentials**
   - Find your API key: `AIzaSyCz9tCAbjHuWAlQeqanWvzLYeGF412QwoU`
   - Click **Edit** and add restrictions:
     - **Application restrictions**: HTTP referrers
     - Add your domains (e.g., `localhost:*`, `yourdomain.com`)
     - **API restrictions**: Restrict to Firebase services only

3. **Enable Firebase Security Rules**
   - Go to Firebase Console → Firestore Database → Rules
   - Ensure rules only allow authenticated users:
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

4. **Monitor for Unauthorized Access**
   - Check Firebase Console → Authentication → Users
   - Check Firestore → Data for unexpected entries
   - Review Usage & Billing for unusual activity

### Future Prevention:

✅ **`.env` file created** - Contains actual credentials (not committed to Git)  
✅ **`.env.example` created** - Template for setup instructions  
✅ **`.gitignore` updated** - Ensures `.env` is never committed  
⚠️ **Replace secrets** - Update `firebase_options.dart` and `web/index.html` with placeholders

### Why This Matters:

Even though Firebase API keys are meant to be "public" (used in client apps), they should still be protected because:
- Exposed keys can be abused if not properly restricted
- Attackers can create fake accounts and spam your database
- Your Firebase quota can be exhausted
- Billing charges can accumulate

### Current Status:

- [x] `.env` file created with actual credentials
- [x] `.env.example` created for setup template
- [x] `.gitignore` updated to exclude `.env`
- [ ] **TODO**: Remove secrets from `lib/firebase_options.dart`
- [ ] **TODO**: Remove secrets from `web/index.html`
- [ ] **TODO**: Commit changes to remove secrets from repository
- [ ] **TODO**: Rotate Firebase keys (recommended)

### How to Use `.env` in Flutter:

Install flutter_dotenv package:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

Load environment variables:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  
  final apiKey = dotenv.env['FIREBASE_API_KEY']!;
  // Use apiKey in FirebaseOptions
}
```

---

**Action Required**: Follow the steps above to secure your Firebase project immediately!
