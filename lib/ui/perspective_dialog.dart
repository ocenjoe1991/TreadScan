import 'package:flutter/material.dart';

class PerspectiveDialog extends StatefulWidget {
  final double initialPerspective;
  const PerspectiveDialog({Key? key, required this.initialPerspective}) : super(key: key);

  @override
  PerspectiveDialogState createState() => PerspectiveDialogState();
}

class PerspectiveDialogState extends State<PerspectiveDialog> {
  late double perspective;

  @override
  void initState() {
    super.initState();
    perspective = widget.initialPerspective;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Setting of the Perspective'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Set the perspective correction."),
          Slider(
            value: perspective,
            min: 0,
            max: 1,
            onChanged: (value) {
              setState(() {
                perspective = value;
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
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, perspective); //
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}