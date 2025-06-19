import 'package:flutter/material.dart';

class BrightnessDialog extends StatefulWidget {
  final double initialBrightness;
  const BrightnessDialog({Key? key, required this.initialBrightness}) : super(key: key);

  @override
  BrightnessDialogState createState() => BrightnessDialogState();
}

class BrightnessDialogState extends State<BrightnessDialog> {
  late double brightness;

  @override
  void initState() {
    super.initState();
    brightness = widget.initialBrightness;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Contrast/Brightness Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            Text("Set the contrast/brightness."),
          Slider(
            value: brightness,
            min: 0,
            max: 1,
            onChanged: (value) {
              setState(() {
                brightness = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, brightness);
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}