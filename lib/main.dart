// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/user_provider.dart';
import 'provider/board_provider.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/account_page.dart';
import 'ui/pages/board_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BoardProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        // Start at HomePage
        initialRoute: '/',

        // Define your app’s routes
        routes: {
          '/': (_) => const HomePage(),
          '/account': (_) => const AccountPage(),
        },

        // For routes that need arguments (boardId), use onGenerateRoute
        onGenerateRoute: (settings) {
          if (settings.name == '/board') {
            final String boardId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => BoardPage(boardId: boardId),
            );
          }
          // Fallback for unknown routes
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Page not found')),
            ),
          );
        },
      ),
    );
  }
}
