import 'package:flutter/material.dart';

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
