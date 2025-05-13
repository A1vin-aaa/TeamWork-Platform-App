import 'package:challenge1_group3/firebase_options.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/provider/user_provider.dart';
import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/ui/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BoardProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        theme: ThemeData(
          scaffoldBackgroundColor: CustomTheme.white,
          primaryColor: CustomTheme.accentColor,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: CustomTheme.accentColor,
            foregroundColor: CustomTheme.white,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: CustomTheme.accentColor,
            primary: CustomTheme.accentColor,
            surface: CustomTheme.white,
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        navigatorKey: navKey,
      ),
    );
  }
}

GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
