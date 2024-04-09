import 'package:flutter/gestures.dart';
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

OutlinedButton getOutlinedButton(final BuildContext context,
    final String text, final VoidCallback callback) {
  return OutlinedButton(
    onPressed: () => callback(),
    style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color:
          preparedSecondaryColor, //Set border color
          width: 2, //Set border width
        )),
    child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(text,
            style: const TextStyle(
                fontSize: textSizeSmall,
                fontWeight: FontWeight.w500,
                color: Colors.white))),
  );
}

ElevatedButton getElevatedButton(final BuildContext context,
    final String text, final VoidCallback callback) {
  return ElevatedButton(
      onPressed: () => callback(),
      style: const ButtonStyle(
        backgroundColor:
        MaterialStatePropertyAll<Color>(
            preparedSecondaryColor),
      ),
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(text,
              style: const TextStyle(
                  fontSize: textSizeSmall,
                  fontWeight: FontWeight.w900,
                  color: Colors.white))));
}