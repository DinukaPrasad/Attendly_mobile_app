# Attendly – Mobile Application

Attendly is a Flutter-based mobile application for university attendance tracking, currently in prototype stage.
The app includes basic navigation (login, register, attendance screens) and sample API integrations for users and students.

This project is developed as part of a **BSc (Hons) Software Engineering Final Year Project** at **Cardiff Metropolitan University**.

---

## 🚀 Key Features

### Student
- Login and register screens (UI prototype)
- View student list from backend API (Register page)
- Basic attendance screens (Scan, Confirm, History – placeholders)
- Sample users API list (API Test screen)

### Lecturer
- Planned: start attendance sessions, monitor responses
- Planned: timetable and module views

### University Management
- Planned: manage modules, timetables, lecturers
- Planned: attendance analytics and reports

### Admin
- Planned: university and system configuration management
- Planned: user and role management

---

## 🛠 Tech Stack

| Layer | Technology |
|-----|-----------|
| Framework | Flutter (Dart) |
| Routing | `MaterialApp` with `AppRoutes` |
| State Management | Stateless/Stateful widgets (no external SM yet) |
| Networking | `http` package |
| Firebase | `firebase_core` declared (FCM not integrated yet) |
| UI Components | `getwidget` (declared), `calendar_view`, `fl_chart` |
| Local Storage | To be implemented (`StorageService` placeholder) |
| Architecture | Simple layered folders (app/models/screens/services/utils/widgets) |

---

## 🧱 Architecture Overview

Application uses a straightforward layered structure:

- App shell: `MaterialApp` in `lib/app/app.dart` with theme and routes from `lib/app/routes.dart`
- Screens: UI pages under `lib/screens` (auth, attendance, profile, settings, API test)
- Models: Data models in `lib/models` (`User`, `Student`, `Attendance`, `UserName`)
- Services: HTTP integrations in `lib/services` (`test_user_api.dart`, `test_student_api.dart`), placeholders for `AuthService` and `StorageService`
- Utilities and Widgets: Reusable helpers and UI components in `lib/utils` and `lib/widgets`

---

## 📂 Project Structure

```
lib/
 ├─ main.dart
 ├─ app/
 │   ├─ app.dart
 │   ├─ routes.dart
 │   └─ theme.dart
 ├─ models/
 │   ├─ attendance.dart
 │   ├─ student.dart
 │   ├─ user.dart
 │   └─ user_name.dart
 ├─ screens/
 │   ├─ api_test.dart
 │   ├─ attendance/
 │   │   ├─ confirm_screen.dart
 │   │   ├─ history_screen.dart
 │   │   └─ scan_screen.dart
 │   ├─ auth/
 │   │   ├─ login_screen.dart
 │   │   └─ register_screen.dart
 │   ├─ profile/
 │   │   └─ profile_screen.dart
 │   └─ settings/
 │       └─ settings_screen.dart
 ├─ services/
 │   ├─ auth_service.dart
 │   ├─ storage_service.dart
 │   ├─ test_student_api.dart
 │   └─ test_user_api.dart
 ├─ utils/
 │   ├─ constants.dart
 │   └─ helpers.dart
 └─ widgets/
	 ├─ app_button.dart
	 ├─ app_dialog.dart
	 ├─ app_loader.dart
	 └─ app_textfield.dart
```

---

## 🔐 Security Considerations

- Planned: token-based authentication and secure token storage
- Planned: server-side attendance validation
- Planned: device binding and additional anti-cheating measures
- Current: placeholder `AuthService` and `StorageService` exist but are not implemented

---

## ▶️ Running the App Locally

```bash
flutter pub get
flutter run
```

Tip: For the Register and API Test screens, ensure the backend/student API is reachable (`lib/services/test_student_api.dart` base URL) or use the Random User API for demo data.

---

## 📌 Project Status

🔧 In active development (Final Year Project – 2026)

---

## 👨‍🎓 Author

**A.G. Dinuka Prasad Premarathna**  
BSc (Hons) Software Engineering  
Cardiff Metropolitan University

---

## 📄 License

This project is developed for **academic purposes only**.
