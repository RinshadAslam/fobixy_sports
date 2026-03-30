/// Demo Video Streaming Service
/// Provides public demo streaming URLs for testing video player functionality
/// These are free, public demo streams - no copyrighted content
library;

class DemoStreamService {
  /// Get demo HLS (HTTP Live Streaming) URLs for testing
  static const String demoHlsStream =
      'https://test-streams.mux.dev/x36xhzz/x3zzv.m3u8';

  /// Get demo MP4 stream URL
  static const String demoMp4Stream =
      'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4';

  /// Alternative demo stream (Big Buck Bunny)
  static const String demoAlternativeStream =
      'http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_1080p_60fps_normal.mp4';

  /// Get a random demo stream for testing
  /// Returns either HLS or MP4 format
  static String getRandomDemoStream() {
    final streams = [demoHlsStream, demoMp4Stream, demoAlternativeStream];
    streams.shuffle();
    return streams.first;
  }

  /// For production use, implement actual streaming provider integration
  /// This could be:
  /// - YouTube Live API
  /// - Amazon IVS (Interactive Video Service)
  /// - Twitch API
  /// - Custom RTMP/HLS streaming service
  /// - Licensed sports streaming provider (ESPN+, DAZN, etc.)
  static String getProductionStream(String matchId) {
    // TODO: Implement production streaming integration
    // This will replace demo streams with actual licensed streams
    return '';
  }
}
