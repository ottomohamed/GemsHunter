import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int highscore = 0;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highscore = prefs.getInt('highscore') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double contentWidth = constraints.maxWidth > 500 ? 500 : constraints.maxWidth;
            
            return Center(
              child: SingleChildScrollView(
                child: Container(
                  width: contentWidth,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.greenAccent.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.greenAccent.withOpacity(0.2),
                              blurRadius: 40,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.diamond,
                          size: 100,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        "GEMS HUNTER",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4.0,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: Colors.greenAccent, blurRadius: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "BEST SCORE: $highscore",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      SizedBox(
                        width: double.infinity,
                        height: 65,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const GamePage()),
                            ).then((_) => _loadHighScore());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor: Colors.greenAccent.withOpacity(0.5),
                          ),
                          child: const Text(
                            "START MISSION",
                            style: TextStyle(
                              fontSize: 22, 
                              fontWeight: FontWeight.w900, // Fixed: Changed from black to w900
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "v 1.0.0",
                        style: TextStyle(color: Colors.white24, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
=======
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.diamond,
              size: 100,
              color: Colors.greenAccent,
            ),
            const SizedBox(height: 20),
            const Text(
              "GEMS HUNTER",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Best Score: $highscore",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GamePage()),
                ).then((_) => _loadHighScore()); // Refresh highscore when coming back
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: const Text(
                "START GAME",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
>>>>>>> 0b27c079cf8b9a58e434594887fafe3da769a182
        ),
      ),
    );
  }
}
