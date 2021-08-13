import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final String label;
  final Color color;

  // const ButtonWithIcon({Key? key}) : super(key: key);

  ButtonWithIcon(
      {required this.onPressed,
      required this.icon,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SizedBox(
          width: double.infinity,
          child: (ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onPressed: onPressed,
              icon: icon,
              label: Text(
                label,
                style: TextStyle(fontSize: 20),
              )
          )
          )
      ),
    );
  }
}
