# 🔐 RBAC App

A Flutter application demonstrating **Role-Based Access Control (RBAC)** using **Firebase Authentication** and **Cloud Firestore**.

The application provides different experiences for users based on their assigned role, with **real-time role updates** through Firestore listeners.

---

## 📱 Overview

**RBAC App** is a Flutter application built to demonstrate how to implement a simple and scalable Role-Based Access Control system.

Users authenticate using Firebase Authentication, while their profile information and role are stored in Cloud Firestore.

The application automatically displays the appropriate dashboard based on the user's role:

* 👤 **User** → User Dashboard
* 🛡️ **Admin** → Admin Dashboard

The user's role is monitored in real time, so changing the role in Firestore can immediately update the application's dashboard without restarting the app.

---

## ✨ Features

* 🔐 Firebase Authentication
* 📧 Email & Password Authentication
* 👤 User Registration
* 🔑 Role-Based Access Control
* 🛡️ Admin Dashboard
* 👤 User Dashboard
* ☁️ Cloud Firestore
* ⚡ Real-Time Role Updates
* 🌍 Easy Localization support
* 🎨 Modern Material UI
* 🚀 Authentication State Management
* 🔄 Automatic Dashboard Switching

---

## 🏗️ Architecture

The application follows a simple separation of responsibilities:

```text
Flutter App
    │
    ▼
Firebase Authentication
    │
    │ authStateChanges()
    ▼
   AuthGate
    │
    ▼
Firestore users/{uid}
    │
    │ snapshots()
    ▼
 UserRoleGate
    │
    ├───────────────┐
    ▼               ▼
  User            Admin
    │               │
    ▼               ▼
UserDashboard   AdminDashboard
```

### Authentication Flow

```text
App Launch
    │
    ▼
Firebase Initialize
    │
    ▼
AuthGate
    │
    ├── Not Authenticated
    │       ↓
    │   SigninScreen
    │
    └── Authenticated
            ↓
      Firestore User
            ↓
          Check Role
         ┌────┴────┐
         ▼         ▼
       user      admin
         │         │
         ▼         ▼
      User UI   Admin UI
```

---

## 🔐 Role-Based Access Control

The application uses the following roles:

```dart
enum UserRoleEnum {
  user,
  admin,
}
```

Each user document contains a role:

```text
users/
   └── {userId}
        ├── id
        ├── displayName
        ├── email
        └── role
```

Example:

```json
{
  "id": "user-id",
  "displayName": "Ahmed",
  "email": "ahmed@example.com",
  "role": "user"
}
```

An administrator can have:

```json
{
  "id": "admin-id",
  "displayName": "Admin",
  "email": "admin@example.com",
  "role": "admin"
}
```

---

## ⚡ Real-Time Role Changes

One of the main goals of this project is supporting real-time role changes.

The application listens to the user's Firestore document using:

```dart
FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .snapshots()
```

Therefore, if the user's role changes from:

```text
user
```

to:

```text
admin
```

the application automatically rebuilds and displays:

```text
AdminDashboard
```

without requiring:

* App restart
* Manual refresh
* Re-login

### Example

```text
Firestore

role: "user"
      │
      ▼
UserDashboard
      │
      │ Role changed
      ▼
role: "admin"
      │
      ▼
AdminDashboard
```

---

## 🧩 Project Structure

```text
lib/
│
├── firebase_options.dart
│
├── main.dart
│
├── models/
│   └── user_model.dart
│
├── screens/
│   │
│   ├── signin_screen.dart
│   ├── signup_screen.dart
│   │
│   └── dashboard/
│       ├── admin_dashboard.dart
│       └── user_dashboard.dart
│
└── services/
    ├── auth_gate.dart
    └── auth_service.dart
```

### Responsibilities

#### `models/`

Contains application models.

```text
UserModel
```

Responsible for representing the application's user data.

---

#### `services/auth_service.dart`

Responsible for Firebase authentication and user data operations:

* Sign up
* Sign in
* Get current user
* Store user data in Firestore
* Handle Firebase authentication errors

---

#### `services/auth_gate.dart`

Responsible for deciding which screen should be displayed.

It listens to:

```text
Firebase Authentication
        +
Cloud Firestore
```

and determines whether the user should see:

```text
SigninScreen
UserDashboard
AdminDashboard
```

---

#### `screens/`

Contains the application's UI.

```text
SigninScreen
SignupScreen
UserDashboard
AdminDashboard
```

---

## 🔥 Firebase Services

This project uses:

### Firebase Authentication

Used for:

* User registration
* User login
* Authentication state
* User identity

### Cloud Firestore

Used for:

* User profiles
* User roles
* Real-time role updates

---

## 📦 Dependencies

Main packages used by the project include:

```yaml
dependencies:
  flutter:
    sdk: flutter

  firebase_core:
  firebase_auth:
  cloud_firestore:
  easy_localization:
  loading_animation_widget:
```

Run:

```bash
flutter pub get
```

to install dependencies.

---

## ⚙️ Setup

### 1. Clone the repository

```bash
git clone <repository-url>
```

Then:

```bash
cd rbac_app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Create a Firebase project and configure your Flutter application using the official Firebase Flutter setup.

The project requires:

* Firebase Authentication
* Cloud Firestore

Make sure Firebase configuration files are correctly generated for your target platforms.

### 4. Enable Email/Password Authentication

From Firebase Console:

```text
Authentication
    ↓
Sign-in method
    ↓
Email/Password
    ↓
Enable
```

### 5. Create Firestore Database

Create a Firestore database and create the following collection:

```text
users
```

Each authenticated user should have a document using their Firebase UID:

```text
users/{uid}
```

Example:

```json
{
  "id": "firebase-user-id",
  "displayName": "Ahmed",
  "email": "ahmed@example.com",
  "role": "user"
}
```

---

## 🌍 Localization

The project supports localization using `easy_localization`.

Example:

```dart
Text('auth.emailAlreadyInUse'.tr())
```

Translation keys can be stored in:

```text
assets/translations/
├── ar.json
└── en.json
```

Example:

```json
{
  "auth": {
    "emailAlreadyInUse": "This email is already registered.",
    "invalidEmail": "Please enter a valid email address."
  }
}
```

This keeps error messages independent from the application's current language.

---

## 🔑 Authentication Error Handling

Firebase errors are converted into application-specific error keys.

For example:

```text
FirebaseAuthException
        │
        ▼
email-already-in-use
        │
        ▼
auth.emailAlreadyInUse
        │
        ▼
easy_localization
        │
        ▼
Translated Message
```

This approach keeps Firebase-specific error codes out of the UI.

---

## 🚀 Running the Project

Run the application using:

```bash
flutter run
```

For a specific device:

```bash
flutter devices
```

Then:

```bash
flutter run -d <device-id>
```

---

## 🧪 Testing RBAC

You can test the RBAC functionality using the following steps.

### Test User Role

1. Create a new account.
2. The account should be created with:

```text
role: user
```

3. Login.
4. The application should display:

```text
UserDashboard
```

### Test Admin Role

Change the Firestore document:

```text
users/{uid}
```

from:

```json
{
  "role": "user"
}
```

to:

```json
{
  "role": "admin"
}
```

The application should automatically switch to:

```text
AdminDashboard
```

---

## 🛡️ Security Considerations

The role stored in Firestore should **not be considered secure just because the UI hides admin functionality**.

The application should also use **Firestore Security Rules** to protect admin-only operations.

For example, client-side checks such as:

```dart
if (user.isAdmin()) {
  // Show admin UI
}
```

are useful for the UI, but they are **not sufficient for security**.

Sensitive Firestore operations should be protected by server-side security rules.

---

## 🔮 Future Improvements

Possible improvements for this project:

* [ ] Firebase Security Rules for role-based permissions
* [ ] Admin user management
* [ ] Admin role assignment
* [ ] Recipe management
* [ ] Category management
* [ ] Favorites
* [ ] Search
* [ ] Password reset
* [ ] Email verification
* [ ] Google Sign-In
* [ ] Better error handling
* [ ] Unit tests
* [ ] Widget tests
* [ ] Clean Architecture
* [ ] Repository pattern
* [ ] Dependency Injection
* [ ] Custom RBAC permissions
* [ ] Multiple admin roles

---

## 🧠 RBAC Concept

The main concept demonstrated by this project is:

```text
Authentication
      ↓
Who are you?
      ↓
Firebase Auth
      ↓
      ↓
Authorization
      ↓
What are you allowed to access?
      ↓
Firestore Role
      ↓
      ├── user
      │     ↓
      │  UserDashboard
      │
      └── admin
            ↓
       AdminDashboard
```

Authentication answers:

> **Who is the user?**

Authorization answers:

> **What can this user access?**

This project demonstrates the separation between both concepts using Firebase Authentication and Cloud Firestore.

---

## 🛠️ Tech Stack

| Technology              | Purpose              |
| ----------------------- | -------------------- |
| Flutter                 | Cross-platform UI    |
| Dart                    | Programming language |
| Firebase Authentication | Authentication       |
| Cloud Firestore         | User data & roles    |
| Easy Localization       | Localization         |
| Material Design         | UI                   |
| Git                     | Version control      |

---

## 👨‍💻 Author

**Ahmed Alaayq**

Flutter Developer

---

## 📄 License

This project is created for learning and demonstration purposes.
