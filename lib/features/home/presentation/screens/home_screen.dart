import 'package:flutter/material.dart';
import 'package:quittr/core/pref%20utils/pref_utils.dart';
import 'package:quittr/features/pledge/data/data%20sources/local_notification_datasource.dart';
import 'package:quittr/features/relapse_tracker/presentation/screens/relapse_tracker_screen.dart';
import 'package:quittr/features/profile/presentation/screens/profile_screen.dart';
import 'package:quittr/features/library/presentation/screens/library_screen.dart';
import 'package:quittr/core/injection_container.dart' as di;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const RelapseTrackerScreen(),
    const LibraryScreen(), // Library tab
    const ProfileScreen(), // Profile tab
  ];

  @override
  void initState() {
    if (PrefUtils().getRelapsedDates().isNotEmpty) {
      // Check for notification launch after app is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final localNotificationDataSource =
            di.sl<LocalNotificationDataSourceImpl>();
        localNotificationDataSource
            .checkForNotifications(); // Check for notifications
        LocalNotificationDataSourceImpl.showNotificationDialog(
            null); // Show dialog on app start
      });
    }

    super.initState();
  }

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
