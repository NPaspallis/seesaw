import 'package:flutter/material.dart';

import 'main.dart';

class HcsChooseRefresher extends StatelessWidget {
  const HcsChooseRefresher({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Column(
          children: [
            const Padding(
                padding: EdgeInsets.all(50),
                child: Text('Human Challenge Trials', style: TextStyle(
                    fontSize: 46,
                    color: preparedWhiteColor,
                    decoration: TextDecoration.none))
            ),
            OutlinedButton(
                onPressed: skipRefresher,
                child: const Text(
                    'Press here if you know what human challenge trials are', style: TextStyle(
                    fontSize: 32,
                    color: preparedWhiteColor,
                    decoration: TextDecoration.none))),
            OutlinedButton(
                onPressed: doRefresher,
                child: const Text('Press here if you would like a refresher', style: TextStyle(
                    fontSize: 32,
                    color: preparedWhiteColor,
                    decoration: TextDecoration.none))),
          ],
        ));
  }

  void skipRefresher() {}

  void doRefresher() {}
}
