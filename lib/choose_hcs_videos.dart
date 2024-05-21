import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
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
  'https://storage.googleapis.com/prepared-project.appspot.com/seesaw/clip1_healthy_volunteers.mp4',
  'https://storage.googleapis.com/prepared-project.appspot.com/seesaw/clip2_chappell_singer_hcs.mp4',
  'https://storage.googleapis.com/prepared-project.appspot.com/seesaw/clip3_ethical_controversies.mp4',
];

const _videoDescriptions = [
  'Healthy\nvolunteers\'\nexperience\nof HCSs',
  'Chappell and\nSinger on HCSs',
  'Ethical\ncontroversies\nabout HCSs',
];

enum VideoState { showNone, showVideo0, showVideo1, showVideo2 }

const numOfVideos = 3;

class _ChooseHcsVideos extends State<ChooseHcsVideos> {

  VideoState _videoState = VideoState.showNone;

  final Random random = Random();
  var colors = [preparedOrangeColor, preparedRedColor, preparedCyanColor];
  var watched = [false, false, false];

  late final List<VideoPlayerController> _controllers = List.empty(growable: true);

  late double _side;
  late double _ballPaddingSide;
  late List<double> _lp;
  late List<double> _tp;

  @override
  void initState() {
    super.initState();

    // First get the FlutterView.
    final FlutterView flutterView = WidgetsBinding.instance.platformDispatcher.views.first;
    final Size size = flutterView.physicalSize / flutterView.devicePixelRatio;
    _side = size.width / 3;
    _ballPaddingSide = _side / 10;
    _lp = List<double>.generate(numOfVideos, (i) => random.nextDouble() * _ballPaddingSide);
    _tp = List<double>.generate(numOfVideos, (i) => random.nextDouble() * _ballPaddingSide);

    colors.shuffle(random);

    // handle video controllers
    for(int i = 0; i < videoUrls.length; i++) {
      _controllers.add(VideoPlayerController.networkUrl(
        Uri.parse(videoUrls[i]),
        // closedCaptionFile: _loadCaptionsFromUrl(subtitlesUrls[i]), // todo fix loading subtitles
      ));

      _controllers[i].addListener(() {
        if (_controllers[i].value.isCompleted && _controllers[i].value.position == _controllers[i].value.duration) {
          debugPrint('video ended');
          watched[i] = true;
          _videoState = VideoState.showNone;
        }
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height / 12,
                child: const FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    'Human Challenge Studies Seesaw',
                    style: TextStyle(color: preparedWhiteColor),
                    textAlign: TextAlign.center,
                  ),
                )
            ),
            Row(
                children: [
                  _getClickableBall(colors[0], _side, _lp[0], _tp[0], _videoDescriptions[0], watched[0], watchVideo0),
                  _getClickableBall(colors[1], _side, _lp[1], _tp[1], _videoDescriptions[1], watched[1], watchVideo1),
                  _getClickableBall(colors[2], _side, _lp[2], _tp[2], _videoDescriptions[2], watched[2], watchVideo2)
                ]
            ),
            getOutlinedButton(context, 'CARRY ON', proceed)
          ],
        ),
        // video layer
        _videoState != VideoState.showNone ? _getVideoLayer() : Container()
      ],
    );
  }

  Widget _getClickableBall(Color color, double side, double lp, double tp, String text, bool watched, VoidCallback callback) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 2.1,
        child: Padding(
          padding: EdgeInsets.fromLTRB(lp, tp, side/5 - lp, side/5 - tp),
          child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 10.0,
                ),
              ),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: EdgeInsets.all(side/5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.fitWidth,
                          child: Text(text, style: const TextStyle(fontSize: textSizeMedium, fontWeight: FontWeight.w900, color: preparedWhiteColor), textAlign: TextAlign.center)
                      ),
                      const SizedBox(height: 10),
                      watched ?
                      Text('WATCHED ✓', style: TextStyle(fontSize: textSizeSmall, fontWeight: FontWeight.w500, color: color)) :
                      getElevatedButton(context, 'WATCH', callback, color)
                    ],
                  ),
                )
              )
          ),
        ),
      );
  }

  Widget _getVideoLayer() {
    final int index = _getVideoStateIndex();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 23/24,
      color: Colors.black38,
      child: Column(
        children: [
          Expanded(
              child: AspectRatio(
                aspectRatio: _controllers[index].value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_controllers[index]),
                    ClosedCaption(text: _controllers[index].value.caption.text),
                    VideoProgressIndicator(_controllers[index], allowScrubbing: true),
                  ],
                ),
              )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(getTextWithNoLineBreaks(_videoDescriptions[index]), style: const TextStyle(fontSize: textSizeSmall, color: preparedWhiteColor)),
                const SizedBox(width: 10),
                getOutlinedButton(context, 'BACK', back)
              ],
            )
          )
        ],
      )
    );
  }

  int _getVideoStateIndex() {
    switch(_videoState) {
      case VideoState.showVideo0:
        return 0;
      case VideoState.showVideo1:
        return 1;
      case VideoState.showVideo2:
        return 2;
      default:
        throw Exception('Invalid VideoState when requesting video controller: $_videoState');
    }
  }

  void back() {
    setState(() {
      // pause all videos
      for (var controller in _controllers) {
        controller.pause();
      }
      _videoState = VideoState.showNone;
    });
  }

  void proceed() {
    // //todo
    // setState(() {
    //   final double ballPaddingSide = _side / 3;
    //   _lp0 = random.nextDouble() * ballPaddingSide;
    //   _tp0 = random.nextDouble() * ballPaddingSide;
    //   _lp1 = random.nextDouble() * ballPaddingSide;
    //   _tp1 = random.nextDouble() * ballPaddingSide;
    //   _lp2 = random.nextDouble() * ballPaddingSide;
    //   _tp2 = random.nextDouble() * ballPaddingSide;
    // });
    Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
  }

  void watchVideo0() {
    debugPrint('watchVideo0');
    setState(() {
      _videoState = VideoState.showVideo0;
      _controllers[0].initialize().then((value) => _controllers[0].play());
    });
  }

  void watchVideo1() {
    debugPrint('watchVideo1');
    setState(() {
      _videoState = VideoState.showVideo1;
      _controllers[1].initialize().then((value) => _controllers[1].play());
    });
  }

  void watchVideo2() {
    debugPrint('watchVideo2');
    setState(() {
      _videoState = VideoState.showVideo2;
      _controllers[2].initialize().then((value) => _controllers[2].play());
    });
  }

  String getTextWithNoLineBreaks(String s) => s.replaceAll("\n", " ");
}