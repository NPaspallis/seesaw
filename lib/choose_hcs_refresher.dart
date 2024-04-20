// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:seesaw/buttons.dart';
// import 'package:seesaw/main.dart';
// import 'package:seesaw/state_model.dart';
//
// class HcsChooseRefresher extends StatefulWidget {
//   const HcsChooseRefresher({super.key});
//
//   @override
//   State createState() => _HcsChooseRefresherState();
// }
//
// class _HcsChooseRefresherState extends State<HcsChooseRefresher> {
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height * 2 / 3,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const Padding(
//                 padding: EdgeInsets.all(50),
//                 child: Text('Human Challenge Studies',
//                     style: TextStyle(
//                         fontSize: textSizeLarge,
//                         fontWeight: FontWeight.w900,
//                         color: preparedWhiteColor,
//                         decoration: TextDecoration.none))),
//             Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width / 4,
//                     child: const Text(
//                         'Press here if you know what human challenge studies are',
//                         style: TextStyle(
//                             fontSize: textSizeMedium,
//                             color: preparedWhiteColor,
//                             decoration: TextDecoration.none), textAlign: TextAlign.center),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width / 4,
//                     child: const Text(
//                         'Press here if you would like a refresher',
//                         style: TextStyle(
//                             fontSize: textSizeMedium,
//                             color: preparedWhiteColor,
//                             decoration: TextDecoration.none), textAlign: TextAlign.center),
//                   ),
//                 ]),
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 getOutlinedButton(context, 'SKIP REFRESHER', skipRefresher),
//                 getElevatedButton(context, 'DO REFRESHER', doRefresher)
//               ],
//             ),
//           ],
//         ));
//   }
//
//   void skipRefresher() {
//     debugPrint('skipRefresher');
//     Provider.of<StateModel>(context, listen: false).setSeesawState(SeesawState.makeDecisionBeforeCharlesWeijerVideo);
//   }
//
//   void doRefresher() {
//     debugPrint('doRefresher');
//     Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
//   }
// }
