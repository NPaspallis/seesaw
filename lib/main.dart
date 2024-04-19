import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/seesaw_app.dart';
import 'package:seesaw/state_model.dart';

const preparedPrimaryColor = Color(0xFF007689);
const preparedSecondaryColor = Color(0xFF97C13C);
const preparedShadeColor = Color(0xFF006272);
const preparedDarkShadeColor = Color(0xFF59862B);
const preparedWhiteColor = Color(0xFFFFFFFF);
const preparedOrangeColor = Color(0xFFFD9E22);
const preparedBlueColor = Color(0xFF17486A);
const preparedGreyColor = Colors.grey;
const preparedBallColors = [
  preparedBlueColor,
  Color(0xFFDD1667),
  Color(0xFF29BCE2),
  preparedOrangeColor,
  Color(0xFFE7263B),
  Color(0xFFA21A3F),
  Color(0xFF9C1567),
  preparedBlueColor,
  Color(0xFFDD1667),
  Color(0xFF29BCE2),
  preparedOrangeColor,
  Color(0xFFE7263B),
  Color(0xFFA21A3F),
  Color(0xFF9C1567),
];

const double textSizeLarge = 42;
const double textSizeMedium = 32;
const double textSizeSmall = 24;
const double textSizeSmaller = 20;
const double textSizeSmallest = 16;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StateModel(),
      child: const SeesawApp(), // todo add layer which collects all interactions and resets the app when there is no activity for a preset number of minutes, e.g. 5
    ),
  );
}
