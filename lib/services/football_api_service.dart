import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/match_model.dart';

class FootballApiService {
  static const String _baseUrl = 'https://api-football-v1.p.rapidapi.com/v3';
  // API key from environment variable, with fallback message
  static String get _apiKey =>
      dotenv.env['RAPIDAPI_KEY'] ?? 'YOUR_API_KEY_NOT_SET';

  static Map<String, String> get _headers => {
    'X-RapidAPI-Key': _apiKey,
    'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com',
  };

  // Fetch live matches
  static Future<List<MatchModel>> fetchLiveMatches() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/fixtures?live=all'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final fixtures = data['response'] as List;
      return fixtures.map((fixture) => MatchModel.fromJson(fixture)).toList();
    } else {
      throw Exception('Failed to load live matches');
    }
  }

  // Fetch matches for a specific league (club matches)
  static Future<List<MatchModel>> fetchLeagueMatches(
    int leagueId,
    int season,
  ) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/fixtures?league=$leagueId&season=$season'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final fixtures = data['response'] as List;
      return fixtures.map((fixture) => MatchModel.fromJson(fixture)).toList();
    } else {
      throw Exception('Failed to load league matches');
    }
  }

  // Fetch international matches (World Cup, Euro, etc.)
  static Future<List<MatchModel>> fetchInternationalMatches() async {
    // API-Football has international leagues, e.g., World Cup qualifiers
    // For simplicity, fetch from a specific international league
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/fixtures?league=1&season=2022',
      ), // Example: World Cup 2022
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final fixtures = data['response'] as List;
      return fixtures.map((fixture) => MatchModel.fromJson(fixture)).toList();
    } else {
      throw Exception('Failed to load international matches');
    }
  }

  // Fetch upcoming matches
  static Future<List<MatchModel>> fetchUpcomingMatches() async {
    final now = DateTime.now();
    final from =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final response = await http.get(
      Uri.parse('$_baseUrl/fixtures?date=$from'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final fixtures = data['response'] as List;
      return fixtures.map((fixture) => MatchModel.fromJson(fixture)).toList();
    } else {
      throw Exception('Failed to load upcoming matches');
    }
  }
}
