import 'package:flutter/material.dart';

class SdgImpactCard extends StatelessWidget {
  const SdgImpactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFE6E3FF),
            child: Icon(
              Icons.school_outlined,
              color: Color(0xFF5B4BDB),
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SDG 4 · Quality Education',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Better planning helps students meet deadlines, reduce missed work, and learn consistently.',
                ),
                SizedBox(height: 10),
                Text(
                  'Platform: Flutter Web · GitHub Codespaces',
                  style: TextStyle(
                    color: Color(0xFF5B4BDB),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}