import 'package:fitness_app/history_screen.dart';
import 'package:fitness_app/home_screen.dart';
import 'package:fitness_app/library_screen.dart';
import 'package:fitness_app/profile_screen.dart';
import 'package:fitness_app/progress_screen.dart';
import 'package:flutter/material.dart';

const _barColor = Color(0xFF0b0d0f);
const _selectedColor = Colors.indigoAccent;
const _unselectedColor = Colors.grey;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  final List<Widget> screensList = const [
    HomeScreen(),
    LibraryScreen(),
    HistoryScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? _selectedColor
                  : _unselectedColor,
            ),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: states.contains(WidgetState.selected)
                  ? _selectedColor
                  : _unselectedColor,
            ),
          ),
        ),
        child: NavigationBar(
          backgroundColor: _barColor,
          surfaceTintColor: Colors.transparent,
          indicatorColor: _selectedColor.withAlpha(46),
          selectedIndex: pageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              pageIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.sports_gymnastics_outlined),
              selectedIcon: Icon(Icons.sports_gymnastics_rounded),
              label: "Library",
            ),
            NavigationDestination(
              icon: Icon(Icons.watch_later_outlined),
              selectedIcon: Icon(Icons.watch_later_rounded),
              label: "History",
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_graph_outlined),
              selectedIcon: Icon(Icons.auto_graph_rounded),
              label: "Progress",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_2_outlined),
              selectedIcon: Icon(Icons.person_2_rounded),
              label: "Profile",
            ),
          ],
        ),
      ),
      body: screensList[pageIndex],
    );
  }
}
