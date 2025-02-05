import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/core/injection_container.dart';
import 'package:quittr/features/auth/domain/repositories/auth_repository.dart';
import 'package:quittr/features/profile/domain/repositories/profile_repository.dart';
import '../bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        profileRepository: sl<ProfileRepository>(),
        authRepository: sl<AuthRepository>(),
      )..add(LoadProfile()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null) {
              return Center(child: Text(state.errorMessage!));
            }

            final profile = state.profile;
            if (profile == null) {
              return const Center(child: Text('No profile data'));
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text('Profile'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/settings'),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                backgroundImage: profile.photoUrl != null
                                    ? NetworkImage(profile.photoUrl!)
                                    : null,
                                child: profile.photoUrl == null
                                    ? Text(
                                        profile.displayName?[0].toUpperCase() ??
                                            '?',
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt),
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  onPressed: () {
                                    // TODO: Implement photo upload
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          profile.displayName ?? 'Anonymous',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          profile.email ?? '',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    elevation: 0,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      children: [
                        _ProfileMenuItem(
                          icon: Icons.edit_outlined,
                          title: 'Edit Profile',
                          onTap: () =>
                              Navigator.pushNamed(context, '/edit-profile'),
                        ),
                        Divider(
                          height: 1,
                          indent: 56,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        _ProfileMenuItem(
                          icon: Icons.settings_outlined,
                          title: 'Settings',
                          onTap: () =>
                              Navigator.pushNamed(context, '/settings'),
                        ),
                        Divider(
                          height: 1,
                          indent: 56,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        _ProfileMenuItem(
                          icon: Icons.logout_outlined,
                          title: 'Sign Out',
                          textColor: Theme.of(context).colorScheme.error,
                          iconColor: Theme.of(context).colorScheme.error,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Sign Out'),
                                content: const Text(
                                  'Are you sure you want to sign out?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<ProfileBloc>()
                                          .add(SignOut());
                                      Navigator.pop(dialogContext);
                                    },
                                    child: Text(
                                      'Sign Out',
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color:
                  iconColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: textColor ?? Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
