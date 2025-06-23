import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class ImageProcessor {
  static const platform = MethodChannel('com.example.noise_removal');

  //
  static Future<String?> removeNoise(String imagePath, int kernelSize, double sigmaX, bool useMedianBlur) async {
    try {
      final result = await platform.invokeMethod('removeNoise', {
        'imagePath': imagePath,
        'kernelSize': kernelSize,
        'sigmaX': sigmaX,
        'useMedianBlur': useMedianBlur
      });

      if (result != null) {
        return result as String;
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to remove noise: ${e.message}');
        return null;
      }
    }
    return null;
  }
}