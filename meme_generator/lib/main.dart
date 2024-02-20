import 'package:flutter/material.dart';

import 'package:meme_generator/screens/custom_paint_demotivator_screen.dart';
import 'package:meme_generator/screens/livsey_meme_screen.dart';
import 'package:meme_generator/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

/// App,s main widget.
class MyApp extends StatelessWidget {
  /// Constructor for [MyApp].
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
        routes: {
          '/main_page': (context) => const MainPage(),
          '/demotivator_page': (context) => const CustomPainterWidget(),
          '/livsey_page': (context) => const LivseyScreen(),
        }
    );
  }
}
