import 'package:flutter/material.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/state_model.dart';
import 'package:video_player/video_player.dart';

class SplashVideo extends StatefulWidget {

  const SplashVideo({super.key});

  @override
  State createState() => _SplashVideoState();
}

const videoUrl = 'https://storage.googleapis.com/prepared-project.appspot.com/seesaw/seesaw-cover-1min-loop.mp4';

class _SplashVideoState extends State<SplashVideo> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FullScreenWindow.setFullScreen(true);
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GestureDetector(
          onTap: exitCoverMode,
          child: _controller.value.isInitialized ?
            VideoPlayer(_controller)
            :
            const Center(child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator()))
        )
    );
  }

  void exitCoverMode() {
    debugPrint('tapped!');
    _controller.pause();
    final StateModel stateModel = Provider.of<StateModel>(context, listen: false);
    stateModel.progressToNextSeesawState();
  }
}