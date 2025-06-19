import 'package:flutter/material.dart';
import 'dart:io';

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import '../services/image_processor.dart';
import 'package:image_picker/image_picker.dart';

class ImageProcessingPage extends StatefulWidget {
  @override

  final File image;

  const ImageProcessingPage({super.key, required this.image});

  ImageProcessingPageState createState() => ImageProcessingPageState();
}
class ImageProcessingPageState extends State<ImageProcessingPage> with SingleTickerProviderStateMixin {

  File? _processedImage;


  String _noiseMethod = 'GaussianBlur';
  int _kernelSize = 3;
  double _sigma = 1.0;
  double _brightness = 0.0;
  double _alpha = 1.0;
  double _beta = 0.0;
  double _skewX = 0.0;
  double _skewY = 0.0;

  // TabController for managing tabs
  late TabController _tabController;

  // Noise Method
  List<String> noiseMethods = ['GaussianBlur', 'MedianBlur'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  //
  Future<void> processImage() async {
    print('Processing Image with parameters: $_noiseMethod, $_kernelSize, $_sigma, $_brightness, $_alpha, $_beta, $_skewX, $_skewY');

    //
    setState(() {

      _processedImage = widget.image;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Preprocessing'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //
                  Image.file(
                    widget.image,
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(width: 20),
                  //
                  _processedImage == null
                      ? Text('No processed image.')
                      : Image.file(
                    _processedImage!,
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
              SizedBox(height: 20),

              //
              ElevatedButton(
                onPressed: () {
                  processImage();
                },
                child: Text('Preprocess Image'),
              ),
              SizedBox(height: 20),

              //
              Container(
                height: 320, // Content area height
                child: Column(
                  children: [

                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(text: 'Noise Settings'),
                        Tab(text: 'Brightness/Contrast'),
                        Tab(text: 'Skew Settings'),
                      ],
                    ),

                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Noise Method:'),
                                DropdownButton<String>(
                                  value: _noiseMethod,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _noiseMethod = newValue!;
                                    });
                                  },
                                  items: noiseMethods.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 20),
                                Text('Kernel Size:'),
                                DropdownButton<int>(
                                  value: _kernelSize,
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      _kernelSize = newValue!;
                                    });
                                  },
                                  items: [3, 5, 7, 9, 11]
                                      .map<DropdownMenuItem<int>>((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(value.toString()),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 20),
                                Text('Sigma: $_sigma'),
                                Slider(
                                  min: 0.0,
                                  max: 5.0,
                                  value: _sigma,
                                  onChanged: (value) {
                                    setState(() {
                                      _sigma = (value * 10).round() / 10;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                         Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Brightness: $_brightness'),
                                Slider(
                                  min: -255.0,
                                  max: 255.0,
                                  value: _brightness,
                                  onChanged: (value) {
                                    setState(() {
                                      _brightness =  (value * 10).round() / 10;
                                    });
                                  },
                                ),
                                SizedBox(height: 20),
                                Text('Alpha (Contrast): $_alpha'),
                                Slider(
                                  min: 0.0,
                                  max: 2.0,
                                  value: _alpha,
                                  onChanged: (value) {
                                    setState(() {
                                      _alpha =  (value * 10).round() / 10;
                                    });
                                  },
                                ),
                                SizedBox(height: 20),
                                Text('Beta (Brightness): $_beta'),
                                Slider(
                                  min: -100.0,
                                  max: 100.0,
                                  value: _beta,
                                  onChanged: (value) {
                                    setState(() {
                                      _beta =  (value * 10).round() / 10;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SkewX: $_skewX'),
                                Slider(
                                  min: -45.0,
                                  max: 45.0,
                                  value: _skewX,
                                  onChanged: (value) {
                                    setState(() {
                                      _skewX =  (value * 10).round() / 10;
                                    });
                                  },
                                ),
                                SizedBox(height: 20),
                                Text('SkewY: $_skewY'),
                                Slider(
                                  min: -45.0,
                                  max: 45.0,
                                  value: _skewY,
                                  onChanged: (value) {
                                    setState(() {
                                      _skewY =  (value * 10).round() / 10;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Confirm, Cancel button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      processImage();
                    },
                    child: Text('Confirm'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _kernelSize = 3;
                        _sigma = 1.0;
                        _brightness = 0.0;
                        _alpha = 1.0;
                        _beta = 0.0;
                        _skewX = 0.0;
                        _skewY = 0.0;
                      });
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}