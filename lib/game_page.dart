import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tile.dart';
import 'ad_manager.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  int gridSize = 16;
  int redIndex = -1;
  int redIndex2 = -1;
  int gemIndex = -1;
  int score = 0;
  int highscore = 0;
  int gamesPlayed = 0;
  
  // Arcade Stats
  int combo = 0;
  DateTime? lastTapTime;

  Timer? timer;
  Duration currentDuration = const Duration(milliseconds: 900);
  BannerAd? banner;
  bool isBannerLoaded = false;
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  late ConfettiController _confettiController;
  late AnimationController _shakeController;

  final String collectSound = "mixkit-arcade-game-jump-coin-216.wav";
  final String gameOverSound = "mixkit-male-voice-cheer-2010.wav";
  final String highscoreSound = "mixkit-cheering-crowd-loud-whistle-610.wav";

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _shakeController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _loadHighScore();
    startGame();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadAdaptiveBanner());
    AdManager.loadInterstitial();
    AdManager.loadRewarded();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highscore = prefs.getInt('highscore') ?? 0;
    });
  }

  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highscore', highscore);
  }

  void loadAdaptiveBanner() async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) return;

    banner = BannerAd(
      adUnitId: AdManager.bannerId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void startGame() {
    timer?.cancel();
    currentDuration = getDuration();
    timer = Timer.periodic(
      currentDuration,
      (timer) {
        updatePositions();
        updateTimerIfNeeded();
      },
    );
  }

  void updatePositions() {
    setState(() {
      redIndex = Random().nextInt(gridSize);
      if (score > 20) {
        redIndex2 = Random().nextInt(gridSize);
        while (redIndex2 == redIndex) {
          redIndex2 = Random().nextInt(gridSize);
        }
      } else {
        redIndex2 = -1;
      }
      gemIndex = Random().nextInt(gridSize);
      while (gemIndex == redIndex || gemIndex == redIndex2) {
        gemIndex = Random().nextInt(gridSize);
      }
    });
  }

  Duration getDuration() {
    int speed = max(250, 900 - (score * 15)); 
    return Duration(milliseconds: speed);
  }

  void updateTimerIfNeeded() {
    Duration newDuration = getDuration();
    if (newDuration.inMilliseconds != currentDuration.inMilliseconds) {
      currentDuration = newDuration;
      timer?.cancel();
      timer = Timer.periodic(currentDuration, (t) {
        updatePositions();
        updateTimerIfNeeded();
      });
    }
  }

  void _playSound(String assetName) async {
    try {
      await _audioPlayer.play(AssetSource('sounds/$assetName'));
    } catch (e) {
      debugPrint("Audio play error: $e");
    }
  }

  void tapTile(int index) {
    if (index == redIndex || index == redIndex2) {
      _shakeController.forward(from: 0);
      HapticFeedback.heavyImpact();
      _playSound(gameOverSound);
      gameOver();
    } else if (index == gemIndex) {
      HapticFeedback.lightImpact();
      _playSound(collectSound);
      
      // Combo Logic
      DateTime now = DateTime.now();
      if (lastTapTime != null && now.difference(lastTapTime!).inMilliseconds < 1000) {
        combo++;
      } else {
        combo = 1;
      }
      lastTapTime = now;

      setState(() {
        score += 1 * (combo > 5 ? 2 : 1); // 2x Points for combo > 5
        if (score > highscore) {
          if (score == highscore + 1 && score > 5) {
            _confettiController.play();
            _playSound(highscoreSound);
          }
          highscore = score;
          _saveHighScore();
        }
        gemIndex = -1; 
      });
    }
  }

  void gameOver() {
    timer?.cancel();
    gamesPlayed++;
    if (gamesPlayed % 3 == 0) AdManager.showInterstitial();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), 
            side: const BorderSide(color: Colors.redAccent),
          ),
          title: const Text("GAME OVER", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Score: $score", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Text("Highscore: $highscore", style: const TextStyle(color: Colors.white70)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () { Navigator.pop(context); restart(); },
              child: const Text("RETRY", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent)),
            ),
          ],
        );
      },
    );
  }

  void restart() {
    setState(() { score = 0; combo = 0; redIndex = -1; redIndex2 = -1; gemIndex = -1; });
    startGame();
  }

  @override
  void dispose() {
    timer?.cancel();
    _shakeController.dispose();
    _audioPlayer.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "GEMS HUNTER",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 2),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth > 600 ? 500 : constraints.maxWidth;
            
            return Center(
              child: SizedBox(
                width: maxWidth,
                child: AnimatedBuilder(
                  animation: _shakeController,
                  builder: (context, child) {
                    double dx = sin(_shakeController.value * 20 * pi) * 10 * (1 - _shakeController.value);
                    return Transform.translate(offset: Offset(dx, 0), child: child);
                  },
                  child: Column(
                    children: [
                      // Arcade Stats Dashboard
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildArcadeStat("SCORE", score.toString(), const Color(0xFF00FF88)),
                            _buildComboBadge(),
                            _buildArcadeStat("BEST", highscore.toString(), Colors.orangeAccent),
                          ],
                        ),
                      ),

                      // Difficulty Neon Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              value: getDifficultyPercent(),
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.lerp(const Color(0xFF00FF88), const Color(0xFFFF2D55), getDifficultyPercent())!,
                              ),
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            const SizedBox(height: 5),
                            const Text("SYSTEM LOAD SPEED", style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 1.5)),
                          ],
                        ),
                      ),

                      // Game Grid
                      Expanded(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1.0, 
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                                itemCount: gridSize,
                                itemBuilder: (context, index) {
                                  TileType type = TileType.empty;
                                  if (index == redIndex || index == redIndex2) {
                                    type = TileType.red;
                                  } else if (index == gemIndex) {
                                    type = TileType.gem;
                                  }
                                  return Tile(type: type, onTap: () => tapTile(index));
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      if (banner != null && isBannerLoaded)
                        Container(
                          alignment: Alignment.center,
                          width: banner!.size.width.toDouble(),
                          height: banner!.size.height.toDouble(),
                          child: AdWidget(ad: banner!),
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildArcadeStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white38, letterSpacing: 1)),
        Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color, shadows: [Shadow(color: color, blurRadius: 10)])),
      ],
    );
  }

  Widget _buildComboBadge() {
    return AnimatedScale(
      scale: combo > 1 ? 1.2 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Column(
        children: [
          const Text("COMBO", style: TextStyle(fontSize: 10, color: Colors.white38)),
          Text("x$combo", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
        ],
      ),
    );
  }

  double getDifficultyPercent() {
    return ((900 - getDuration().inMilliseconds.toDouble()) / (900 - 250)).clamp(0.0, 1.0);
  }
}
