<div align="center">

# 🧠 Brain Games

### AI-powered quiz app with carrier-billing subscriptions

Test your knowledge, climb the global leaderboard, and learn from your mistakes with Gemini-powered explanations.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

**[🌐 Live Demo](https://quiz.solobit.dev)** · **[Report Bug](../../issues)** · **[Request Feature](../../issues)**

</div>

---

## 📸 Screenshots

<!-- Add 3-4 screenshots in a /screenshots folder, then uncomment -->
<!--
<p align="center">
  <img src="screenshots/home.png" width="22%" />
  <img src="screenshots/quiz.png" width="22%" />
  <img src="screenshots/result.png" width="22%" />
  <img src="screenshots/leaderboard.png" width="22%" />
</p>
-->

## ✨ Features

### 🎮 Quiz Experience
- Multiple-choice quizzes by category and difficulty
- **AI-generated quizzes**: type any topic and Gemini builds a 10-question quiz
- **AI answer explanations**: wrong answers are explained in batch as structured JSON
- **AI chat assistant** with streaming responses
- Shareable results and animated score screen

### 🏆 Social & Progress
- Global **leaderboard** with a podium UI, pagination and time filters
- Profile with editable details and image upload
- Email and **Google Sign-In** via Firebase Auth

### 💳 Subscription System (BDApps Carrier Billing)
- OTP-based subscribe flow
- Subscription status check
- Confirmation-guarded **unsubscribe** flow
- Subscription event listener endpoint
- Bangladeshi mobile numbers normalized and validated (`018…`, `88018…`, `+88018…`)

### 🔔 Engagement
- Push notifications with Firebase Cloud Messaging
- Offline caching with Hive

## 🏗️ Architecture

```
Quiz-App/
├── client_app/        # Flutter app (Android, iOS, Web, Desktop)
│   └── lib/
│       ├── models/        # Data classes
│       ├── services/      # Firebase, API, Gemini, notifications, Hive
│       ├── repository/    # Data access layer
│       ├── providers/     # State management (Provider)
│       ├── pages/         # 13 screens, routed with GoRouter
│       └── widgets/       # Reusable UI (podium, score circle, etc.)
├── bdapps_api_py/     # FastAPI billing service (Dockerized)
└── bdapps_api_php/    # PHP billing service (alternative backend)
```

```
Flutter App ──► FastAPI / PHP Service ──► BDApps Subscription API
     │
     ├──► Firebase (Auth · Firestore · Storage · FCM)
     └──► Gemini (quiz generation · explanations · chat)
```

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter, Dart, Provider, GoRouter, Dio, Hive |
| Auth & Data | Firebase Auth, Cloud Firestore, Firebase Storage |
| AI | Gemini via Firebase AI |
| Notifications | Firebase Cloud Messaging, flutter_local_notifications |
| Billing Backend | FastAPI (async, httpx) · PHP |
| DevOps | Docker, Cloud Run-ready |

## 🔌 Billing API (FastAPI)

| Method | Endpoint | Description |
|---|---|---|
| POST | `/otp/send` | Request an OTP for a subscriber |
| POST | `/otp/verify` | Verify OTP and activate subscription |
| POST | `/subscription/check` | Check current subscription status |
| POST | `/subscription/unsubscribe` | Cancel the subscription |
| POST | `/subscription/listener` | Receive BDApps subscription notifications |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x
- Python 3.10+
- A Firebase project
- BDApps developer account (for billing)

### 1. Run the Flutter app
```bash
cd client_app
flutter pub get
flutterfire configure      # link your own Firebase project
flutter run
```

### 2. Run the billing service (FastAPI)
```bash
cd bdapps_api_py
python -m venv .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

Create a `.env` file:
```env
BDAPPS_APP_ID=your_app_id
BDAPPS_PASSWORD=your_password
```

Start the server:
```bash
uvicorn main:app --reload --port 8000
```

### Or use Docker
```bash
cd bdapps_api_py
docker build -t brain-games-api .
docker run -p 8080:8080 --env-file .env brain-games-api
```

## 🔐 Security Notes
- Never commit credentials. Keep BDApps credentials in environment variables.
- Restrict CORS origins before deploying to production.

## 🗺️ Roadmap
- [ ] Persist subscription events from the listener to a database
- [ ] Add more quiz categories and daily challenges
- [ ] Expand unit and widget test coverage
- [ ] CI/CD with GitHub Actions

## 👨‍💻 Author

**Hasin Ishrak**, Software Engineering student at SUST, Bangladesh

[Portfolio](https://hasin-ishrak.github.io) · [GitHub](https://github.com/Hasin-Ishrak) · [Email](mailto:ishrakhasin758@gmail.com)

---

<div align="center">⭐ If you like this project, give it a star!</div>
