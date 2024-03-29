import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:seesaw/main.dart';

const double minSeesawHeight = 10;

class Seesaw extends CustomPainter {

  double tiltRadius = 0.0;
  int recolorSeed = 0;
  var ballColors = List<Color>.from(preparedBallColors);

  // check out animations here: https://blog.codemagic.io/flutter-custom-painter
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()..color = preparedPrimaryColor,
    );

    final Size seesawSize = Size(size.width * 0.9, math.max(minSeesawHeight, size.height * 0.02));
    final double triangleSide = math.min(size.width/5, size.height/5);
    final double ballRadius = math.min(size.width / 25, size.height / 25);

    final Rect seesawBar = Rect.fromLTRB(size.width/2 - seesawSize.width/2, size.height/2 - seesawSize.height/2, size.width/2 + seesawSize.width/2, size.height/2 + seesawSize.height/2);

    // draw left balance shade
    {
      var path = Path();
      double leftMagnifier = ((2*maxTilt-tiltRadius)/maxTilt).abs();
      double xMagnifier = 25 + 2*leftMagnifier;
      double yMagnifier = 0.5*leftMagnifier;
      double centerX = size.width/2 - seesawSize.width/2 + 3.3*ballRadius;
      path.addOval(Rect.fromLTRB(centerX-xMagnifier, size.height/2 + triangleSide - yMagnifier, centerX+xMagnifier, size.height/2 + triangleSide + seesawSize.height + yMagnifier));
      canvas.drawPath(
          path,
          Paint()..color = preparedShadeColor
      );
    }

    // draw right balance shade
    {
      var path = Path();
      double rightMagnifier = ((-tiltRadius-2*maxTilt)/maxTilt).abs();
      double xMagnifier = 25 + 3*rightMagnifier;
      double yMagnifier = 0.5*rightMagnifier;
      double centerX = size.width/2 + seesawSize.width/2 - 3.3*ballRadius;
      path.addOval(Rect.fromLTRB(centerX-xMagnifier, size.height/2 + triangleSide - yMagnifier, centerX+xMagnifier, size.height/2 + triangleSide + seesawSize.height + yMagnifier));
      canvas.drawPath(
          path,
          Paint()..color = preparedShadeColor
      );
    }

    // draw basis shade
    {
      var path = Path();

      path.addOval(Rect.fromLTRB(size.width/2 - 0.75*triangleSide, size.height/2 + triangleSide, size.width/2 + 0.75*triangleSide, size.height/2 + triangleSide + 2*minSeesawHeight));
      canvas.drawPath(
        path,
        Paint()..color = preparedShadeColor
      );
    }

    // draw triangular basis
    {
      var path = Path();
      path.moveTo(size.width/2, size.height/2 + minSeesawHeight);
      path.lineTo(size.width/2 - triangleSide/2, size.height/2 + triangleSide + minSeesawHeight);
      path.lineTo(size.width/2 + triangleSide/2, size.height/2 + triangleSide + minSeesawHeight);
      path.lineTo(size.width/2, size.height/2 + minSeesawHeight);
      canvas.drawPath(
        path,
        Paint()..color = preparedSecondaryColor
      );
    }

    // draw basis triangle top shade
    {
      // double leftY =
      var path = Path();
      path.moveTo(size.width/2, size.height/2 + minSeesawHeight);
      path.lineTo(size.width/2 - (triangleSide/2/3), size.height/2 + triangleSide/3 + minSeesawHeight);
      path.lineTo(size.width/2 + (triangleSide/2/3), size.height/2 + triangleSide/3 + minSeesawHeight);
      path.lineTo(size.width/2, size.height/2 + minSeesawHeight);
      canvas.drawPath(
          path,
          Paint()..color = preparedDarkShadeColor
      );
    }

    // save state, rotate canvas to draw seesaw, and restore
    // https://stackoverflow.com/questions/51323233/flutter-how-to-rotate-an-image-around-the-center-with-canvas
    canvas.save();
    final double r = math.sqrt(size.width * size.width + size.height * size.height) / 2;
    final alpha = math.atan(size.height / size.width);
    final beta = alpha + tiltRadius;
    final shiftY = r * math.sin(beta);
    final shiftX = r * math.cos(beta);
    final translateX = size.width / 2 - shiftX;
    final translateY = size.height / 2 - shiftY;
    canvas.translate(translateX, translateY);
    canvas.rotate(tiltRadius);
    canvas.drawRect(
        seesawBar,
        Paint()..color = preparedWhiteColor
    );

    // draw balls - left side
    {
      canvas.drawPath(
          Path()..addOval(Rect.fromCircle(
            center: Offset(size.width/2 - seesawSize.width/2 + ballRadius, size.height/2 - 2*ballRadius + minSeesawHeight/3),
            radius: ballRadius,
          )),
          Paint()..color = preparedBallColors[0]
      );
      canvas.drawPath(
          Path()..addOval(Rect.fromCircle(
            center: Offset(size.width/2 - seesawSize.width/2 + 3.3*ballRadius, size.height/2 - 2*ballRadius + minSeesawHeight/3),
            radius: ballRadius,
          )),
          Paint()..color = preparedBallColors[1]
      );
      canvas.drawPath(
          Path()..addOval(Rect.fromCircle(
            center: Offset(size.width/2 - seesawSize.width/2 + 5.6*ballRadius, size.height/2 - 2*ballRadius + minSeesawHeight/3),
            radius: ballRadius,
          )),
          Paint()..color = preparedBallColors[2]
      );
      canvas.drawPath(
          Path()..addOval(Rect.fromCircle(
            center: Offset(size.width/2 - seesawSize.width/2 + 2.15*ballRadius, size.height/2 - 4*ballRadius + minSeesawHeight/3),
            radius: ballRadius,
          )),
          Paint()..color = preparedBallColors[3]
      );
      canvas.drawPath(
          Path()..addOval(Rect.fromCircle(
            center: Offset(size.width/2 - seesawSize.width/2 + 4.45*ballRadius, size.height/2 - 4*ballRadius + minSeesawHeight/3),
            radius: ballRadius,
          )),
          Paint()..color = preparedBallColors[4]
      );
      canvas.drawPath(
          Path()..addOval(Rect.fromCircle(
            center: Offset(size.width/2 - seesawSize.width/2 + 3.3*ballRadius, size.height/2 - 6*ballRadius + minSeesawHeight/3),
            radius: ballRadius,
          )),
          Paint()..color = preparedBallColors[5]
      );
    }

    // draw balls - right side
    {
      canvas.drawPath(
          Path()..addOval(Rect.fromCircle(
            center: Offset(size.width /2 + seesawSize.width/2 - ballRadius, size.height/2 - 2*ballRadius + minSeesawHeight/3),
            radius: ballRadius,
          )),
          Paint()..color = preparedBallColors[6]
      );
      canvas.drawPath(
          Path()..addOval(Rect.fromCircle(
            center: Offset(size.width /2 + seesawSize.width/2 - 3.3*ballRadius, size.height/2 - 2*ballRadius + minSeesawHeight/3),
            radius: ballRadius,
          )),
          Paint()..color = preparedBallColors[7]
      );
      canvas.drawPath(
          Path()..addOval(Rect.fromCircle(
            center: Offset(size.width/2 + seesawSize.width/2 - 5.6*ballRadius, size.height/2 - 2*ballRadius + minSeesawHeight/3),
            radius: ballRadius,
          )),
          Paint()..color = preparedBallColors[8]
      );
      canvas.drawPath(
          Path()..addOval(Rect.fromCircle(
            center: Offset(size.width/2 + seesawSize.width/2 - 2.15*ballRadius, size.height/2 - 4*ballRadius + minSeesawHeight/3),
            radius: ballRadius,
          )),
          Paint()..color = preparedBallColors[9]
      );
      canvas.drawPath(
          Path()..addOval(Rect.fromCircle(
            center: Offset(size.width/2 + seesawSize.width/2 - 4.45*ballRadius, size.height/2 - 4*ballRadius + minSeesawHeight/3),
            radius: ballRadius,
          )),
          Paint()..color = preparedBallColors[10]
      );
      canvas.drawPath(
          Path()..addOval(Rect.fromCircle(
            center: Offset(size.width/2 + seesawSize.width/2 - 3.3*ballRadius, size.height/2 - 6*ballRadius + minSeesawHeight/3),
            radius: ballRadius,
          )),
          Paint()..color = preparedBallColors[11]
      );
    }

    canvas.restore();

    // const textStyle = TextStyle(color: Color(0xFF000000), fontSize: 20);
    // TextSpan textSpan = TextSpan(text: '$tiltRadius', style: textStyle);
    // TextPainter textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    // textPainter.layout(
    //   minWidth: 0,
    //   maxWidth: size.width,
    // );
    // textPainter.paint(canvas, Offset(10, size.height * 2 / 3));
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      // Annotate a rectangle containing the picture of the sun with the label
      // "Sun". When text to speech feature is enabled on the device, a user
      // will be able to locate the sun on this picture by touch.
      Rect rect = Offset.zero & size;
      final double width = size.shortestSide * 0.4;
      rect = const Alignment(0.8, -0.9).inscribe(Size(width, width), rect);
      return <CustomPainterSemantics>[
        CustomPainterSemantics(
          rect: rect,
          properties: const SemanticsProperties(
            label: 'Sun',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  // Since this painter has no fields, it always paints the same thing and
  // semantics information is the same.
  // Therefore we return false here. If we had fields (set from the
  // constructor) then we would return true if any of them differed from the
  // same fields on the oldDelegate.
  @override
  bool shouldRepaint(Seesaw oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(Seesaw oldDelegate) => false;

  Seesaw.tilt(this.tiltRadius) {
    ballColors.shuffle(math.Random(recolorSeed));
  }
  Seesaw.recolor(this.recolorSeed) {
    ballColors.shuffle(math.Random(recolorSeed));
  }
}

class BalancingSeesaw extends StatefulWidget {
  const BalancingSeesaw({super.key});

  @override
  _BalancingSeesawState createState() => _BalancingSeesawState();
}

// const maxTilt = math.pi/16; // largest leaning
const maxTilt = math.pi/128; // min leaning

const animationSeconds = 2; // the larger, the slower

class _BalancingSeesawState extends State<BalancingSeesaw>
      with TickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> animation;

  final Tween<double> _rotationTween = Tween(begin: -maxTilt, end: maxTilt);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: animationSeconds),
    );

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, snapshot) {
        return CustomPaint(
          painter: Seesaw.tilt(animation.value),
          child: Container(),
        );
      }
    );
  }
}