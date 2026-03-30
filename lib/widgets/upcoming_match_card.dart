import 'package:flutter/material.dart';

class UpcomingMatchCard extends StatelessWidget {
  const UpcomingMatchCard({
    super.key,
    required this.team1,
    required this.team2,
    required this.dateTime,
  });

  final String team1;
  final String team2;
  final String dateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$team1 vs $team2',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateTime,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const Icon(Icons.arrow_forward, color: Color(0xFF00FF87)),
        ],
      ),
    );
  }
}
