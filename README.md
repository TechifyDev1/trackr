# 📊 Trackr - Smart Personal Finance Tracker

**Trackr** is a feature-rich Flutter application designed to help you manage your personal finances with ease. From tracking daily expenses to managing multiple cards and gaining AI-powered financial insights, Trackr provides a comprehensive suite of tools for financial health.

---

## ✨ Key Features

- **🔐 Secure Authentication:** Seamless login and sign-up with Email/Password and **Google Sign-In** support.
- **💸 Expense Management:**
    - Detailed expense tracking with categories.
    - Real-time updates and history.
    - Edit and delete functionalities.
- **💳 Card Management:**
    - Manage multiple credit/debit cards.
    - View card details and associated transactions.
- **🤖 AI Insights:** 
    - Advanced financial analysis and personalized insights.
    - Support for **Markdown & LaTeX** rendering for clear reports.
- **☁️ Cloud Sync:** Powered by **Firebase (Firestore & Auth)** for real-time synchronization across devices.
- **⚡ Modern UI:** Fast, responsive, and intuitive interface built with **Riverpod** for state management.

---

## 🛠️ Tech Stack

- **Frontend:** [Flutter](https://flutter.dev/) & [Dart](https://dart.dev/)
- **State Management:** [Riverpod](https://riverpod.dev/)
- **Backend:** [Firebase Authentication](https://firebase.google.com/products/auth), [Cloud Firestore](https://firebase.google.com/products/firestore)
- **Networking:** [http](https://pub.dev/packages/http)
- **Formatting:** Markdown & LaTeX support via [flutter_markdown_plus_latex](https://pub.dev/packages/flutter_markdown_plus_latex)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.10.4)
- Android Studio / VS Code
- Firebase Project

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/TechifyDev1/trackr.git
   cd trackr
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   - Create a project on the [Firebase Console](https://console.firebase.google.com/).
   - Add Android/iOS/Web apps to the project.
   - Download and place `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the respective directories.
   - Run `flutterfire configure` if you have the CLI installed.

4. **Run the app:**
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

- `lib/pages/`: UI screens (Dashboard, Expenses, Cards, AI Insights).
- `lib/models/`: Data structures (User, Expense, Card, AI Result).
- `lib/services/`: Backend logic (Auth, Firestore interactions).
- `lib/providers/`: State management using Riverpod.
- `lib/widgets/`: Reusable UI components.

---

## 📄 License

This project is for internal use and development.
