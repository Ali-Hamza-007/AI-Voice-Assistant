import 'package:flutter/material.dart';

class responseUI extends StatefulWidget {
  final res;
  const responseUI({super.key, required this.res});

  @override
  State<responseUI> createState() => _responseUIState();
}

class _responseUIState extends State<responseUI> {
  @override
  Widget build(BuildContext context) {
    final response = widget.res;
    return Column(
      children: [
        Wrap(
          children: [
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: const Color(0xFF201C46),
                child: Image.asset('assets/AllenImage.png'),
              ),
            ),
            SizedBox(height: 80),
            Center(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white, // White border
                    width: 1, // Border thickness
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child:
                      response!.startsWith('http')
                          ? Image.network(response!) // If Response is ImageUrl
                          : Text(
                            response!,
                            style: TextStyle(
                              color: Colors.white,
                            ), // If Response is Text
                          ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
