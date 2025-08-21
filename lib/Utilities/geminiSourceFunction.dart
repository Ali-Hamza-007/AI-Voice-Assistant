import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voice_assistant_app/secrets.dart';

class GeminiServices {
  GeminiServices();

  // For Checking Given Prompt Is Text or Image
  Future<String?> checkingRequestForImageOrText({
    required String Prompt,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent',
        ),
        headers: {"Content-Type": "application/json", "X-goog-api-key": apiKey},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "Tell me Is the following statement is asking for an image, art, or picture. Answer me only in Yes or No. The Statement is $Prompt",
                },
              ],
            },
          ],
        }),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(
              res.body,
            )["candidates"][0]["content"]["parts"][0]["text"];
        content = content.trim();

        if (content.toLowerCase().startsWith("yes")) {
          // User wants an image
          return await ImagePrompt(Prompt);
        } else {
          // User wants text
          return await TextPrompt(Prompt);
        }
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }
  // For Text Input

  Future<String?> TextPrompt(String _prompt) async {
    try {
      final res = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent',
        ),
        headers: {"Content-Type": "application/json", "X-goog-api-key": apiKey},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": _prompt},
              ],
            },
          ],
        }),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(
              res.body,
            )["candidates"][0]["content"]["parts"][0]["text"];
        content = content.trim();

        return content;
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // For Image Generation
  Future<String?> ImagePrompt(String _prompt) async {
    try {
      final res = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/imagen-4.0-generate-001:predict',
        ),
        headers: {"Content-Type": "application/json", "X-goog-api-key": apiKey},
        body: jsonEncode({
          'instances': [
            {'prompt': _prompt},
          ],
          "parameters": {"sampleCount": 1},
        }),
      );

      if (res.statusCode == 200) {
        String imgUrl = jsonDecode(res.body)['images'][0]['imageUri'];
        imgUrl = imgUrl.trim();

        return imgUrl;
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
