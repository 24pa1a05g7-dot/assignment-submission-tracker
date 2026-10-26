import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Text(
            'About the project',
            style: TextStyle(
              fontSize: 31,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Assignment Tracker is a student productivity application built to make coursework planning simpler and more consistent.',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4031BF),
                  Color(0xFF796CFF),
                ],
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.school_rounded,
                  color: Color(0xFFD8D4FF),
                  size: 34,
                ),
                SizedBox(height: 16),
                Text(
                  'SDG 4 · Quality Education',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 9),
                Text(
                  'The app supports students by improving assignment planning, helping them avoid missed deadlines, and encouraging consistent learning habits.',
                  style: TextStyle(
                    color: Color(0xFFE7E5FF),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Project platform',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          const _InfoCard(
            icon: Icons.language_rounded,
            title: 'Flutter Web',
            detail: 'The application runs in a browser for fast testing and demonstration.',
          ),
          const SizedBox(height: 12),
          const _InfoCard(
            icon: Icons.cloud_outlined,
            title: 'GitHub Codespaces',
            detail: 'The project is developed and tested in a cloud-based VS Code environment.',
          ),
          const SizedBox(height: 12),
          const _InfoCard(
            icon: Icons.phone_android_outlined,
            title: 'Android ready',
            detail: 'The same Flutter codebase can later be built and run as an Android application.',
          ),
          const SizedBox(height: 28),
          Center(
            child: Text(
              'Roll number: 24PA1A05G7',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE9E7FF),
            child: Icon(icon, color: const Color(0xFF5B4BDB)),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(detail),
              ],
            ),
          ),
        ],
      ),
    );
  }
}