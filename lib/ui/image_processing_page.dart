import 'package:flutter/material.dart';
import 'dart:io';

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:async'; // Completer
import '../services/image_processor.dart';
import 'package:image_picker/image_picker.dart';

class ImageProcessingPage extends StatefulWidget {
  @override

  final File image;

  const ImageProcessingPage({super.key, required this.image});

  ImageProcessingPageState createState() => ImageProcessingPageState();
}

class ImageProcessingPageState extends State<ImageProcessingPage> with SingleTickerProviderStateMixin {

  Uint8List? processedImage;

  String _noiseMethod = 'GaussianBlur';
  int _kernelSize = 3;
  double _sigma = 1.0;
  double _brightness = 0.0;
  double _contrast = 1.0;
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

    final imageBytes = await widget.image.readAsBytes();

    const platform = MethodChannel('image_processor');

    try {
      final Uint8List result = await platform.invokeMethod('processImage', {
        'image': imageBytes,
        'noiseMethod': _noiseMethod == 'GaussianBlur' ? 1 : 2,
        'kernelSize': _kernelSize,
        'sigma': _sigma,
        'brightness': _brightness,
        'contrast': _contrast,
        'skewX': _skewX,
        'skewY': _skewY,
      });

      setState(() {
        processedImage = result;
      });
    } catch (e) {
      debugPrint("Native error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred during image processing.: $e")),
      );
    }
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
              FutureBuilder<Size>(
                future: _getImageSize(widget.image),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final imageSize = snapshot.data!;
                  final aspectRatio = imageSize.width / imageSize.height;
                  final screenWidth = MediaQuery.of(context).size.width;
                  final halfWidth = (screenWidth-12) / 2 ;
                  final imageHeight = halfWidth / aspectRatio;

                  return Row(
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: aspectRatio,
                          child: Image.file(
                            widget.image,
                            fit: BoxFit.cover, //
                          ),
                        ),
                      ),
                      SizedBox(width: 8), //
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: aspectRatio,
                          child: processedImage != null
                              ? Image.memory(
                            processedImage!,
                            fit: BoxFit.cover, //
                          )
                              : const Center(child: Text('No processed image')),
                        ),
                      ),
                    ],
                  );
                },
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
                                Text('Alpha (Contrast): $_contrast'),
                                Slider(
                                  min: 0.0,
                                  max: 2.0,
                                  value: _contrast,
                                  onChanged: (value) {
                                    setState(() {
                                      _contrast =  (value * 10).round() / 10;
                                    });
                                  },
                                )
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

                    },
                    child: Text('Confirm'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _kernelSize = 3;
                        _sigma = 1.0;
                        _brightness = 0.0;
                        _contrast = 1.0;
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

  Future<Size> _getImageSize(File file) async {
    final completer = Completer<Size>();
    final image = FileImage(file);
    final stream = image.resolve(const ImageConfiguration());

    stream.addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        final mySize = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        );
        completer.complete(mySize);
      }),
    );

    return completer.future;
  }
}