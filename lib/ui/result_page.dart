import 'package:flutter/material.dart';
import 'dart:io';
import 'image_processing_page.dart';

class ResultPage extends StatefulWidget {
  final File imageFile;

  const ResultPage({super.key, required this.imageFile});

  @override
  ResultPageState createState() => ResultPageState();
}

class ResultPageState extends State<ResultPage> {
  File? processedImage;

  //
  void processImage() {
    //
    setState(() {
      processedImage = widget.imageFile; //
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Original Image
                  Expanded(
                    child: Column(
                      children: [
                        const Text("Original Image"),
                        SizedBox(height: 10),
                        Image.file(widget.imageFile, height: 300, fit: BoxFit.cover),
                      ],
                    ),
                  ),
                  SizedBox(width: 20), //
                  //
                  Expanded(
                    child: Column(
                      children: [
                        const Text("PreProcessed Image"),
                        SizedBox(height: 10),
                        processedImage == null
                            ? Text("There is not PreProcessed Image")
                            : Image.file(processedImage!, height: 300, fit: BoxFit.cover),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "※ The analyzed tire condition is displayed here.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            //
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 30),
                ),

                onPressed: () async {
                  //
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImageProcessingPage(image: widget.imageFile)),
                  );

                  if (result != null) {
                    setState(() {
                      processedImage = result;
                    });
                  }
                },
                child: Text("PreProcess Image"),
              ),
            ),

            //
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 30),
                ),


                onPressed: () {


                },
                child: Text("Analyze Image"),
              ),
            ),

            //
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 30),
                ),


                onPressed: () {

                },
                child: Text("History"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}