import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


int _selectedIndexVideo = 1;

List<String> _src = [
  'https://persian21.cdn.asset.aparat.com/aparat-video/58001a1926912f4b175a5ab1e9e32b9867004084-240p.mp4?wmsAuthSign=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6IjZjNzI3NjJiMmQ1ZTM1ODUyMjE0NWE0MTQ5NjVjODVjIiwiZXhwIjoxNzY1OTM0NzE1LCJpc3MiOiJTYWJhIElkZWEgR1NJRyJ9.vA3cCPTO-YMugAzcCuYm10PegtSUu6GHFlsLFvzfx_Y',
  'https://aspb32.cdn.asset.aparat.com/aparat-video/ca96fb1a37d33cdfdb4cd26193bf48a239375382-360p.mp4?wmsAuthSign=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6Ijc0M2ZjYmY4OTgwZWVhNzgwMTMxOWVhOGFiZTZiZWU1IiwiZXhwIjoxNzY1OTM0Nzc1LCJpc3MiOiJTYWJhIElkZWEgR1NJRyJ9.bwyPiAnZpE6E1S7aBjl6_dO8fHcDl_xpxxg92waZsuY',
];

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(_src[_selectedIndexVideo]));

    _controller.initialize().then((value) {
      setState(() {});
    });

    _controller.play();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            alignment: .center,
            children: [
              Positioned(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller)
                ),
              ),
          
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.green.withValues(alpha: .2),
                  height: 100,
                  width: size.width,
                  child: Center(child: Text('Controllers')),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}