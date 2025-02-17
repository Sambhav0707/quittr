import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/features/meditate/domain/entities/qoutes.dart';
import 'package:quittr/features/meditate/presentation/bloc/qoutes_bloc.dart';
import 'package:rive/rive.dart';

class MeditateScreen extends StatefulWidget {
  const MeditateScreen({super.key});

  @override
  State<MeditateScreen> createState() => _MeditateScreenState();
}

class _MeditateScreenState extends State<MeditateScreen> {
  int currentQuoteIndex = 0;
  Timer? _timer;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    // Fetch quotes when screen loads
    context.read<QoutesBloc>().add(QoutesGetEvent());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startQuoteTimer(List<Qoutes> quotes) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _opacity = 0.0; // Start fade out
      });

      Future.delayed(const Duration(milliseconds: 1200), () {
        setState(() {
          currentQuoteIndex = (currentQuoteIndex + 1) % quotes.length;
          _opacity = 1.0; // Start fade in
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocConsumer<QoutesBloc, QoutesState>(
        listener: (context, state) {
          if (state is QoutesSuccess) {
            _startQuoteTimer(state.qoutes);
          }
        },
        builder: (context, state) {
          if (state is QoutesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is QoutesSuccess) {
            return Stack(children: [
              Positioned.fill(
                child: RiveAnimation.asset(
                  'assets/animations/sky_moon_night.riv',
                  fit: BoxFit.cover, // Ensure it covers the background
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Reflect and breathe",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            AnimatedOpacity(
                              opacity: _opacity,
                              duration: const Duration(seconds: 2),
                              child: Text(
                                state.qoutes[currentQuoteIndex].text,
                                style: const TextStyle(
                                    fontSize: 18,
                                    height: 1.5,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Finish Reflecting")),
                      ),
                    )
                  ],
                ),
              ),
              RiveAnimation.asset('assets/animation/sky_moon_night.riv'),
            ]);
          }
          if (state is QoutesFailure) {
            return Center(child: Text(state.message));
          }

          return Center(
            child: Text("no qoutes"),
          );
        },
      )),
    );
  }
}
