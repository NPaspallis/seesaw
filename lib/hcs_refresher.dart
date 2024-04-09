import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/state_model.dart';
import 'package:video_player/video_player.dart';

import 'package:http/http.dart' as http;

class HcsRefresher extends StatefulWidget {
  const HcsRefresher({super.key});

  @override
  State createState() => _HcsRefresherState();
}

const videoUrl =
    'https://storage.googleapis.com/prepared-project.appspot.com/stories/human_challenge_studies/videos/hcs_video.mp4';
const subtitlesUrl =
    'https://storage.googleapis.com/prepared-project.appspot.com/stories/human_challenge_studies/videos/hcs_video.srt';

class _HcsRefresherState extends State<HcsRefresher> {
  late VideoPlayerController _controller;

  Future<ClosedCaptionFile> _loadCaptionsFromUrl(String url) async {
    try {
      final Response data = await http.get(Uri.http(url));
      final srtContent = data.toString();
      return SubRipCaptionFile(srtContent);
    } catch (e) {
      debugPrint('Failed to get subtitles for url: $url');
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      // closedCaptionFile: _loadCaptionsFromUrl(subtitlesUrl),
    );

    _controller.addListener(() {
      if (_controller.value.isCompleted && _controller.value.position == _controller.value.duration) {
        debugPrint('video ended');
        proceed();
      } else {
        setState(() {});
      }
    });

    _controller.initialize().then((value) => _controller.play());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 2 / 3,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_controller),
                    ClosedCaption(text: _controller.value.caption.text),
                    VideoProgressIndicator(_controller, allowScrubbing: true),
                  ],
                ),
              )
            ),
            const SizedBox(height: 10),
            getOutlinedButton(context, 'SKIP', proceed)
          ],
        )
      ),
    );
  }

  void proceed() {
    final StateModel stateModel =
        Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.evaluation); //todo
  }
}
