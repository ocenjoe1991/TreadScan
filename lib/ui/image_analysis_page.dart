import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async'; // Completer
import 'package:flutter/services.dart';

class ImageAnalysisPage extends StatefulWidget {
  final Uint8List image;

  const ImageAnalysisPage({super.key, required this.image});

  @override
  State<ImageAnalysisPage> createState() => _ImageAnalysisPageState();
}

class _ImageAnalysisPageState extends State<ImageAnalysisPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Uint8List? processedImage;

  final TextEditingController depthController = TextEditingController();
  final TextEditingController carTypeController = TextEditingController();
  final TextEditingController tireSizeController = TextEditingController();
  final TextEditingController tireBrandController = TextEditingController();

  int    kernelSize = 3;
  int    noiseMethod = 1;
  double sigma = 10;
  double brightness = 0;
  double contrast = 1;
  double skewX = 0;
  double skewY = 0;

  final List<String> noiseMethods = ['Gaussian', 'Median', 'Bilateral'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    processedImage = widget.image;
  }

  Future<void> preprocessImage() async{

    final imageBytes = await widget.image;

    const platform = MethodChannel('image_processor');

    try {
      final Uint8List result = await platform.invokeMethod('processImage', {
        'image': imageBytes,
        'noiseMethod': noiseMethod,
        'kernelSize': kernelSize,
        'sigma': sigma,
        'brightness': brightness.toDouble(),
        'contrast': contrast.toDouble(),
        'skewX': skewX,
        'skewY': skewY,
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

  void applyAnalysis() {
    //
    Navigator.pop(context, {
      'image': processedImage,
      'depth': depthController.text,
      'carType': carTypeController.text,
      'tireSize': tireSizeController.text,
      'tireBrand': tireBrandController.text,
    });
  }

  void cancelAnalysis() {
    Navigator.pop(context);
  }

  Widget buildSlider(String label, double value, double min, double max, void Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(2)}'),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analysed Image')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Original Image'),
                        Expanded(child: Image.memory(widget.image)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Processed Image'),
                        Expanded(child: Image.memory(processedImage!)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Analysis Result'),
                Tab(text: 'Image Preprocess'),
              ],
            ),
            Expanded(
              flex: 3,
              child: TabBarView(
                controller: _tabController,
                children: [
                  //
                  ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      TextField(
                        controller: depthController,
                        decoration: const InputDecoration(labelText: 'Depth (mm)'),
                      ),
                      TextField(
                        controller: carTypeController,
                        decoration: const InputDecoration(labelText: 'Car Type'),
                      ),
                      TextField(
                        controller: tireSizeController,
                        decoration: const InputDecoration(labelText: 'Tier Size'),
                      ),
                      TextField(
                        controller: tireBrandController,
                        decoration: const InputDecoration(labelText: 'Tier Brand'),
                      ),
                    ],
                  ),
                  //
                  ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      DropdownButtonFormField<int>(
                        value: noiseMethod,
                        decoration: const InputDecoration(labelText: 'Remove Noise Method'),
                        items: [
                          DropdownMenuItem(value: 1, child: Text('Gaussian')),
                          DropdownMenuItem(value: 2, child: Text('Median')),
                          DropdownMenuItem(value: 3, child: Text('Bilateral')),
                        ],
                        onChanged: (int? value) {
                          if (value != null) {
                            setState(() {
                              noiseMethod = value;
                            });
                          }
                        },
                      ),
                      Row(
                        children: [
                          Expanded(child: DropdownButtonFormField<int>(
                            value: kernelSize,
                            decoration: const InputDecoration(labelText: 'Kernel Size'),
                            items: [3, 5, 7, 9, 11]
                                .map((value) => DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  kernelSize = value;
                                });
                              }
                            },
                          ),),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Sigma: ${sigma.toStringAsFixed(1)}'),
                              Slider(
                                value: sigma,
                                min: 10,
                                max: 150,
                                divisions: 140,
                                label: sigma.toStringAsFixed(1),
                                onChanged: (val) => setState(() => sigma = val),
                              ),
                            ],
                          ),),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded( child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Brightness: ${brightness.toStringAsFixed(1)}'),
                              Slider(
                                value: brightness.toDouble(),
                                min: -100,
                                max: 100,
                                divisions: 200,
                                label: brightness.toStringAsFixed(1),
                                onChanged: (val) {
                                  setState(() {
                                    brightness = val;
                                  });
                                },
                              ),
                            ],
                          ),),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Contrast: ${contrast.toStringAsFixed(1)}'),
                              Slider(
                                value: contrast.toDouble(),
                                min: 0.1,
                                max: 3.0,
                                divisions: 29,
                                label: contrast.toStringAsFixed(1),
                                onChanged: (val) {
                                  setState(() {
                                    contrast = val;
                                  });
                                },
                              ),
                            ],
                          ),),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: buildSlider('Skew X', skewX, -1, 1, (val) => setState(() => skewX = val))),
                          Expanded(child: buildSlider('Skew Y', skewY, -1, 1, (val) => setState(() => skewY = val))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: preprocessImage, child: const Text('Preprocessing Image')),
                ElevatedButton(onPressed: applyAnalysis, child: const Text('Analysis')),
                ElevatedButton(onPressed: cancelAnalysis, child: const Text('Cancel')),
              ],
            )
          ],
        ),
      ),
    );
  }
}