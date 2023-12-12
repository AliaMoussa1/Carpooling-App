import 'package:carpool/infoHandler/app_info.dart';
import 'package:carpool/screens/forgot_password_screen.dart';
import 'package:carpool/screens/login_screen.dart';
import 'package:carpool/screens/main_screen.dart';
import 'package:carpool/screens/search_places_screen.dart';
import 'package:carpool/screens/signup_screen.dart';
import 'package:carpool/splashScreen/splash_screen.dart';
import 'package:carpool/themeProvider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppInfo(),
        child: MaterialApp(
          title: 'Flutter Demo',
          themeMode: ThemeMode.system,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,

          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ),
    );
  }
}
