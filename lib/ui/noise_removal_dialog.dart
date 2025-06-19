import 'package:flutter/material.dart';

class NoiseRemovalDialog extends StatefulWidget {
  final double initialStrength;
  const NoiseRemovalDialog({Key? key, required this.initialStrength}) : super(key: key);

  @override
  NoiseRemovalDialogState createState() => NoiseRemovalDialogState();
}

class NoiseRemovalDialogState extends State<NoiseRemovalDialog> {
  late double strength;

  @override
  void initState() {
    super.initState();
    strength = widget.initialStrength;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Noise Reduction Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Set the noise removal intensity."),
          Slider(
            value: strength,
            min: 0,
            max: 1,
            onChanged: (value) {
              setState(() {
                strength = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);  //
          },
          child: Text('cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, strength); //
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}