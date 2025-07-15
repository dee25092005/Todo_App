// lib/my_app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoo_app/providers/theme_provider.dart';
import 'package:todoo_app/screens/dashboard_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(
      themeProvider,
    ); // Watches the current theme mode

    return MaterialApp(
      title: 'To-do app',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode, // Applies the current theme mode
      // --- Light Theme Definition ---
      theme: ThemeData(
        fontFamily: 'NotoSansLao',
        primarySwatch: Colors.blueGrey,
        primaryColor: const Color(0xFF7B4019), // Dark Brown
        colorScheme:
            ColorScheme.fromSwatch(
              primarySwatch: Colors.orange,
              backgroundColor: const Color(0xFFFFF3E0), // Light background
            ).copyWith(
              primary: const Color(0xFF7B4019),
              secondary: const Color(0xFFFFBF78),

              error: Colors.redAccent,

              surface: const Color(0xFF7B4019), // Default card surface color
              onSurface: Colors.black87, // Text color on surfaces
              onSurfaceVariant:
                  Colors.grey[500], // Slightly lighter grey for secondary text
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7B4019), // AppBar in light mode
          foregroundColor: Color(0xFFFFEEA9),
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 205, 116, 57),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          color: Colors.white, // Explicit card color for light mode
        ),
        textTheme: TextTheme(
          titleLarge: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          titleMedium: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          bodyMedium: const TextStyle(fontSize: 16, color: Colors.black87),
          bodySmall: TextStyle(
            fontSize: 14,
            color: Colors
                .grey[700], // Slightly darker grey for better light mode contrast
          ),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 252, 246),
        useMaterial3: true,
      ),

      // --- Dark Theme Definition (Focus on these colors) ---
      darkTheme: ThemeData(
        fontFamily: 'NotoSansLao',
        brightness: Brightness.dark, // Essential for Material3 dark theme
        primarySwatch: Colors.blueGrey,
        primaryColor: const Color(
          0xFF4E342E,
        ), // A slightly lighter brown for dark mode primary
        colorScheme:
            ColorScheme.fromSwatch(
              primarySwatch: Colors.orange,
              backgroundColor: const Color(
                0xFF1E1E1E,
              ), // Deeper dark background
              brightness: Brightness.dark,
            ).copyWith(
              primary: Colors.blueGrey,
              secondary: Colors.blueGrey, // Lighter green for dark mode accent
              error: Colors.redAccent,
              surface: const Color(
                0xFF2C2C2C,
              ), // Darker surface for cards/sheets/BottomAppBar
              onSurface: Colors.white, // Text color on dark surfaces
              onSurfaceVariant: Colors
                  .grey[400], // Lighter grey for secondary text on dark surfaces
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C2C2C), // AppBar background in dark mode
          foregroundColor: Color(
            0xFFFFF8E1,
          ), // Lighter text/icons for dark AppBar
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 108, 68, 41),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          color: const Color(
            0xFF333333,
          ), // Darker card background for dark mode
        ),
        textTheme: TextTheme(
          titleLarge: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleMedium: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyMedium: const TextStyle(fontSize: 16, color: Colors.white),
          bodySmall: TextStyle(
            fontSize: 14,
            color:
                Colors.grey[400], // Lighter grey for better dark mode contrast
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
