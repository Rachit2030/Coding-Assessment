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
-   [📸 Screenshots](#-screenshots)
-   [🔧 Troubleshooting](#-Troubleshooting)
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

### **Your `pubspec.yaml`**

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

------------------------------------------------------------------------

# ✨ Features

### ✅ **Core Features**

-   Flutter AI chat with **Gemini 2.5 Flash**
-   Angular app embedded inside Flutter WebView
-   Persistent chat storage with Hive
-   Image + Emoji support
-   Zero-downtime fallback bot
-   Bloc/Cubit architecture
-   Light/Dark theme sync
-   Distinct sender names (Rachit AI vs Fallback)

### ⚡ **Stretch Goals**

-   Full-screen overlay hamburger menu (mobile)
-   Improved theme linking with Angular
-   Enhanced offline capabilities

------------------------------------------------------------------------

# 📸 Screenshots

## 📱 Mobile (iOS App)

::: {style="display: flex; flex-wrap: wrap; gap: 10px;"}

<img src="https://github.com/user-attachments/assets/3eab43f4-458b-4bb2-8586-b066f7e02c26" width="30%" />
<img src="https://github.com/user-attachments/assets/52a23ca2-1550-4c1e-9906-fb435fdd99e8" width="30%" />
<img src="https://github.com/user-attachments/assets/d87852b0-8c2e-43aa-b4c3-46c92f897da9" width="30%" />

<img src="https://github.com/user-attachments/assets/fbf5a7b0-f5dd-4e3a-b80d-6d83707e8ca8" width="30%" />
<img src="https://github.com/user-attachments/assets/0ae00c06-40b7-4e8f-abc0-e8871f91975d" width="30%" />
<img src="https://github.com/user-attachments/assets/f9663d6a-c91f-4403-bd5e-130ededad53c" width="30%" />
<img src="https://github.com/user-attachments/assets/a9aa9a85-beb8-4fb4-800f-96fc26abb675" width="30%" />

<img src="https://github.com/user-attachments/assets/ecb2d390-4e34-4ae7-9428-3f7a1d451646" width="30%" />
:::

------------------------------------------------------------------------

## 🖥️ Web Dashboard (Angular)


<img src="https://github.com/user-attachments/assets/6c8b9925-8c55-4dc3-a225-11d48cd8fd5c" width="30%" />
<img src="https://github.com/user-attachments/assets/2eb36f8c-d50b-4f09-bcc3-df9a49a0ef21" width="30%" />
<img src="https://github.com/user-attachments/assets/9df72942-2b25-4642-b05f-4b8721e7c3f0" width="30%" />


------------------------------------------------------------------------

# 🔧 Troubleshooting

  -----------------------------------------------------------------------
  Issue                         Solution
  ----------------------------- -----------------------------------------
  WebView blank                 Use `http://10.0.2.2:4200` for Android
                                emulator

  Model not supported           Use `gemini-2.5-flash`

  Angular unreachable           `ng serve --host 0.0.0.0 --port 4200`

  Android cleartext blocked     Add `android:usesCleartextTraffic="true"`
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# ⚡ Quick Start

### Terminal 1 --- Angular

``` bash
cd webpage
npm install
npm start
```

### Terminal 2 --- Flutter

``` bash
cd messaging_app
flutter pub get
flutter run
```

🎉 **Your full messaging app is now running with Angular + Flutter AI
chat!**
