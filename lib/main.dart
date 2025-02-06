import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quittr/core/bloc_observer.dart';
import 'package:quittr/core/injection_container.dart' as di;
import 'package:quittr/core/presentation/theme/theme.dart';
import 'package:quittr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quittr/features/auth/presentation/screens/auth_wrapper.dart';
import 'package:quittr/features/auth/presentation/screens/signup_screen.dart';
import 'package:quittr/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:quittr/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:quittr/features/settings/presentation/screens/settings_screen.dart';
import 'package:quittr/firebase_options.dart';
import 'package:quittr/core/presentation/theme/cubit/theme_cubit.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository: di.sl())),
        BlocProvider(create: (_) => ThemeCubit(settingsRepository: di.sl())),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          final theme = MaterialTheme(GoogleFonts.poppinsTextTheme());
          return MaterialApp(
            title: 'Quittr',
            debugShowCheckedModeBanner: false,
            theme: theme.light(),
            darkTheme: theme.dark(),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const AuthWrapper(),
            routes: {
              '/signup': (context) => const SignupScreen(),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
              '/edit-profile': (context) => const EditProfileScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
