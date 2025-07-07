import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:made_for_iram/utils/message_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  String partnerName = '';
  String yourName = '';
  String dailyMessage = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _loadData();
    _initMusic();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      partnerName = prefs.getString('partnerName') ?? 'My Love';
      yourName = prefs.getString('yourName') ?? 'Me';
      dailyMessage = MessageUtils.getDailyMessage(partnerName);
      isLoading = false;
    });
  }

  Future<void> _initMusic() async {
    await audioPlayer.setSourceAsset('assets/music/romantic.mp3');
    await audioPlayer.setVolume(0.5);
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> toggleMusic() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Lottie.asset(
                'assets/animations/heart_animation.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Made for $partnerName',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Switch(
                        value: isPlaying,
                        onChanged: (value) => toggleMusic(),
                        activeColor: Colors.pink,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GlassCard(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Hello $yourName',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Here\'s your daily love message:',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            AnimatedMessageCard(message: dailyMessage),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedMessageCard extends StatefulWidget {
  final String message;

  const AnimatedMessageCard({super.key, required this.message});

  @override
  State<AnimatedMessageCard> createState() => _AnimatedMessageCardState();
}

class _AnimatedMessageCardState extends State<AnimatedMessageCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  widget.message,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
