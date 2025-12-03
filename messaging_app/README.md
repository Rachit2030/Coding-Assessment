# 🚀 Messaging App

### *Flutter App (AI Chat) + Embedded Angular WebView*

A modern messaging application that embeds an Angular web dashboard
inside a Flutter WebView --- combined with Gemini AI--powered chat,
persistent message storage, and smooth Bloc state management.

------------------------------------------------------------------------

## 📋 Table of Contents

-   [📦 Angular HTTP Server](#-angular-http-server)
-   [📱 Flutter App + WebView](#-flutter-app--webview)
-   [🤖 Gemini AI Setup](#-gemini-ai-setup)
-   [✨ Features](#-features)
-   [🔧 Troubleshooting](#-troubleshooting)
-   [⚡ Quick Start](#-quick-start)

------------------------------------------------------------------------

# 📦 Angular HTTP Server

### **Prerequisites**

``` bash
npm install -g @angular/cli@16
node --version     # v18+ recommended
npm --version
```

------------------------------------------------------------------------

### **Start Server**

``` bash
cd webpage  
npm install
npm start
```

📡 **Server runs at:** `http://localhost:4200` *(Network accessible)*\
🛑 **To stop:** `Ctrl + C`

------------------------------------------------------------------------

# 📱 Flutter App + WebView

### **Your `pubspec.yaml` (Provided)**

``` yaml
dependencies:
  flutter_bloc: ^8.1.3
  google_generative_ai: ^0.4.0
  hive_flutter: ^1.1.0
  webview_flutter: ^4.7.0
  image_picker: ^1.0.7
  uuid: ^4.5.2
```

------------------------------------------------------------------------

### **Setup & Run**

``` bash
cd messaging_app
flutter pub get
flutter run
```

------------------------------------------------------------------------

# 🤖 Gemini AI Setup

### **1. Create a Free API Key**

🔗 https://aistudio.google.com/app/apikey

------------------------------------------------------------------------

### **2. Configure Flutter**

Edit: `lib/Data/constants.dart`

``` dart
const String GEMINI_API_KEY = 'your-actual-api-key-here';
```

Use inside your `ChatCubit` as needed.

------------------------------------------------------------------------

# ✨ Features

### ✅ **Core Features**

-   Angular web app with device theme sync
-   Flutter AI chat using **Gemini 2.5 Flash**
-   Embedded Angular inside Flutter WebView
-   Persistent messages (Hive)
-   Image support + emoji support
-   Bloc/Cubit state management
-   Offline fallback bot
-   Distinct sender names (Rachit AI vs Fallback bot)

------------------------------------------------------------------------

### ⚡ **Stretch Goals**

-   Zero-downtime fallback for AI outages\
-   Full screen overlay hamburger menu on mobile\
-   Network-accessible Angular dev server\
-   Perfect light/dark theme sync

------------------------------------------------------------------------

# 🔧 Troubleshooting

  -----------------------------------------------------------------------
  Issue                         Solution
  ----------------------------- -----------------------------------------
  WebView shows blank           Use `http://10.0.2.2:4200` for Android
                                emulator

  "Model not supported" error   Use `gemini-2.5-flash`

  Angular unreachable           `ng serve --host 0.0.0.0 --port 4200`

  Android cleartext blocked     Add `android:usesCleartextTraffic="true"`
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# ⚡ Quick Start

### **Terminal 1 --- Angular**

``` bash
cd webpage
npm install
npm start
```

### **Terminal 2 --- Flutter**

``` bash
cd messaging_app
flutter pub get
flutter run
```

🎉 **Your Flutter messaging app now loads the Angular WebView and Gemini
AI chat!**
