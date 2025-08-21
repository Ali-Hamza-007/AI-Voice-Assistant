import 'package:flutter/material.dart';
import '../home_page.dart';

class HomePageUI extends StatefulWidget {
  const HomePageUI({super.key});

  @override
  State<HomePageUI> createState() => _HomePageItemsState();
}

class _HomePageItemsState extends State<HomePageUI> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ask Allen!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Nunito',
          ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 8,
          color: const Color(0xFF3A3568),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(
                    Icons.stop_circle_rounded,
                    color: Colors.blueAccent,
                    size: 40,
                  ),
                ),
                const Text(
                  'Hi, I am Allen ',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const Text(
                  'What can I do for you today?',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 10,
          runSpacing: 10,

          children: [
            Row(
              children: [
                MakeChip(title: 'Sing me a song'),
                SizedBox(width: 20),
                MakeChip(title: 'Best Restaurants'),
              ],
            ),

            // const SizedBox(height: 20),
            Row(
              children: [
                MakeChip(title: 'Sports News'),
                SizedBox(width: 35),

                MakeChip(title: 'Random fun'),
              ],
            ),

            // const SizedBox(height: 20),
            Row(
              children: [
                MakeChip(title: 'Today\'s Weather'),
                SizedBox(width: 12),

                MakeChip(title: 'What about tomorrow?'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
