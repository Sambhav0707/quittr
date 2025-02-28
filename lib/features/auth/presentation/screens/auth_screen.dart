import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quittr/features/paywall/presentation/bloc/paywall_bloc.dart';
import '../bloc/auth_bloc.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PaywallBloc, PaywallState>(
        builder: (context, paywallState) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
              if (state is AuthLoggedIn) {
                _onLoggedIn(context, state, paywallState);
              }
            },
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset(
                    'assets/illustrations/get_started_screen.svg',
                    width: MediaQuery.sizeOf(context).width * 1,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.primary.withAlpha(12),
                        Theme.of(context).colorScheme.surface,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                const Spacer(),
                                // Hero Image
                                Hero(
                                  tag: 'app_logo',
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withAlpha(76),
                                          blurRadius: 24,
                                          offset: const Offset(0, 12),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.healing_rounded,
                                      size: 48,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                // Welcome Text
                                Text(
                                  'Welcome to BreakFree',
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Start your journey to a healthier life',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const Spacer(),
                                // Social Auth Buttons
                                _buildAuthButton(
                                  context,
                                  'Continue with Apple',
                                  null,
                                  () => _onAppleSignInPressed(context),
                                  icon: Icons.apple,
                                  isOutlined: true,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  iconColor: Colors.white,
                                ),
                                const SizedBox(height: 16),
                                _buildAuthButton(
                                  context,
                                  'Continue with Google',
                                  'assets/illustrations/google_logo.svg',
                                  () => _onGoogleSignInPressed(context),
                                  isOutlined: true,
                                ),
                                const SizedBox(height: 16),
                                _buildAuthButton(
                                  context,
                                  'Sign in with Email',
                                  null,
                                  () => Navigator.pushNamed(
                                      context, '/email-auth'),
                                  icon: Icons.email_outlined,
                                ),
                                const SizedBox(height: 24),
                                // If user has a subscription, don't show the skip option. User will login and go to home screen.
                                if (!paywallState.hasValidSubscription)
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Divider(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline)),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Text(
                                              'or',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Divider(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline)),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      TextButton(
                                        onPressed: () => _startQuiz(context),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Skip for now',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  )
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
        },
      ),
    );
  }

  void _onLoggedIn(
      BuildContext context, AuthLoggedIn authState, PaywallState paywallState) {
    // If user is new, show quiz questions screen, else if user has
    // a subscription, show home screen, else show paywall screen.
    if (authState.user.isNewUser) {
      // _startQuiz(context);
      Navigator.pushNamed(context, '/home');
    } else if (paywallState.hasValidSubscription) {
      Navigator.pushNamed(context, '/home');
    } else {
      Navigator.pushNamed(context, '/paywall');
    }
  }

  void _onGoogleSignInPressed(BuildContext context) {
    context.read<AuthBloc>().add(SignInWithGoogle());
  }

  void _onAppleSignInPressed(BuildContext context) {
    context.read<AuthBloc>().add(SignInWithApple());
  }

  void _startQuiz(BuildContext context) {
    Navigator.pushNamed(context, '/onboarding-quiz');
  }

  Widget _buildAuthButton(
    BuildContext context,
    String text,
    String? svgAsset,
    VoidCallback onPressed, {
    IconData? icon,
    bool isOutlined = false,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);

    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor ??
            (isOutlined
                ? theme.colorScheme.surface
                : theme.colorScheme.primary),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: isOutlined && backgroundColor == null
                  ? Border.all(color: theme.colorScheme.outline)
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (svgAsset != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SvgPicture.asset(svgAsset, height: 24),
                  )
                else if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      icon,
                      color: iconColor ??
                          (isOutlined
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onPrimary),
                    ),
                  ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor ??
                        (isOutlined
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
