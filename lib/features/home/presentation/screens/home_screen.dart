import 'package:flutter/material.dart';
import 'package:quittr/features/relapse_tracker/presentation/screens/relapse_tracker_screen.dart';
import 'package:quittr/features/profile/presentation/screens/profile_screen.dart';
import 'package:quittr/features/library/presentation/screens/library_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const RelapseTrackerScreen(),
    const Placeholder(), // Community tab
    const LibraryScreen(), // Library tab
    const ProfileScreen(), // Profile tab
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Tracker',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
