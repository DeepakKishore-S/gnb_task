Here’s a tailored README for your GitHub repository, based on the project details you provided earlier. You can adjust any parts to better fit your project's specifics.

---

# GNB Task

This Flutter application allows users to capture multiple images, fetch photo data from a remote API, and implement various features like dark mode support, Google Sign-In, and push notifications.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Firebase Setup](#firebase-setup)

## Features

1. **Bulk Image Capture**
   - Capture multiple images in a single session.
   - Specify the number of images to capture.
   - Save images in the app's local storage with lazy loading.

2. **Lazy Load for List**
   - Fetch photo data from [JSONPlaceholder](https://jsonplaceholder.typicode.com/photos).
   - Implement pagination to load more data as the user scrolls.

3. **Remote Image Fetch Loader**
   - Display thumbnails fetched from a remote URL.
   - Show a loading indicator while images are being fetched.

4. **Basic Animation**
   - Implement simple animations, including fade-in effects for images.

5. **Push Notifications**
   - Set up Firebase Cloud Messaging (FCM) for push notifications.
   - Simulate push notifications without a backend.

6. **Dark Mode & Light Mode**
   - Support for both themes with a toggle switch in the settings.

7. **Offline Data Persistence**
   - Store fetched data locally using Hive or Sqflite for offline access.

8. **Google Login with Profile Display & Logout**
   - Integrate Google Sign-In for authentication.
   - Display user profile information and provide a logout option.

## Installation

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Firebase account (for push notifications and Google Sign-In)

### Clone the Repository

```bash
git clone https://github.com/DeepakKishore-S/gnb_task.git
cd gnb_task
```

### Install Dependencies

Run the following command to install the required packages:

```bash
flutter pub get
```

### Setup Firebase

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new project.
3. Follow the instructions to add Firebase to your Flutter app.
4. Enable Firebase Cloud Messaging (FCM) and Google Sign-In in the Firebase console.

### Configure Android

1. Add your `google-services.json` file to the `android/app` directory.
2. Update your `android/build.gradle` and `android/app/build.gradle` files as per the Firebase documentation.

## Usage

1. Run the app using the following command:

```bash
flutter run
```

2. Use the bulk image capture feature to take multiple images.
3. Scroll through the list of photos fetched from the API.
4. Toggle between dark and light mode in the settings.
5. Sign in with Google to view and log out of your profile.


## API Endpoints

- **Mock API for Photos**: [https://jsonplaceholder.typicode.com/photos](https://jsonplaceholder.typicode.com/photos)

## Firebase Setup

- Follow the official Firebase documentation to set up FCM and Google Sign-In in your app.
- Ensure you have the necessary permissions in your `AndroidManifest.xml`.

