import 'package:flutter/material.dart';

class My extends StatefulWidget {
  const My({super.key});

  @override
  State<My> createState() => _MyState();
}

class _MyState extends State<My> {
  double c = 0;
  @override
  Widget build(BuildContext context) {
    return Slider(
        value: c,
        min: 0,
        max: 100,
        divisions: 5,
        label: c.round().toString(),
        onChanged: (double value) {
          setState(() {
            c = value;
          });
        });
  }
}
