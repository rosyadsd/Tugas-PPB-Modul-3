import 'package:flutter/material.dart';
import 'package:mod3_kel28/Profile.dart';
import 'package:mod3_kel28/navigation.dart';
import 'detail.dart';
import 'home.dart';
import 'Splash.dart';

void main() async {
  runApp(const AnimeApp());
}

class AnimeApp extends StatelessWidget {
  const AnimeApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime app',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/nav': (context) => const Navigation(),
        '/home': (context) => const HomePage(),
        '/detail': (context) => const DetailPage(item: 0, title: ''),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
