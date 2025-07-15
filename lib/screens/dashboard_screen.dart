// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:todoo_app/screens/add_edit_task_screen.dart';
import 'package:todoo_app/screens/home_screen.dart';
import 'package:todoo_app/screens/history_screen.dart';
import 'package:todoo_app/screens/restore_screen.dart';
import 'package:todoo_app/screens/stats_screen.dart';
import 'package:todoo_app/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  static const List<Widget> _widgetOption = <Widget>[
    HomeScreen(),
    HistoryScreen(),
    RestoreScreen(),
    StatsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'To-Do by Dee';
      case 1:
        return 'History';
      case 2:
        return 'Restore Tasks';
      case 3:
        return 'Stats';
      default:
        return 'App';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This part is correct because _DashboardScreenState extends ConsumerState
    final themeNotifier = ref.read(themeProvider.notifier);
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              themeNotifier.toggleTheme();
            },
          ),
        ],
        // No need for backgroundColor or foregroundColor here if AppBarTheme is set in ThemeData
        // elevation: 0.5, // You can control elevation from AppBarTheme in ThemeData
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _widgetOption,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditTaskScreen()),
          );
        },
        // Using theme colors directly as defined in FloatingActionButtonThemeData
        // backgroundColor: Theme.of(context).colorScheme.primary,
        // foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
        ), // Icon color automatically from foregroundColor
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(
          context,
        ).colorScheme.surface, // Use theme's surface color
        notchMargin: 8.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ), // Adjust padding for better spacing
        elevation: 8.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: _selectedIndex == 0
                      ? 32
                      : 28, // Slightly adjusted sizes
                ),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.history,
                  color: _selectedIndex == 1
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: _selectedIndex == 1 ? 32 : 28,
                ),
                onPressed: () => _onItemTapped(1),
              ),
              const SizedBox(width: 48.0), // Space for FAB
              IconButton(
                icon: Icon(
                  Icons.restore_from_trash, // Icon for Restore Tasks
                  color: _selectedIndex == 2
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: _selectedIndex == 2 ? 32 : 28,
                ),
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: Icon(
                  Icons.bar_chart, // Icon for Stats
                  color: _selectedIndex == 3
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: _selectedIndex == 3 ? 32 : 28,
                ),
                onPressed: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
