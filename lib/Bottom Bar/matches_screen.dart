import 'package:flutter/material.dart';

class MatchData {
  const MatchData({
    required this.team1,
    required this.team2,
    required this.scoreOrTime,
    required this.isLive,
  });

  final String team1;
  final String team2;
  final String scoreOrTime;
  final bool isLive;
}

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

  final List<MatchData> _clubMatches = const [
    MatchData(
      team1: 'Barcelona',
      team2: 'Real Madrid',
      scoreOrTime: '2 - 1',
      isLive: true,
    ),
    MatchData(
      team1: 'Man City',
      team2: 'Arsenal',
      scoreOrTime: '1 - 0',
      isLive: false,
    ),
    MatchData(
      team1: 'Bayern',
      team2: 'Chelsea',
      scoreOrTime: 'FT 3 - 2',
      isLive: false,
    ),
  ];

  final List<MatchData> _countryMatches = const [
    MatchData(
      team1: 'Brazil',
      team2: 'Argentina',
      scoreOrTime: 'Live 1 - 0',
      isLive: true,
    ),
    MatchData(
      team1: 'France',
      team2: 'Germany',
      scoreOrTime: '20:00',
      isLive: false,
    ),
    MatchData(
      team1: 'Spain',
      team2: 'Italy',
      scoreOrTime: '21:30',
      isLive: false,
    ),
  ];

  void _selectFilter(bool showClubs) {
    setState(() {
      _showClubs = showClubs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final matches = _showClubs ? _clubMatches : _countryMatches;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF0D0D0D),
      body: Column(
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
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: matches.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final match = matches[index];
                return MatchCard(
                  data: match,
                  isTeam1Followed: widget.followedTeams.contains(match.team1),
                  isTeam2Followed: widget.followedTeams.contains(match.team2),
                  onTeam1Action: () => widget.onFollowToggle(match.team1),
                  onTeam2Action: () => widget.onFollowToggle(match.team2),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MatchPlayerScreen(matchData: match),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
    required this.data,
    required this.isTeam1Followed,
    required this.isTeam2Followed,
    required this.onTeam1Action,
    required this.onTeam2Action,
    required this.onTap,
  });

  final MatchData data;
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
                        data.team1,
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
                  if (data.isLive)
                    const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  data.scoreOrTime,
                  style: const TextStyle(
                    color: Color(0xFF00FF87),
                    fontSize: 16,
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
                        data.team2,
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

  final MatchData matchData;

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
          '${matchData.team1} vs ${matchData.team2} - ${matchData.scoreOrTime}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
