# Employee Monitor Flutter Client

This client uses the completed auth service login endpoint:

`POST /verinite/EMS/auth/login`

Request body:

```json
{"username":"your-username","password":"your-password"}
```

## Run locally

Start the Spring Boot auth service on port `8081`, then run the Flutter client:

```powershell
flutter pub get
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8081
```

For an Android emulator, use the host loopback address instead:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8081
```

The app stores the returned access and refresh tokens locally, displays backend errors, and clears the session on sign out.
