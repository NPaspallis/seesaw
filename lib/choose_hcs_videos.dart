import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/state_model.dart';
import 'package:video_player/video_player.dart';
import 'main.dart';

class ChooseHcsVideos extends StatefulWidget {

  const ChooseHcsVideos({super.key});

  @override
  State<StatefulWidget> createState() => _ChooseHcsVideos();
}

const videoUrls = [
  'https://storage.googleapis.com/prepared-project.appspot.com/stories/human_challenge_studies/videos/charles-weijer-1.mp4',
  'https://storage.googleapis.com/prepared-project.appspot.com/stories/human_challenge_studies/videos/charles-weijer-1.mp4',
  'https://storage.googleapis.com/prepared-project.appspot.com/stories/human_challenge_studies/videos/charles-weijer-1.mp4',
];

const subtitlesUrls = [
  'https://storage.googleapis.com/prepared-project.appspot.com/stories/human_challenge_studies/videos/charles-weijer-1.srt',
  'https://storage.googleapis.com/prepared-project.appspot.com/stories/human_challenge_studies/videos/charles-weijer-1.srt',
  'https://storage.googleapis.com/prepared-project.appspot.com/stories/human_challenge_studies/videos/charles-weijer-1.srt',
];

enum VideoState { showNone, showVideo0, showVideo1, showVideo2 }

class _ChooseHcsVideos extends State<ChooseHcsVideos> {

  VideoState _videoState = VideoState.showNone;

  final Random random = Random();
  final double _side = 350;
  late double _lp0;
  late double _tp0;
  late double _lp1;
  late double _tp1;
  late double _lp2;
  late double _tp2;
  var colors = [preparedOrangeColor, preparedBrightRed, preparedCyanColor];
  var watched = [false, false, false];

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    final double ballPaddingSide = _side / 3;
    _lp0 = random.nextDouble() * ballPaddingSide;
    _tp0 = random.nextDouble() * ballPaddingSide;
    _lp1 = random.nextDouble() * ballPaddingSide;
    _tp1 = random.nextDouble() * ballPaddingSide;
    _lp2 = random.nextDouble() * ballPaddingSide;
    _tp2 = random.nextDouble() * ballPaddingSide;
    colors.shuffle(random);

    // handle video controller
    // _controller = VideoPlayerController.networkUrl(
    //   Uri.parse(videoUrls[0]),//todo
    //   // closedCaptionFile: _loadCaptionsFromUrl(subtitlesUrl), // todo fix loading subtitles
    // );

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
        child:
            Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Human Challenge Studies Seesaw',
                      style: TextStyle(
                          fontSize: textSizeLarge,
                          color: preparedWhiteColor),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                        children: [
                          _getClickableBall(colors[0], _side, _lp0, _tp0, "A person's experience of being part of a COVID-19 HCS", watched[0], watchVideo0),
                          _getClickableBall(colors[1], _side, _lp1, _tp1, "Read from Peter Singer’s article on COVID-19 HCS", watched[1], watchVideo1),
                          _getClickableBall(colors[2], _side, _lp2, _tp2, "A doctor explaining the risks of HCS with COVID-19", watched[2], watchVideo2)
                        ]
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                        visible: watched[0] && watched[1] && watched[2],
                        child: getElevatedButton(context, 'CARRY ON', proceed)
                    )
                  ],
                ),
                // video layer
                Visibility(
                  visible: _videoState != VideoState.showNone,
                  child: Column(
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
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('What does a world-leading expert think? Meet Prof. Charles Weijer.', style: TextStyle(fontSize: textSizeSmall, color: preparedWhiteColor)),
                          const SizedBox(width: 10),
                          getOutlinedButton(context, 'SKIP', proceed)
                        ],
                      )

                    ],
                  )
                )
              ],
            )
    );
  }

  Widget _getClickableBall(Color color, double side, double lp, double tp, String text, bool watched, VoidCallback callback) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 2,
      child: Padding(
        padding: EdgeInsets.fromLTRB(lp, tp, side/3 - lp, side/3 - tp),
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 10.0,
              ),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: side/8, horizontal: side/5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text, style: const TextStyle(fontSize: textSizeMedium, fontWeight: FontWeight.w900, color: preparedWhiteColor), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                watched ?
                const Text('WATCHED 🗹', style: TextStyle(fontSize: textSizeSmall, fontWeight: FontWeight.w500, color: preparedSecondaryColor)) :
                getOutlinedButton(context, 'WATCH', callback)
              ],
            )
          )
        ),
      ),
    );
  }

  void proceed() {
    //todo
    setState(() {
      final double ballPaddingSide = _side / 3;
      _lp0 = random.nextDouble() * ballPaddingSide;
      _tp0 = random.nextDouble() * ballPaddingSide;
      _lp1 = random.nextDouble() * ballPaddingSide;
      _tp1 = random.nextDouble() * ballPaddingSide;
      _lp2 = random.nextDouble() * ballPaddingSide;
      _tp2 = random.nextDouble() * ballPaddingSide;
    });
    Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
  }

  void watchVideo0() {
    //todo
    setState(() {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrls[0]),
        // closedCaptionFile: _loadCaptionsFromUrl(subtitlesUrl), // todo fix loading subtitles
      );
      _videoState = VideoState.showVideo0;
      watched[0] = true;
    });
  }

  void watchVideo1() {
    //todo
    setState(() {
      watched[1] = true;
    });
  }

  void watchVideo2() {
    //todo
    setState(() {
      watched[2] = true;
    });
  }
}