import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quittr/features/home/presentation/screens/home_screen.dart';
import 'package:quittr/features/paywall/presentation/screens/paywall_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.user != null) {
            return const HomeScreen();
          }
          return const PaywallScreen(userInfo: {});
        },
      ),
    );
  }
}
