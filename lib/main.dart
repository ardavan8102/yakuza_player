import 'package:flutter/material.dart';
import 'package:yakuza_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yakuza player',
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: VideoPlayerPage(),
    );
  }
}