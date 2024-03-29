import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seesaw/seesaw.dart';

void main() {
  runApp(const MyApp());
}

const preparedPrimaryColor = Color(0xFF007689);
const preparedSecondaryColor = Color(0xFF97C13C);
const preparedShadeColor = Color(0xFF006272);
const preparedDarkShadeColor = Color(0xFF59862B);
const preparedWhiteColor = Color(0xFFFFFFFF);
const preparedBallColors = [
  Color(0xFF17486A),
  Color(0xFFDD1667),
  Color(0xFF29BCE2),
  Color(0xFFFD9E22),
  // Color(0xFF3F7D44),
  Color(0xFFE7263B),
  Color(0xFFA21A3F),
  Color(0xFF9C1567),
  Color(0xFF17486A),
  Color(0xFFDD1667),
  Color(0xFF29BCE2),
  Color(0xFFFD9E22),
  // Color(0xFF3F7D44),
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
      title: 'Flutter Demo',
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: preparedPrimaryColor,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/3),
            const Expanded(child: BalancingSeesaw()),
            const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    'an interactive experience demonstrating ethical tradeoffs in times of crisis',
                    style: TextStyle(fontSize: 24, color: preparedWhiteColor))
            )
          ]
        )
      )
    );
  }
}