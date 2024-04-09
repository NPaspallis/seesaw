import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/perspective.dart';
import 'package:seesaw/seesaw.dart';
import 'package:seesaw/state_model.dart';

import 'buttons.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StateModel(),
      child: const MyApp(),
    ),
  );
}

const preparedPrimaryColor = Color(0xFF007689);
const preparedSecondaryColor = Color(0xFF97C13C);
const preparedShadeColor = Color(0xFF006272);
const preparedDarkShadeColor = Color(0xFF59862B);
const preparedWhiteColor = Color(0xFFFFFFFF);
const preparedBlueColor = Color(0xFF17486A);
const preparedGreyColor = Colors.grey;
const preparedBallColors = [
  preparedBlueColor,
  Color(0xFFDD1667),
  Color(0xFF29BCE2),
  Color(0xFFFD9E22),
  Color(0xFFE7263B),
  Color(0xFFA21A3F),
  Color(0xFF9C1567),
  preparedBlueColor,
  Color(0xFFDD1667),
  Color(0xFF29BCE2),
  Color(0xFFFD9E22),
  Color(0xFFE7263B),
  Color(0xFFA21A3F),
  Color(0xFF9C1567),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seesaw App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: preparedPrimaryColor),
        primaryColor: preparedPrimaryColor,
        splashColor: preparedSecondaryColor,
        fontFamily: 'Open Sans',
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'seesaw'),
    );
  }
}

void navigateTo(final BuildContext context, final Widget targetWidget) {
  Navigator.push(
      context,
      PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => targetWidget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          }
      )
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late BalancingSeesaw _balancingSeesaw;

  @override
  void initState() {
    super.initState();
    _balancingSeesaw = const BalancingSeesaw();
  }

  void choosePerspective() {
    navigateTo(context, const ChoosePerspective());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: preparedPrimaryColor,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/4,
              width: MediaQuery.of(context).size.height/4,
              padding: const EdgeInsets.all(30),
              child: getElevatedButtonWithPreparedLabel(context, 'Press to Start', choosePerspective)
            ),
            Expanded(child: _balancingSeesaw),
            const Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                child: Text(
                    'An interactive experience demonstrating ethical tradeoffs in times of crisis',
                    style: TextStyle(fontSize: 32, color: preparedWhiteColor))
            )
          ]
        )
      )
    );
  }
}