# StudyMan - Project Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Technologies Used](#technologies-used)
3. [Application Purpose](#application-purpose)
4. [Application Screens](#application-screens)
5. [Data Architecture](#data-architecture)
6. [Project Structure](#project-structure)
7. [Setup Instructions](#setup-instructions)

---

## 1. Project Overview

**Project Name:** StudyMan  
**Version:** 1.0.0+1  
**Platform:** Flutter (Cross-platform)  
**Primary Language:** Dart  
**SDK Version:** >=3.1.4 <4.0.0

StudyMan is a productivity application designed to help students manage their study sessions, tasks, and notes effectively using the Pomodoro Technique.

---

## 2. Technologies Used

### Core Framework
- **Flutter SDK**: Cross-platform mobile app development framework
- **Dart**: Programming language (version >=3.1.4)

### Firebase Services
- **firebase_core** (^2.24.2): Firebase core functionality
- **firebase_auth** (^4.16.0): User authentication and account management
- **cloud_firestore** (^4.14.0): NoSQL cloud database for real-time data synchronization

### Additional Packages
- **cupertino_icons** (^1.0.2): iOS-style icons
- **flutter_lints** (^2.0.0): Recommended linting rules for Flutter projects

### UI/UX
- **Material Design 3**: Modern Material Design components
- **Custom Timer Widget**: Pomodoro technique implementation

---

## 3. Application Purpose

StudyMan is a comprehensive study management application that helps students:

1. **Time Management**: Implements the Pomodoro Technique with:
   - 25-minute focused study sessions
   - Automatic 5-minute break timers
   - Visual countdown display

2. **Task Organization**: Allows users to:
   - Create and manage to-do lists
   - Mark tasks as complete/incomplete
   - Track pending and completed tasks

3. **Note Taking**: Provides:
   - Quick note creation and editing
   - Color-coded note cards for easy organization
   - Full CRUD (Create, Read, Update, Delete) operations

4. **User Management**: Features:
   - Secure authentication via Firebase
   - User profile management
   - Account deletion capabilities

---

## 4. Application Screens

### Screen 1: Splash Screen
- **File**: `lib/splash.dart`
- **Type**: StatefulWidget
- **Class**: `SplashScreen` → `_SplashScreenState`
- **Purpose**: Initial loading screen
- **Features**:
  - Displays app logo
  - Shows loading indicator
  - Checks authentication status
  - Auto-navigates after 2 seconds
- **Navigation Logic**:
  - If user is logged in → HomePage
  - If user is not logged in → RegisterPage

---

### Screen 2: Register Page
- **File**: `lib/register.dart`
- **Type**: StatefulWidget
- **Class**: `RegisterPage` → `_RegisterPageState`
- **Purpose**: New user registration
- **Features**:
  - Username input field
  - Email input field with validation
  - Password input field with visibility toggle
  - Confirm password field
  - Form validation
  - Error handling with user-friendly messages
- **Data Flow**:
  - Collects: username, email, password
  - Creates Firebase Auth account
  - Saves user profile to Firestore (`users` collection)
  - Navigates to HomePage on success

---

### Screen 3: Login Page
- **File**: `lib/login.dart`
- **Type**: StatefulWidget
- **Class**: `LoginPage` → `_LoginPageState`
- **Purpose**: Existing user authentication
- **Features**:
  - Email input field
  - Password input field with visibility toggle
  - Form validation
  - Loading state indicator
  - Error messages for invalid credentials
  - Link to Register page
- **Data Flow**:
  - Authenticates via Firebase Auth
  - Retrieves user session
  - Navigates to HomePage on success

---

### Screen 4: Home Page
- **File**: `lib/home.dart`
- **Type**: StatefulWidget
- **Class**: `HomePage` → `_HomePageState`
- **Purpose**: Main dashboard and app hub
- **Features**:
  - Welcome message with username
  - Statistics cards showing:
    - Completed todos count (green)
    - Pending todos count (orange)
    - Total notes count (blue)
  - Pomodoro timer widget (top-right corner)
  - Recent todos preview (last 3)
  - Recent notes preview (last 4 in grid)
  - Navigation drawer with menu
  - Pull-to-refresh functionality
- **Navigation Drawer**:
  - Header with school icon and "StudyMan" text
  - To-Do menu item
  - Notes menu item
  - Settings (Profile) menu item
- **Data Flow**:
  - Loads user data from Firestore
  - Real-time listeners for todos and notes counts
  - Streams data for preview sections

---

### Screen 5: To-Do Page
- **File**: `lib/todo.dart`
- **Type**: StatefulWidget
- **Class**: `TodoPage` → `_TodoPageState`
- **Purpose**: Complete task management
- **Features**:
  - Floating action button to add new todos
  - List of all todos with checkboxes
  - Strike-through styling for completed tasks
  - Swipe-to-delete functionality
  - Edit todo dialog
  - Empty state message
  - Real-time updates
- **Data Operations**:
  - **Create**: `addTodo(title)` → adds to `users/{uid}/todos` collection
  - **Read**: Real-time stream from Firestore
  - **Update**: 
    - Toggle completion: `toggleTodo(docId, status)`
    - Edit title: `updateTodoTitle(docId, newTitle)`
  - **Delete**: `deleteTodo(docId)`
- **Data Structure**:
  ```dart
  {
    'title': String,
    'isDone': bool,
    'createdAt': Timestamp
  }
  ```

---

### Screen 6: Notes Page
- **File**: `lib/note.dart`
- **Type**: StatefulWidget
- **Class**: `NotePage` → `_NotePageState`
- **Purpose**: Note-taking and organization
- **Features**:
  - Floating action button to create notes
  - Grid layout of note cards (2 columns)
  - Color-coded cards (blue, green, orange, purple)
  - Tap to edit existing notes
  - Long-press menu for delete
  - Full-screen note editor dialog
  - Empty state message
- **Data Operations**:
  - **Create**: `addNote(title, content)`
  - **Read**: Real-time stream from Firestore
  - **Update**: `updateNote(docId, title, content)`
  - **Delete**: `deleteNote(docId)` with confirmation dialog
- **Data Structure**:
  ```dart
  {
    'title': String,
    'content': String,
    'createdAt': Timestamp
  }
  ```

---

### Screen 7: Profile Page
- **File**: `lib/profile.dart`
- **Type**: StatefulWidget
- **Class**: `ProfilePage` → `_ProfilePageState`
- **Purpose**: User account management
- **Features**:
  - Profile icon
  - Display user email (read-only)
  - Editable username field
  - Update username button
  - Logout button with confirmation
  - Delete account button with password verification
- **Data Operations**:
  - Loads user data from `users/{uid}` document
  - Updates username in Firestore
  - Deletes user data and Firebase Auth account
- **Security**:
  - Password re-authentication required for account deletion

---

### Embedded Widget: Timer Widget
- **File**: `lib/timer.dart`
- **Type**: StatefulWidget (used within HomePage)
- **Class**: `TimerWidget` → `_TimerWidgetState`
- **Purpose**: Pomodoro Technique timer implementation
- **Features**:
  - Compact circular display (60x60px)
  - Default: 25-minute work session
  - Click to open time picker bottom sheet
  - Scrollable hour/minute/second selectors
  - Start/Pause/Resume controls
  - Reset button
  - Automatic break mode:
    - After 25-min work → auto-starts 5-min break
    - After 5-min break → returns to idle
  - Visual countdown display
  - Completion dialog with notifications
- **States**:
  - Idle: Shows timer icon
  - Running: Shows countdown with pause icon
  - Paused: Shows countdown with play icon
  - Break Mode: Different completion message

---

## 5. Data Architecture

### Authentication Flow
```
User → Firebase Auth → AuthService
```
- Passwords are **never** stored in the database
- Firebase Auth stores hashed passwords securely on Google's servers
- App stores only authentication tokens locally

### Database Structure
```
Firestore
└── users (collection)
    ├── {userId} (document)
    │   ├── email: string
    │   ├── username: string
    │   ├── createdAt: timestamp
    │   ├── todos (subcollection)
    │   │   └── {todoId} (document)
    │   │       ├── title: string
    │   │       ├── isDone: boolean
    │   │       └── createdAt: timestamp
    │   └── notes (subcollection)
    │       └── {noteId} (document)
    │           ├── title: string
    │           ├── content: string
    │           └── createdAt: timestamp
```

### Data Flow Between Screens

**IMPORTANT**: Data does **NOT** pass directly between screens. Instead:

1. **All data is stored in Firestore** (cloud database)
2. **Each screen reads from Firestore independently**
3. **Real-time listeners** ensure all screens stay synchronized
4. **Only user ID (uid)** is passed implicitly via Firebase Auth

**Example Workflow:**
1. User creates a todo on TodoPage
   → `DatabaseService.addTodo()` saves to Firestore
2. HomePage automatically updates
   → Real-time listener detects change
   → UI refreshes with new count
3. No direct data passing needed!

### Service Layer Architecture

#### AuthService (`lib/services/auth_service.dart`)
Handles all authentication operations:
- `signIn(email, password)`: User login
- `signUp(email, password)`: User registration
- `signOut()`: Logout
- `updateDisplayName(name)`: Update user display name
- `deleteAccount()`: Permanent account deletion
- `currentUser`: Getter for current authenticated user
- `authStateChanges`: Stream for auth state monitoring

#### DatabaseService (`lib/services/database_service.dart`)
Manages all Firestore operations:

**User Operations:**
- `saveUser(uid, email, username)`
- `getUser(uid)`
- `updateUsername(uid, username)`
- `deleteUserData(uid)`

**Todo Operations:**
- `getTodosStream(uid, limit?)`: Real-time stream
- `addTodo(uid, title)`
- `toggleTodo(uid, docId, status)`
- `updateTodoTitle(uid, docId, title)`
- `deleteTodo(uid, docId)`

**Note Operations:**
- `getNotesStream(uid, limit?)`: Real-time stream
- `addNote(uid, title, content)`
- `updateNote(uid, docId, title, content)`
- `deleteNote(uid, docId)`

---

## 6. Project Structure

```
d:\AppFireBase\
├── lib/
│   ├── main.dart                    # App entry point
│   ├── firebase_options.dart        # Firebase configuration
│   ├── splash.dart                  # Splash screen
│   ├── register.dart                # Registration screen
│   ├── login.dart                   # Login screen
│   ├── home.dart                    # Main dashboard
│   ├── todo.dart                    # To-Do list screen
│   ├── note.dart                    # Notes screen
│   ├── profile.dart                 # User profile screen
│   ├── timer.dart                   # Pomodoro timer widget
│   ├── services/
│   │   ├── auth_service.dart        # Authentication logic
│   │   └── database_service.dart    # Database operations
│   └── assets/
│       └── logo.png                 # App logo
├── android/                         # Android-specific files
├── ios/                             # iOS-specific files
├── web/                             # Web-specific files
├── windows/                         # Windows-specific files
├── linux/                           # Linux-specific files
├── macos/                           # macOS-specific files
├── pubspec.yaml                     # Dependencies & assets
├── analysis_options.yaml            # Linting rules
└── README.md                        # Basic project info
```

---

## 7. Setup Instructions

### Prerequisites

1. **Flutter SDK** (version >=3.1.4)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter --version`

2. **Dart SDK** (included with Flutter)

3. **Firebase Account**
   - Create a Firebase project at: https://console.firebase.google.com

4. **IDE** (choose one):
   - Android Studio with Flutter plugin
   - Visual Studio Code with Flutter extension
   - IntelliJ IDEA with Flutter plugin

5. **Device/Emulator**:
   - Android Emulator, iOS Simulator, or physical device
   - OR Chrome for web testing

---

### Step 1: Clone/Download the Project

```bash
# If using Git:
git clone <repository-url>
cd AppFireBase

# Or download and extract the ZIP file, then navigate to the folder
cd path/to/AppFireBase
```

---

### Step 2: Install Flutter Dependencies

```bash
flutter pub get
```

This command downloads all packages listed in `pubspec.yaml`:
- firebase_core
- firebase_auth
- cloud_firestore
- cupertino_icons

---

### Step 3: Firebase Setup

#### A. Create Firebase Project
1. Go to https://console.firebase.google.com
2. Click "Add Project"
3. Name your project (e.g., "StudyMan")
4. Disable Google Analytics (optional)
5. Click "Create Project"

#### B. Enable Authentication
1. In Firebase Console, go to **Authentication**
2. Click "Get Started"
3. Click "Sign-in method" tab
4. Enable **Email/Password** provider
5. Click "Save"

#### C. Create Firestore Database
1. In Firebase Console, go to **Firestore Database**
2. Click "Create Database"
3. Start in **Test Mode** (for development)
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```
4. Choose a Firestore location (closest to your users)
5. Click "Enable"

#### D. Register Your App Platforms

**For Android:**
1. In Firebase Console, click "Add App" → Android icon
2. Enter package name: `com.example.app_firebase`
   - Find in `android/app/build.gradle` → `applicationId`
3. Download `google-services.json`
4. Place file in: `android/app/google-services.json`

**For iOS:**
1. Click "Add App" → iOS icon
2. Enter bundle ID: `com.example.appFirebase`
   - Find in Xcode project settings
3. Download `GoogleService-Info.plist`
4. Place in: `ios/Runner/GoogleService-Info.plist`

**For Web:**
1. Click "Add App" → Web icon
2. Register app with a nickname
3. Copy the Firebase configuration
4. Update `lib/firebase_options.dart` with your config

---

### Step 4: Configure Firebase in Flutter

The project already includes `firebase_options.dart`. If you need to regenerate it:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Generate configuration
flutterfire configure
```

This will:
- Detect your Firebase project
- Generate platform-specific configs
- Update `firebase_options.dart`

---

### Step 5: Platform-Specific Setup

**Android (`android/build.gradle`):**
Ensure this line exists in dependencies:
```gradle
classpath 'com.google.gms:google-services:4.3.15'
```

**Android (`android/app/build.gradle`):**
At the bottom of the file:
```gradle
apply plugin: 'com.google.gms.google-services'
```

**iOS (`ios/Podfile`):**
Uncomment this line:
```ruby
platform :ios, '12.0'
```

Then run:
```bash
cd ios
pod install
cd ..
```

---

### Step 6: Run the Application

```bash
# Check available devices
flutter devices

# Run on connected device/emulator
flutter run

# Or specify a platform:
flutter run -d chrome          # For web
flutter run -d android         # For Android
flutter run -d ios             # For iOS (macOS only)
flutter run -d windows         # For Windows
```

---

### Step 7: Build for Production (Optional)

**Android APK:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Android App Bundle (for Play Store):**
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

**iOS (macOS required):**
```bash
flutter build ios --release
# Then open in Xcode to archive and upload
```

**Web:**
```bash
flutter build web --release
# Output: build/web/
```

**Windows:**
```bash
flutter build windows --release
# Output: build/windows/runner/Release/
```

---

### Troubleshooting

#### Issue: "Waiting for observatory port to be available"
**Solution:** 
- Restart the emulator/device
- Run `flutter clean` then `flutter pub get`

#### Issue: "Unable to load asset"
**Solution:**
- Check `pubspec.yaml` → assets section includes the file
- Run `flutter clean` and rebuild

#### Issue: Firebase auth errors
**Solution:**
- Verify Firebase Authentication is enabled
- Check `google-services.json` / `GoogleService-Info.plist` placement
- Ensure package name matches Firebase registration

#### Issue: Firestore permission denied
**Solution:**
- Update Firestore rules to allow authenticated users:
  ```
  allow read, write: if request.auth != null;
  ```

---

### Development Tips

1. **Hot Reload**: Press `r` in terminal during `flutter run` to reload code instantly
2. **Hot Restart**: Press `R` to restart the app completely
3. **Debug Mode**: Use `flutter run` for debugging with DevTools
4. **Release Mode**: Use `flutter run --release` for performance testing

---

### Firebase Security Rules (Production)

Before deploying to production, update Firestore rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      
      // User's todos subcollection
      match /todos/{todoId} {
        allow read, write: if request.auth.uid == userId;
      }
      
      // User's notes subcollection
      match /notes/{noteId} {
        allow read, write: if request.auth.uid == userId;
      }
    }
  }
}
```

---

## Summary

This application demonstrates:
- ✅ Clean architecture with separate service layers
- ✅ Real-time database synchronization
- ✅ Secure authentication without storing passwords locally
- ✅ Proper state management using StatefulWidgets
- ✅ Material Design 3 UI/UX principles
- ✅ Pomodoro study technique implementation
- ✅ CRUD operations for todos and notes
- ✅ Cross-platform compatibility (Android, iOS, Web, Desktop)

**Total Screens:** 7 main screens + 1 embedded widget  
**Total Stateful Widgets:** 8 (all screens are StatefulWidget)  
**Total Services:** 2 (AuthService, DatabaseService)  
**Database Collections:** 1 main (`users`) + 2 subcollections (`todos`, `notes`)

---

**Documentation Version:** 1.0  
**Last Updated:** January 10, 2026  
**Author:** StudyMan Development Team
