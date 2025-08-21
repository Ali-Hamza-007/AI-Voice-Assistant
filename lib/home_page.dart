import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:voice_assistant_app/Utilities/geminiSourceFunction.dart';
import 'UI/responseUI.dart';
import 'UI/homePageUI.dart';

enum TtsState { playing, stopped }

TtsState ttsState = TtsState.stopped;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // -------------------- Stuff Related to (Text to Speech) & (Speech To Text0 ---------------------

  bool isClicked = false;
  // Text to Speech
  final flutterTts = FlutterTts();

  // Open AI Service
  final _openAIService = GeminiServices();
  // For User Input
  String prompt = '';
  //
  bool speechEnabled = false;
  bool isHaveContent = false;
  bool isHaveImageContent = false;
  // Speech To Text ( Part Speech To Text Class)
  final _speechToText = SpeechToText();
  // Containing Words that user input by Voice ( Part Speech To Text Class)
  String _lastWords = '';
  // Key used for Drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Final Response To Display to user
  String? response;

  // This has to happen only once per app For Speech To Text ( Part Speech To Text Class)
  Future<void> _initSpeech() async {
    speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  // Each time to start a speech recognition session ( Part Speech To Text Class)
  Future<void> _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  // To stop Speech Listening session ( Part Speech To Text Class)
  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  // Function That Containing Finally user Speech Input ( Part Speech To Text Class)
  void _onSpeechResult(SpeechRecognitionResult result) async {
    // Only take final result (when user stops speaking)
    if (result.finalResult) {
      setState(() {
        _lastWords = result.recognizedWords;
        prompt = _lastWords;
      });

      // Stop listening immediately
      await _speechToText.stop();

      // Show "Thinking..." while waiting
      setState(() {
        response = "Thinking...";
      });

      // Get Response
      final res = await _openAIService.checkingRequestForImageOrText(
        Prompt: prompt,
      );

      setState(() {
        response = res;
      });

      // Speak automatically
      if (response != null && response!.isNotEmpty) {
        _speak(response!);
      }
    }
  }

  // For Speak Response ( Part Text To Speech Class )
  Future _speak(String response) async {
    await flutterTts.stop(); // ensure no overlap
    var result = await flutterTts.speak(response);
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  // For Stop Speaking Response ( Part Text To Speech Class )
  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  // ---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _initSpeech();

    // When TTS finishes speaking
    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
        // Example: Reset to listening mode or clear UI
      });
      // print("Speech finished");
    });

    // When TTS is stopped/cancelled manually
    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
      // print("Speech cancelled");
    });
  }

  @override
  void dispose() {
    flutterTts.stop(); // stop speech on exit
    _speechToText.stop(); // stop listening too
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey, // Used for Drawer
        backgroundColor: const Color(0xFF201C46),
        bottomNavigationBar:
            response == null
                ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Developed by HAMZA </>',
                    style: TextStyle(color: Color.fromARGB(255, 138, 130, 171)),
                  ),
                )
                : null,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Allen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading:
              response == null
                  ? IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  )
                  : !isClicked
                  ? InkWell(
                    onTap: () {
                      _stop();
                      setState(() {
                        isClicked = !isClicked;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 10),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.stop_circle_outlined,
                            color: Colors.red,
                            size: 28,
                          ),

                          Text(
                            "Stop",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  )
                  : IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        response = null;
                        isClicked = !isClicked;
                      });
                    },
                  ),
        ),

        drawer: Drawer(
          // Drawer
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          backgroundColor: const Color.fromARGB(255, 31, 27, 71),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset('assets/Icons/chatbot.png', height: 50),
                    SizedBox(width: 12),
                    const Text(
                      'Allen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white, // White border
                      width: 1, // Border thickness
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Meet Allen – Your Personal AI Voice Assistant 🤖🎙️ ',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const Text(
                        'Allen is a smart, interactive, and friendly voice companion designed to make your daily life easier and more fun. ',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                const Text(
                  'More About.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Image.asset('assets/chrome.png'),
                  ),
                  title: Text(
                    'Allen AI Voice Assistant',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Image.asset('assets/firefox.png'),
                  ),

                  title: Text(
                    'Allen AI Voice Assistant',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Image.asset('assets/facebook.png'),
                  ),

                  title: Text(
                    'Allen AI Voice Assistant',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                Spacer(),

                const Text(
                  '© CopyRight 2025, All Rights Reserved.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          // Body of HomePage
          padding: const EdgeInsets.all(15),
          child:
              (response == null && isClicked == false)
                  ? HomePageUI()
                  : responseUI(res: response),
        ),

        floatingActionButton:
            response == null
                ? Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                    backgroundColor: const Color.fromRGBO(57, 57, 106, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onPressed: () {
                      _speechToText.isNotListening
                          ? _startListening()
                          : _stopListening();
                    },
                    child: Icon(
                      _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                )
                : null,
      ),
    );
  }
}

class MakeChip extends StatelessWidget {
  final String title;
  const MakeChip({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Chip(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      label: Text(
        title,
        style: const TextStyle(color: Colors.grey),
      ), // changed text color to white
      backgroundColor: const Color(0xFF201C46),
    );
  }
}
