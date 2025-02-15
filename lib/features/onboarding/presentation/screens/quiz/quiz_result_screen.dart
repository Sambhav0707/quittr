import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'check_symptoms_screen.dart';

class QuizResultScreen extends StatefulWidget {
  final Map userInfo;

  const QuizResultScreen({
    super.key,
    required this.userInfo,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(begin: 0, end: 52).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Analysis Complete',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "We've got some news to break to you...",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Your responses indicate a clear\ndependance on internet porn*',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildScoreBar(
                    label: 'Your Score',
                    score: _scoreAnimation,
                    color: Color(0xFFE57373),
                  ),
                  const SizedBox(width: 24),
                  _buildScoreBar(
                    label: 'Average',
                    score: const AlwaysStoppedAnimation(13),
                    color: Color(0xFF81C784),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '39%',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Color(0xFFE57373),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' higher dependence on porn',
                    style: GoogleFonts.poppins(fontSize: 20),
                  ),
                  Icon(Icons.arrow_upward, color: Color(0xFFE57373)),
                ],
              ),
              const Spacer(),
              Text(
                '* This result is an indication only, not a medical diagnosis. For a definitive assessment, please contact your healthcare provider.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CheckSymptomsScreen(userInfo: widget.userInfo),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  // backgroundColor: Color(0xFF2196F3),
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Check your symptoms',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBar({
    required String label,
    required Animation<double> score,
    required Color color,
  }) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: score,
          builder: (context, child) {
            return Container(
              width: 40,
              height: 200,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    height: score.value / 100 * 200,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
