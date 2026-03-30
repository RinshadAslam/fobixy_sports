# Fobixy Sports - API Integration Setup

## Prerequisites

1. **Flutter SDK**: Ensure Flutter is installed and configured.
2. **RapidAPI Account**: Sign up at [RapidAPI](https://rapidapi.com/).
3. **API-Football Subscription**: Subscribe to [API-Football](https://rapidapi.com/api-sports/api/api-football) on RapidAPI.

## Setup Steps

### 1. Add Dependencies

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  flutter_dotenv: ^5.1.0  # For secure API key storage

dev_dependencies:
  flutter_test:
    sdk: flutter
```

Run `flutter pub get`.

### 2. Get API Key

1. Go to [API-Football on RapidAPI](https://rapidapi.com/api-sports/api/api-football).
2. Subscribe to a plan.
3. Copy your API key from the dashboard.

### 3. Configure Environment

1. Create a `.env` file in the root of your project (add to `.gitignore`).
2. Add your API key:

```
RAPIDAPI_KEY=your_actual_api_key_here
```

3. In `lib/main.dart`, add:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}
```

4. Update `lib/services/football_api_service.dart`:

```dart
static const String _apiKey = dotenv.env['RAPIDAPI_KEY'] ?? '';
```

### 4. API Endpoints Used

- **Live Matches**: `/v3/fixtures?live=all`
- **League Matches**: `/v3/fixtures?league={leagueId}&season={season}`
- **International Matches**: `/v3/fixtures?league={internationalLeagueId}&season={season}`

### 5. Run the App

```bash
flutter run
```

Navigate to the Matches tab to see real data.

## Security Notes

- Never commit API keys to version control.
- Use environment variables or secure storage for production apps.
- The `.env` file is added to `.gitignore` to prevent accidental commits.

## Troubleshooting

- **API Errors**: Check your RapidAPI key and subscription limits.
- **No Data**: Ensure the league IDs and seasons are correct.
- **Network Issues**: Verify internet connection and API endpoints.

## Data Flow

1. **UI** (MatchesScreen) → Calls service methods
2. **Service** (FootballApiService) → Makes HTTP requests to RapidAPI
3. **API Response** → Parsed into MatchModel objects
4. **UI Update** → Displays real match data with loading/error states