Firebase setup (quick)

This project includes optional Firebase integration for the Flutter app.
The code will attempt to use Cloud Firestore to persist tasks. If Firestore
is not configured the app will fall back to in-memory storage.

Steps to configure Firebase for Flutter:

1. Create a Firebase project at https://console.firebase.google.com/
2. Add an Android / iOS / Web app in the Firebase console.
3. For Android: download `google-services.json` and place it under `android/app/`.
   For iOS: download `GoogleService-Info.plist` and add it to Xcode runner.
   For Web: follow the Firebase console instructions or use `flutterfire` CLI.
4. Install the FlutterFire CLI (optional but recommended):

   flutter pub global activate flutterfire_cli

5. Configure platforms with the CLI (from project root):

   flutterfire configure

This will generate `lib/firebase_options.dart` and set up platform configuration.

After configuring, run:

   flutter pub get
   flutter run

Notes:
- Do NOT commit `google-services.json` or `GoogleService-Info.plist` to public repos.
- If you do not configure Firebase the app still works using in-memory storage.
