import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/firebase_options.dart';
import 'package:seesaw/seesaw_app.dart';
import 'package:seesaw/state_model.dart';

const preparedPrimaryColor = Color(0xFF007689);
const preparedPrimarySemitransparentColor = Color(0x7F007689);
const preparedSecondaryColor = Color(0xFF97C13C);
const preparedShadeColor = Color(0xFF006272);
const preparedDarkShadeColor = Color(0xFF59862B);
const preparedWhiteColor = Color(0xFFFFFFFF);
const preparedBlackColor = Color(0xFF000000);
const preparedCyanColor = Color(0xFF29BCE2);
const preparedDarkCyanColor = Color(0xFF30B3D5);
const preparedOrangeColor = Color(0xFFFD9E22);
const preparedDarkOrangeColor = Color(0xFFC97C17);
const preparedBrightRedColor = Color(0xFFE7263B);
const preparedRedColor = Color(0xFFA21A3F);
const preparedDarkRedColor = Color(0xFF9C1567);
const preparedBlueColor = Color(0xFF17486A);
const preparedGreyColor = Colors.grey;
const preparedBallColors = [
  preparedBlueColor,
  Color(0xFFDD1667),
  preparedCyanColor,
  preparedOrangeColor,
  preparedBrightRedColor,
  preparedRedColor,
  preparedDarkRedColor,
  preparedBlueColor,
  Color(0xFFDD1667),
  preparedCyanColor,
  preparedOrangeColor,
  preparedBrightRedColor,
  preparedRedColor,
  preparedDarkRedColor,
];

const double textSizeLarger = 48;
const double textSizeLarge = 42;
const double textSizeMedium = 32;
const double textSizeSmall = 24;
const double textSizeSmaller = 20;
const double textSizeSmallerer = 18;
const double textSizeSmallest = 16;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: firebaseOptions
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => StateModel(),
      child: const SeesawApp(), // todo add layer which collects all interactions and resets the app when there is no activity for a preset number of minutes, e.g. 5
    ),
  );
}
