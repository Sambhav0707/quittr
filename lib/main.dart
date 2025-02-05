import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/core/bloc_observer.dart';
import 'package:quittr/core/injection_container.dart' as di;
import 'package:quittr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quittr/features/auth/presentation/screens/auth_wrapper.dart';
import 'package:quittr/features/auth/presentation/screens/signup_screen.dart';
import 'package:quittr/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:quittr/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize dependency injection
  await di.init();

  // Set up BlocObserver
  Bloc.observer = AppBlocObserver();

  runApp(const QuittrApp());
}

class QuittrApp extends StatelessWidget {
  const QuittrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(authRepository: di.sl()),
      child: MaterialApp(
        title: 'Quittr',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        routes: {
          '/signup': (context) => const SignupScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
        },
      ),
    );
  }
}
