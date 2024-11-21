import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_new_project/bloc/event_cubit.dart';
import 'package:new_new_project/screens/event_list_page.dart';
import 'package:new_new_project/services/event_database.dart';
import 'login and signup screens/password.dart';
import 'login and signup screens/sign_in_page.dart';
import 'login and signup screens/sign_up.dart';
import 'screens/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false; // State for dark mode
  bool _areNotificationsEnabled = true; // State for notifications

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark; // Update dark mode state
    });
  }

  void _toggleNotifications(bool isEnabled) {
    setState(() {
      _areNotificationsEnabled = isEnabled; // Update notifications state
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EventCubit(EventDatabase.instance)..loadEvents(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Event Countdown App',
        theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(), // Apply theme
        home: SignInPage(), // Set the sign-in page as the initial page
        routes: {
          '/eventList': (context) => EventListPage(),
          '/signup': (context) => SignUp(),
          '/password': (context) => Password(),
          '/settings': (context) => SettingsPage(
            isDarkMode: _isDarkMode,
            areNotificationsEnabled: _areNotificationsEnabled,
            onThemeChanged: _toggleTheme,
            onLanguageChanged: (locale) {},
            onNotificationsChanged: _toggleNotifications,
            onLogout: () {},
          ),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) => SignInPage()); // Handle unknown routes
        },
      ),
    );
  }
}
