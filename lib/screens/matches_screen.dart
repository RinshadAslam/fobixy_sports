import 'package:flutter/material.dart';
import '../services/football_api_service.dart';
import '../services/demo_stream_service.dart';
import '../models/match_model.dart';
import 'video_player_screen.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({
    super.key,
    required this.followedTeams,
    required this.onFollowToggle,
  });

  final Set<String> followedTeams;
  final void Function(String) onFollowToggle;

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  bool _showClubs = true;
  List<MatchModel> _clubMatches = [];
  List<MatchModel> _countryMatches = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMatches();
  }

  Future<void> _fetchMatches() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final clubMatches = await FootballApiService.fetchLeagueMatches(
        39,
        2023,
      ); // Premier League
      final countryMatches =
          await FootballApiService.fetchInternationalMatches();

      setState(() {
        _clubMatches = clubMatches;
        _countryMatches = countryMatches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _selectFilter(bool showClubs) {
    setState(() {
      _showClubs = showClubs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF0D0D0D),
      body: RefreshIndicator(
        onRefresh: _fetchMatches,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _FilterButton(
                      label: 'Clubs',
                      selected: _showClubs,
                      onTap: () => _selectFilter(true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _FilterButton(
                      label: 'Countries',
                      selected: !_showClubs,
                      onTap: () => _selectFilter(false),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00FF87),
                      ),
                    )
                  : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'Error: $_error',
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchMatches,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount:
                          (_showClubs ? _clubMatches : _countryMatches).length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final match = (_showClubs
                            ? _clubMatches
                            : _countryMatches)[index];
                        return MatchCard(
                          match: match,
                          isTeam1Followed: widget.followedTeams.contains(
                            match.homeTeam,
                          ),
                          isTeam2Followed: widget.followedTeams.contains(
                            match.awayTeam,
                          ),
                          onTeam1Action: () =>
                              widget.onFollowToggle(match.homeTeam),
                          onTeam2Action: () =>
                              widget.onFollowToggle(match.awayTeam),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    MatchPlayerScreen(matchData: match),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF00FF87) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFF00FF87) : Colors.grey.shade900,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
    required this.match,
    required this.isTeam1Followed,
    required this.isTeam2Followed,
    required this.onTeam1Action,
    required this.onTeam2Action,
    required this.onTap,
  });

  final MatchModel match;
  final bool isTeam1Followed;
  final bool isTeam2Followed;
  final VoidCallback onTeam1Action;
  final VoidCallback onTeam2Action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        match.homeTeam,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: Icon(
                          isTeam1Followed
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isTeam1Followed
                              ? const Color(0xFF00FF87)
                              : Colors.grey,
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          onTeam1Action();
                        },
                      ),
                    ],
                  ),
                  if (match.isLive)
                    const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (match.isLive) const SizedBox(height: 8),
                  if (match.isLive)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => VideoPlayerScreen(
                              match: match,
                              streamUrl:
                                  DemoStreamService.getRandomDemoStream(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_circle_fill, size: 16),
                      label: const Text('Watch'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        minimumSize: const Size(0, 32),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  match.scoreOrTime,
                  style: const TextStyle(
                    color: Color(0xFF00FF87),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (match.isLive) const SizedBox(height: 4),
                if (match.isLive)
                  Text(
                    match.matchTimeDisplay,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          isTeam2Followed
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isTeam2Followed
                              ? const Color(0xFF00FF87)
                              : Colors.grey,
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          onTeam2Action();
                        },
                      ),
                      const SizedBox(width: 6),
                      Text(
                        match.awayTeam,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchPlayerScreen extends StatelessWidget {
  const MatchPlayerScreen({super.key, required this.matchData});

  final MatchModel matchData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Player'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: Text(
          '${matchData.homeTeam} vs ${matchData.awayTeam} - ${matchData.scoreOrTime}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
