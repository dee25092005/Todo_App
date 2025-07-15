# ToDo by Dee: A Modern Task Management App

## Project Overview

"ToDo by Dee" is a feature-rich, user-friendly task management application built with Flutter. It helps users organize their daily tasks, track progress, and manage their productivity. The app incorporates modern UI/UX principles, ensuring a smooth and intuitive experience across different devices.

This project was developed as part of my learning journey to master Flutter and transition into fullstack development, focusing on practical application and best practices.

## Features

-   **Intuitive Task Management:** Easily add, edit, and manage your to-do items.
-   **Task Status Tracking:** Mark tasks as complete or pending.
-   **Soft Deletion & Restoration:** Archive tasks by soft-deleting them and restore them later from the Trash.
-   **Permanent Deletion:** Option to permanently remove tasks from storage.
-   **Task Overview Statistics:** View your task performance with real-time stats (total, completed, pending, overdue tasks, and completion rate).
-   **Persistence:** All tasks and user preferences (like theme mode) are securely saved locally using Hive.
-   **Dynamic Theming:** Switch between beautiful Light and Dark modes.
-   **Multi-language Support:** Currently supports English and Lao language for UI text.
-   **Responsive UI:** Designed to work well on various screen sizes (phones, tablets).

## Technologies Used

-   **Frontend:**
    -   **Flutter:** Leading UI toolkit for building natively compiled applications from a single codebase.
    -   **Dart:** Programming language for Flutter.
    -   **Riverpod:** A robust and scalable state management solution for Flutter applications.
    -   **GoRouter:** For declarative routing and deep linking.
-   **Local Database:**
    -   **Hive:** A lightweight and lightning-fast key-value database for local data storage.
-   **Version Control:**
    -   **Git & GitHub**

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

-   Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
-   Dart SDK (comes with Flutter)
-   A code editor like VS Code with the Flutter and Dart extensions.
-   An Android emulator/device or iOS simulator/device for testing.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
    cd your-repo-name
    ```
2.  **Get Flutter packages:**
    ```bash
    flutter pub get
    ```
3.  **Generate Riverpod and Hive files:**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
4.  **Run the application:**
    ```bash
    flutter run
    ```

### Building for Production (APK)

To build a release APK for Android:

```bash
flutter build apk --release