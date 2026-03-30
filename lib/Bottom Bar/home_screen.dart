import 'package:flutter/material.dart';
import 'matches_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final Set<String> _followedTeams = <String>{};

  void _toggleFollow(String teamName) {
    setState(() {
      if (_followedTeams.contains(teamName)) {
        _followedTeams.remove(teamName);
      } else {
        _followedTeams.add(teamName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const HomeScreen(),
      MatchesScreen(
        followedTeams: _followedTeams,
        onFollowToggle: _toggleFollow,
      ),
      FollowScreen(followedTeams: _followedTeams, onUnfollow: _toggleFollow),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D0D0D),
        selectedItemColor: const Color(0xFF00FF87),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Matches',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Follow'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fobixy Sports'),
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Welcome to Fobixy Sports! Use the bottom nav to switch between Home, Matches, Follow, and Profile.',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class FollowScreen extends StatelessWidget {
  const FollowScreen({
    super.key,
    required this.followedTeams,
    required this.onUnfollow,
  });

  final Set<String> followedTeams;
  final void Function(String) onUnfollow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followed Teams'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF0D0D0D),
      body: followedTeams.isEmpty
          ? const Center(
              child: Text(
                'No followed teams yet',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: followedTeams.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final team = followedTeams.elementAt(index);
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.shield, color: Color(0xFF00FF87)),
                    title: Text(
                      team,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: TextButton(
                      onPressed: () => onUnfollow(team),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF87),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('Unfollow'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
