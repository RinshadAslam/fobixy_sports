class MatchModel {
  final int id;
  final String homeTeam;
  final String awayTeam;
  final int? homeScore;
  final int? awayScore;
  final String status;
  final DateTime date;
  final String leagueName;
  final String country;
  final String? streamUrl;
  final int? matchTimeMinute;

  MatchModel({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    this.homeScore,
    this.awayScore,
    required this.status,
    required this.date,
    required this.leagueName,
    required this.country,
    this.streamUrl,
    this.matchTimeMinute,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final fixture = json['fixture'];
    final teams = json['teams'];
    final goals = json['goals'];
    final league = json['league'];

    return MatchModel(
      id: fixture['id'],
      homeTeam: teams['home']['name'],
      awayTeam: teams['away']['name'],
      homeScore: goals['home'],
      awayScore: goals['away'],
      status: fixture['status']['short'],
      date: DateTime.parse(fixture['date']),
      leagueName: league['name'],
      country: league['country'],
      streamUrl:
          null, // Will be assigned from DemoStreamService for live matches
      matchTimeMinute: fixture['status']['elapsed'],
    );
  }

  String get scoreOrTime {
    if (status == 'FT' || status == 'AET' || status == 'PEN') {
      return '${homeScore ?? 0} - ${awayScore ?? 0}';
    } else if (status == 'NS') {
      // Not started, show time
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (status == 'LIVE' ||
        status == '1H' ||
        status == '2H' ||
        status == 'HT') {
      return '${homeScore ?? 0} - ${awayScore ?? 0}';
    } else {
      return status;
    }
  }

  bool get isLive =>
      status == 'LIVE' || status == '1H' || status == 'HT' || status == '2H';

  String get matchTimeDisplay {
    if (matchTimeMinute != null && isLive) {
      return "${matchTimeMinute.toString().padLeft(2, '0')}'";
    }
    return '';
  }
}
