# StudyMan

StudyMan is a Flutter + Firebase mobile application designed to help students study more effectively by organizing tasks, taking notes, and managing focused study sessions using the Pomodoro technique.

---

## Overview

StudyMan aims to improve productivity and focus during study time. The app combines essential study tools into one place, making it easier for students to plan, focus, and track their work.

---

## Features

### Authentication (Firebase)

* Secure authentication using Firebase Authentication
* Email and password sign-in
* Each user has isolated and secure data

### Notes

* Create and manage personal study notes
* Simple and clean note-taking interface

### To-Do List

* Add, update, and delete tasks
* Organize study goals and daily tasks

### Pomodoro Timer

* Built-in Pomodoro timer for focused study sessions
* Work and break intervals based on the Pomodoro method
* Helps reduce burnout and improve concentration

---

## Tech Stack

* Flutter (Dart)
* Firebase Authentication
* Firebase Firestore
* Firebase Core

---

## Project Structure

The project follows a clean Flutter structure with separated concerns:

* lib/

  * screens/        UI screens
  * widgets/        Reusable widgets
  * services/       Firebase and business logic
  * models/         Data models

---

## Getting Started

### Prerequisites

* Flutter SDK installed
* Firebase project set up
* Android Studio or VS Code

### Installation

1. Clone the repository:
   git clone [https://github.com/RebwarOmer/StudyMan.git](https://github.com/RebwarOmer/StudyMan.git)

2. Navigate to the project directory:
   cd StudyMan

3. Install dependencies:
   flutter pub get

4. Configure Firebase:

   * Create a Firebase project
   * Add Android/iOS apps in Firebase console
   * Download and add configuration files

     * android/app/google-services.json
     * ios/Runner/GoogleService-Info.plist

5. Run the app:
   flutter run

---

## Firebase Configuration

Make sure the following Firebase services are enabled:

* Firebase Authentication (Email/Password)
* Cloud Firestore

---

## Future Improvements

* Statistics and productivity tracking
* Cloud backup for notes
* Custom Pomodoro intervals

---

## License

This project is for educational purposes.

---

## Author

Rebwar Omer
>>>>>>> d5f0c5a1231d991008b6fff5e8c9048a6be71028
