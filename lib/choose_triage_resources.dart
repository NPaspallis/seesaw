import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/state_model.dart';
import 'package:video_player/video_player.dart';
import 'main.dart';

class ChooseTriageResources extends StatefulWidget {

  const ChooseTriageResources({super.key});

  @override
  State<StatefulWidget> createState() => _ChooseTriageResources();
}

enum ResourceType { resourceVideo, resourceArticle, resourceQuote }

const resourceTypes = [
  ResourceType.resourceVideo,
  ResourceType.resourceArticle,
  ResourceType.resourceArticle,
  ResourceType.resourceQuote,
  ResourceType.resourceQuote,
];

const resourceUrls = [
  'https://storage.googleapis.com/prepared-project.appspot.com/seesaw/Covid%2019%20_%20Triage%20in%20an%20Italian%20ICU%20During%20the%20Pandemic.mp4',
  'assets/ethics_of_icu.png', //'https://storage.googleapis.com/prepared-project.appspot.com/seesaw/ethics_of_icu.png', // 'https://academic.oup.com/bmb/article/138/1/5/6289889'
  'assets/ethical_advice.png', //'https://storage.googleapis.com/prepared-project.appspot.com/seesaw/ethical_advice.png', // 'https://academic.oup.com/phe/article/13/2/157/5900805'
  '',
  '',
];

const resourceDescriptions = [
  "Why 'first come,\nfirst served' is not a\ngood principle during\na pandemic.",
  "Agreement in\nethics guidelines that\n'first come first served'\nshould be avoided.",
  "Read an\nargument for why the\nopportunity to live a\nnormal lifespan should\nbe prioritized.",
  "'First come, first\nserved' is a fair way of\nchoosing between\nindividuals with equal\npriorities and benefits.",
  "'First come,\nfirst served' avoids\ndiscrimination based\non characteristics\nlike age.",
];

enum VideoOrArticleState { showNone, showVideo0, showArticle1, showArticle2 }

const numOfResources = 5;

class _ChooseTriageResources extends State<ChooseTriageResources> {

  VideoOrArticleState _videoOrArticleState = VideoOrArticleState.showNone;

  final Random random = Random();
  var colors = [preparedOrangeColor, preparedRedColor, preparedCyanColor, preparedBlueColor, preparedDarkOrangeColor];
  var watched = [false, false, false, false, false];

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
    _side = size.width / numOfResources;
    _ballPaddingSide = _side / 10;
    _lp = List<double>.generate(numOfResources, (i) => random.nextDouble() * _ballPaddingSide);
    _tp = List<double>.generate(numOfResources, (i) => random.nextDouble() * _ballPaddingSide * 2);

    colors.shuffle(random);

    // handle video controllers
    for(int i = 0; i < resourceUrls.length; i++) {
      if(resourceTypes[i] == ResourceType.resourceVideo) {
        _controllers.add(VideoPlayerController.networkUrl(
          Uri.parse(resourceUrls[i]),
          // closedCaptionFile: _loadCaptionsFromUrl(subtitlesUrls[i]), // todo fix loading subtitles
        ));

        _controllers[i].addListener(() {
          if (_controllers[i].value.isCompleted && _controllers[i].value.position == _controllers[i].value.duration) {
            debugPrint('video ended');
            watched[i] = true;
            _videoOrArticleState = VideoOrArticleState.showNone;
          }
          setState(() {});
        });
      }
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
                    'Crisis Triage Seesaw',
                    style: TextStyle(color: preparedWhiteColor),
                    textAlign: TextAlign.center,
                  ),
                )
            ),
            Row(
                children: [
                  _getClickableBall(resourceTypes[0], colors[0], _side, _lp[0], _tp[0], resourceDescriptions[0], watched[0], watchVideo0),
                  _getClickableBall(resourceTypes[1], colors[1], _side, _lp[1], _tp[1], resourceDescriptions[1], false, watchArticle1),
                  _getClickableBall(resourceTypes[2], colors[2], _side, _lp[2], _tp[2], resourceDescriptions[2], false, watchArticle2),
                  _getClickableBall(resourceTypes[3], colors[3], _side, _lp[3], _tp[3], resourceDescriptions[3], false, doNothing),
                  _getClickableBall(resourceTypes[4], colors[4], _side, _lp[4], _tp[4], resourceDescriptions[4], false, doNothing),
                ]
            ),
            getOutlinedButton(context, 'CARRY ON', proceed)
          ],
        ),
        // video or article layer
        _getVideoOrArticleLayer()
      ],
    );
  }

  Widget _getVideoOrArticleLayer() {
    switch(_videoOrArticleState) {
      case VideoOrArticleState.showVideo0: return _getVideoLayer();
      case VideoOrArticleState.showArticle1:
      case VideoOrArticleState.showArticle2: return _getArticleLayer();
      case VideoOrArticleState.showNone:
      default: return Container();
    }
  }

  Widget _getClickableBall(ResourceType resourceType, Color color, double side, double lp, double tp, String text, bool watched, VoidCallback callback) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 5,
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
                      Visibility(
                        visible: resourceType != ResourceType.resourceQuote,
                        child: getActionButton(resourceType, color, watched, callback),
                      )
                    ],
                  ),
                )
              )
          ),
        ),
      );
  }

  Widget getActionButton(ResourceType resourceType, Color color, bool watched, VoidCallback callback) {
    if(resourceType == ResourceType.resourceVideo) {
      return watched ?
        Text('WATCHED ✓', style: TextStyle(fontSize: textSizeSmall, fontWeight: FontWeight.w500, color: color)) :
        getElevatedButton(context, 'WATCH', callback, color);
    } else if(resourceType == ResourceType.resourceArticle) {
      return watched ?
      Text('VIEWED ✓', style: TextStyle(fontSize: textSizeSmall, fontWeight: FontWeight.w500, color: color)) :
      getElevatedButton(context, 'VIEW ARTICLE', callback, color);
    } else {
      return Container();
    }
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
                Text(getTextWithNoLineBreaks(resourceDescriptions[index]), style: const TextStyle(color: preparedWhiteColor, fontSize: textSizeSmall, fontWeight: FontWeight.bold)),
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
    switch(_videoOrArticleState) {
      case VideoOrArticleState.showVideo0:
        return 0;
      default:
        throw Exception('Invalid VideoOrArticleState when requesting video controller: $_videoOrArticleState');
    }
  }

  Widget _getArticleLayer() {
    final int index = _getArticleStateIndex();
    debugPrint('index: $index -> ${resourceUrls[index]}');
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 23/24,
        color: Colors.black38,
        child: Column(
          children: [
            Expanded(
                // child: Image.network(resourceUrls[index])
                child: Image.asset(resourceUrls[index])
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getTextWithNoLineBreaks(resourceDescriptions[index]), style: const TextStyle(color: preparedWhiteColor, fontSize: textSizeSmall, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    getOutlinedButton(context, 'BACK', back)
                  ],
                )
            )
          ],
        )
    );
  }

  int _getArticleStateIndex() {
    switch(_videoOrArticleState) {
      case VideoOrArticleState.showArticle1:
        return 1;
      case VideoOrArticleState.showArticle2:
        return 2;
      default:
        throw Exception('Invalid VideoOrArticleState when requesting article controller: $_videoOrArticleState');
    }
  }

  void back() {
    setState(() {
      // pause all videos
      for (var controller in _controllers) {
        controller.pause();
      }
      _videoOrArticleState = VideoOrArticleState.showNone;
    });
  }

  void proceed() {
    Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
  }

  void watchVideo0() {
    debugPrint('watchVideo0');
    setState(() {
      _videoOrArticleState = VideoOrArticleState.showVideo0;
      _controllers[0].initialize().then((value) => _controllers[0].play());
    });
  }

  void watchArticle1() {
    debugPrint('watchArticle1');
    setState(() {
      _videoOrArticleState = VideoOrArticleState.showArticle1;
    });
  }

  void watchArticle2() {
    debugPrint('watchArticle2');
    setState(() {
      _videoOrArticleState = VideoOrArticleState.showArticle2;
    });
  }

  void doNothing() => debugPrint('doNothing');

  String getTextWithNoLineBreaks(String s) => s.replaceAll("\n", " ");
}