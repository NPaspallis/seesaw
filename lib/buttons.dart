import 'package:flutter/material.dart';

import 'main.dart';

ElevatedButton getElevatedButtonWithPreparedLabel(final BuildContext context,
    final String text, final VoidCallback callback) {
  return ElevatedButton(
      onPressed: () => callback.call(),
      style: ButtonStyle(
          padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>((
              Set<MaterialState> states) =>
              EdgeInsets.all(states.contains(MaterialState.pressed) ? 0 : 0)),
          // default elevation,
          backgroundColor: MaterialStateProperty.all<Color>(
              preparedPrimaryColor),
          shadowColor: MaterialStateProperty.all<Color>(preparedShadeColor),
          elevation: MaterialStateProperty.resolveWith<double>((
              Set<MaterialState> states) {
            return states.contains(MaterialState.pressed)
                ? 5
                : 15; // default elevation
          }),
          animationDuration: const Duration(milliseconds: 200),
          shape: const MaterialStatePropertyAll(CircleBorder())
      ),
      child: Stack(
        children: [
          Container(
              width: 300,
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/green_button_blank.png'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                    child: Text(text, style: const TextStyle(fontSize: 28,
                        color: preparedWhiteColor,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(color: preparedShadeColor,
                              offset: Offset(2, 2),
                              blurRadius: 4)
                        ]), textAlign: TextAlign.center),
                  ),
                ],
              )
          ),
        ],
      )
  );
}