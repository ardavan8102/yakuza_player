import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

int _selectedIndex = 0;

List<String> _src = [
  'https://static.cdn.asset.aparat.com/avt/62017945_15s.mp4',
  'https://static.cdn.asset.aparat.com/avt/62137266_15s.mp4',
  'https://static.cdn.asset.aparat.com/avt/61986552_15s.mp4',
];

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {

  late VideoPlayerController _controller;

  bool _isReady = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(_src[_selectedIndex]),
    );

    _initVideoPlayer();
  }

  Future<void> _initVideoPlayer() async {
    try {
      await _controller.initialize();

      _controller.setLooping(true);

      await _controller.play();

      setState(() {
        _isReady = true;
      });
    } catch (e) {
      debugPrint('🔴 video init error: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            children: [
              Center(
                child: _isReady
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : const CircularProgressIndicator(),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.only(bottom: 24, top: 10),
                  width: size.width,
                  child: Column(
                    spacing: 20,
                    children: [
                      // controlls
                      Row(
                        crossAxisAlignment: .center,
                        mainAxisAlignment: .center,
                        spacing: 12,
                        children: [
                          // previous
                          ControllerIconButton(
                            function: () {
                      
                              _selectedIndex--;
                      
                              _selectedIndex %= _src.length;
                      
                              onChangeVideo();
                      
                            },
                            icon: Icons.skip_previous,
                            iconColor: Colors.white,
                            iconSize: 45,
                          ),
                      
                          // rewind
                          ControllerIconButton(
                            function: () async {
                      
                              final position = await _controller.position;
                      
                              final targetPosition = position!.inMilliseconds - 10000;
                      
                              await _controller.seekTo(Duration(milliseconds: targetPosition));
                      
                            },
                            icon: Icons.replay_10,
                            iconColor: Colors.white,
                            iconSize: 45,
                          ),
                      
                          // play or puase
                          ControllerIconButton(
                            icon: _controller.value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                            iconColor: Colors.green,
                            function: () async {
                              _controller.value.isPlaying
                                  ? await _controller.pause()
                                  : await _controller.play();
                      
                              setState(() {});
                            },
                            iconSize: 65,
                          ),
                      
                          // forward
                          ControllerIconButton(
                            function: () async {
                      
                              final position = await _controller.position;
                      
                              final targetPosition = position!.inMilliseconds + 10000;
                      
                              await _controller.seekTo(Duration(milliseconds: targetPosition));
                      
                            },
                            icon: Icons.forward_10,
                            iconColor: Colors.white,
                            iconSize: 45,
                          ),
                      
                          // next
                          ControllerIconButton(
                            function: () {
                      
                              _selectedIndex++;
                      
                              _selectedIndex %= _src.length;
                      
                              onChangeVideo();
                      
                            },
                            icon: Icons.skip_next,
                            iconColor: Colors.white,
                            iconSize: 45,
                          ),
                        ],
                      ),
                    
                      // progress bar
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        colors: VideoProgressColors(
                          playedColor: Colors.greenAccent,
                          backgroundColor: Colors.grey
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onChangeVideo(){
    _controller.dispose();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(_src[_selectedIndex])
    );
    
    _controller.addListener(
      () {
        setState(() {
          if (!_controller.value.isPlaying && 
              _controller.value.isInitialized && 
              _controller.value.duration == _controller.value.position
          ) {
            _controller.seekTo(Duration.zero);
          }
        });  
      },
    );

    _controller.initialize().then((value) => setState(() {
      _controller.play();
    }));
  }

}

class ControllerIconButton extends StatelessWidget {
  const ControllerIconButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.function,
    required this.iconSize,
  });

  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: function,
      icon: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}