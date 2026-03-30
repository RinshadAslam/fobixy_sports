import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/matches_screen.dart';
import 'screens/follow_screen.dart';
import 'screens/profile_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final Set<String> _followedTeams = <String>{};

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
    final List<Widget> screens = [
      const HomeScreen(),
      MatchesScreen(
        followedTeams: _followedTeams,
        onFollowToggle: _toggleFollow,
      ),
      FollowScreen(followedTeams: _followedTeams, onUnfollow: _toggleFollow),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D0D0D),
        selectedItemColor: const Color(0xFF00FF87),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
