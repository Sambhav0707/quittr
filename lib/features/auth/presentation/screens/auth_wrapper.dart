import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quittr/features/home/presentation/screens/home_screen.dart';
import 'package:quittr/features/onboarding/presentation/screens/quiz/get_started_screen.dart';
import 'package:quittr/features/paywall/presentation/bloc/paywall_bloc.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<PaywallBloc, PaywallState>(
          builder: (context, paywallState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              if (paywallState.hasValidSubscription) {
                return const HomeScreen();
              } else {
                return const HomeScreen();
              }
            }
            return const GetStartedScreen();
          },
        );
      }),
    );
  }
}
