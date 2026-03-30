import 'package:flutter/material.dart';
import '../widgets/match_card.dart';
import '../widgets/upcoming_match_card.dart';
import '../widgets/league_chip.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fobixy Sports'),
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF0D0D0D),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Match Banner
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Bayern vs Chelsea',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '2 : 0',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FF87),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('Watch Now'),
                  ),
                ],
              ),
            ),

            // Live Matches Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Live Matches',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  MatchCard(
                    team1: 'Arsenal',
                    score: '1 - 0',
                    team2: 'Liverpool',
                  ),
                  MatchCard(
                    team1: 'Man City',
                    score: '2 - 1',
                    team2: 'Tottenham',
                  ),
                  MatchCard(
                    team1: 'Real Madrid',
                    score: '0 - 0',
                    team2: 'Barcelona',
                  ),
                ],
              ),
            ),

            // Trending Matches Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Trending Matches',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  LeagueChip(label: 'Premier League'),
                  LeagueChip(label: 'La Liga'),
                  LeagueChip(label: 'UCL'),
                  LeagueChip(label: 'ISL'),
                ],
              ),
            ),

            // Upcoming Matches Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Upcoming Matches',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  UpcomingMatchCard(
                    team1: 'PSG',
                    team2: 'Juventus',
                    dateTime: 'Tomorrow, 8:00 PM',
                  ),
                  UpcomingMatchCard(
                    team1: 'Dortmund',
                    team2: 'Atletico',
                    dateTime: 'Dec 15, 7:30 PM',
                  ),
                  UpcomingMatchCard(
                    team1: 'Inter',
                    team2: 'AC Milan',
                    dateTime: 'Dec 16, 9:00 PM',
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
