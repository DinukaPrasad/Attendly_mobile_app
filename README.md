# Attendly – Mobile Application

Attendly is a **mobile-based, anti-cheating attendance system** designed for UK universities.
This Flutter application enables students, lecturers, and university administrators to manage and verify attendance using **location-aware verification mechanisms**.

This project is developed as part of a **BSc (Hons) Software Engineering Final Year Project** at **Cardiff Metropolitan University**.

---

## 🚀 Key Features

### Student
- Secure authentication
- View personal timetable
- Receive real-time attendance notifications
- Mark attendance using GPS-based verification
- View attendance history and statistics

### Lecturer
- View assigned modules and timetable
- Start attendance sessions
- Send attendance requests to students
- Monitor live attendance responses

### University Management
- Manage modules, timetables, and lecturers
- View attendance analytics and reports

### Admin
- Manage universities and system-wide configurations
- User and role management

---

## 🛠 Tech Stack

| Layer | Technology |
|-----|-----------|
| Framework | Flutter (Dart) |
| State Management | Riverpod / Bloc |
| Networking | Dio |
| Location Services | GPS, Geofencing |
| Notifications | Firebase Cloud Messaging (FCM) |
| Local Storage | Hive, Secure Storage |
| Architecture | Clean Architecture |

---

## 🧱 Architecture Overview

The application follows **Clean Architecture** principles:

- **Presentation Layer** – UI components, pages, state controllers
- **Domain Layer** – Business logic and use cases
- **Data Layer** – API communication, repositories, models

This structure ensures scalability, maintainability, and testability.

---

## 📂 Project Structure

```
lib/
 ├─ core/
 ├─ features/
 │   ├─ auth/
 │   ├─ attendance/
 │   ├─ timetable/
 │   ├─ admin/
 │   └─ management/
 └─ main.dart
```

---

## 🔐 Security Considerations

- Token-based authentication
- Secure token storage
- Server-side attendance validation
- Device binding to reduce impersonation

---

## ▶️ Running the App Locally

```bash
flutter pub get
flutter run
```

> Ensure the backend API is running before testing full functionality.

---

## 📌 Project Status

🔧 In active development (Final Year Project – 2025)

---

## 👨‍🎓 Author

**A.G. Dinuka Prasad Premarathna**  
BSc (Hons) Software Engineering  
Cardiff Metropolitan University

---

## 📄 License

This project is developed for **academic purposes only**.
