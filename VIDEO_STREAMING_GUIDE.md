# Fobixy Sports - Video Streaming Integration Guide

## Overview

The Fobixy Sports app includes a complete video player system for live match streaming. Currently, it uses **demo public streams** for testing. This guide shows how to integrate production streaming services.

## Current Implementation

### Components

1. **VideoPlayerScreen** (`lib/screens/video_player_screen.dart`)
   - Full-featured video player with play/pause controls
   - Fullscreen mode support
   - Buffering indicators
   - Auto-play functionality
   - Match information display
   - Error handling with retry logic

2. **DemoStreamService** (`lib/services/demo_stream_service.dart`)
   - Provides public demo HLS and MP4 streams for testing
   - Three demo streams available:
     - HLS Stream: `https://test-streams.mux.dev/x36xhzz/x3zzv.m3u8`
     - MP4 Stream 1: `https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4`
     - MP4 Stream 2: `http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_1080p_60fps_normal.mp4`

3. **MatchModel Updates**
   - Added `streamUrl` field for storing stream URLs
   - Added `matchTimeMinute` field for displaying match elapsed time
   - New `matchTimeDisplay` getter to format time display

4. **UI Integration**
   - "Watch" button appears on live match cards in red
   - Displays match time next to score during live play
   - Navigates to VideoPlayerScreen when tapped

## How to Use (Current - Demo Mode)

1. Run the app
2. Find a live match in the Matches screen
3. Click the red "Watch" button
4. Demo stream starts automatically
5. Use controls to play/pause and toggle fullscreen

## Production Streaming Integration

### Option 1: YouTube Live API

```dart
// Add to pubspec.yaml
dependencies:
  youtube_player_flutter: ^8.1.2

// Usage Example
static Future<String?> getYouTubeLiveStream(String videoId) async {
  // Use YouTube API to get live stream URL
  final apiKey = dotenv.env['YOUTUBE_API_KEY'];
  // Implementation...
}
```

### Option 2: Amazon IVS (AWS)

```dart
// Add to pubspec.yaml
dependencies:
  aws_common: ^0.1.0

// Usage Example
static Future<String?> getAmazonIVSStream(String channelArn) async {
  // Use AWS IVS API to get playback URL
  // Implementation...
}
```

### Option 3: Custom RTMP/HLS Server

```dart
static String getCustomStreamUrl(String matchId) {
  // Connect to your own streaming server
  final baseUrl = dotenv.env['STREAMING_SERVER_URL'];
  return '$baseUrl/live/$matchId/playlist.m3u8';
}
```

### Option 4: Licensed Sports Platform (DAZN, ESPN+, etc.)

```dart
// Implement OAuth2 authentication
static Future<String?> getLicensedStreamUrl(String matchId) async {
  final token = await getOAuth2Token();
  // Use licensed API to get stream URL
  // Implementation...
}
```

## Implementation Steps for Production

### 1. Update DemoStreamService

```dart
// lib/services/demo_stream_service.dart

static String getProductionStream(String matchId) {
  // Replace with your actual streaming provider logic
  
  // Example: Check if match has available stream
  if (!_isStreamAvailable(matchId)) {
    return ''; // Return empty or null if no stream
  }
  
  // Get stream URL from your backend API or provider
  return _fetchStreamUrlFromProvider(matchId);
}
```

### 2. Update MatchModel fromJson

```dart
// Include stream URL from API response
factory MatchModel.fromJson(Map<String, dynamic> json) {
  // ... existing code ...
  
  return MatchModel(
    // ... other fields ...
    streamUrl: json['stream_url'], // From API
  );
}
```

### 3. Add Backend Integration

```dart
// Create new service file: lib/services/streaming_service.dart

class StreamingService {
  static Future<String> getStreamUrl(int matchId) async {
    try {
      final response = await http.get(
        Uri.parse('$_backendUrl/matches/$matchId/stream'),
        headers: _authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['stream_url'];
      }
      throw Exception('Stream not available');
    } catch (e) {
      throw Exception('Failed to get stream: $e');
    }
  }
}
```

### 4. Update VideoPlayerScreen to Use Production Streams

```dart
// In VideoPlayerScreen initState
Future<void> _initializeVideoPlayer() async {
  try {
    final streamUrl = widget.streamUrl.isEmpty
        ? await StreamingService.getStreamUrl(widget.match.id)
        : widget.streamUrl;
    
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(streamUrl),
    );
    
    await _controller.initialize();
    _controller.play();
  } catch (e) {
    // Handle error
  }
}
```

## Architecture Recommendations

### Backend Requirements

1. **Stream URL Endpoint**
   ```
   GET /api/matches/{matchId}/stream
   Response: { stream_url: "https://..." }
   ```

2. **Authentication**
   - Use API keys for development
   - Implement OAuth2 for production
   - Add token refresh logic

3. **Stream Validation**
   - Verify stream is available before sending URL
   - Check stream health regularly
   - Return fallback streams if primary fails

### Security Best Practices

1. **API Keys**
   - Store in `.env` file (non-web)
   - Use environment variables for web
   - Rotate keys regularly

2. **Stream URLs**
   - Never commit sample URLs to production
   - Use secure HTTPS for all streams
   - Implement URL signing if needed

3. **Geo-Blocking**
   - Check user location if needed
   - Validate licensing agreements per region
   - Log unauthorized access attempts

### Scalability

1. **CDN Integration**
   - Use CDN for HLS manifest and segments
   - Implement adaptive bitrate streaming
   - Monitor bandwidth usage

2. **Caching**
   - Cache active stream URLs temporarily
   - Refresh before expiration
   - Handle network timeouts

3. **Monitoring**
   - Track stream availability
   - Monitor video player errors
   - Log user engagement metrics

## Testing

### Test with Demo Streams
```bash
flutter run -d chrome
# Navigate to a match and click "Watch"
```

### Test Error Handling
- Disable internet and tap "Watch"
- Use invalid stream URL in VideoPlayerScreen
- Verify retry button works

### Test Fullscreen
- Enter/exit fullscreen on different devices
- Test landscape orientation
- Verify controls hide/show correctly

## Troubleshooting

### Common Issues

1. **Stream won't load**
   - Check internet connection
   - Verify stream URL format
   - Check CORS headers if web
   - Check HTTP vs HTTPS

2. **Buffering loops**
   - Reduce video quality settings
   - Check network bandwidth
   - Consider HLS adaptive bitrate

3. **Controls not responsive**
   - Check tap gesture detection
   - Verify video controller state
   - Test on different devices

## File Structure

```
lib/
├── screens/
│   └── video_player_screen.dart      # Main video player UI
├── services/
│   ├── demo_stream_service.dart      # Demo streams
│   ├── streaming_service.dart        # (To add: Production streaming)
│   └── football_api_service.dart     # Existing API service
└── models/
    └── match_model.dart              # Updated with streamUrl
```

## Dependencies Used

```yaml
dependencies:
  video_player: ^2.8.1  # Core video playback
  http: ^1.2.1          # For streaming API calls
  flutter_dotenv: ^5.1.0 # For API configuration
```

## Next Steps

1. Choose a streaming provider
2. Obtain API credentials
3. Implement provider-specific integration
4. Test with live streams
5. Deploy to production
6. Monitor stream quality and user engagement

## References

- [Flutter Video Player Documentation](https://pub.dev/packages/video_player)
- [HLS Streaming Specification](https://tools.ietf.org/html/draft-pantos-http-live-streaming)
- [Amazon IVS Documentation](https://docs.aws.amazon.com/ivs/)
- [YouTube Live API](https://developers.google.com/youtube/v3)
