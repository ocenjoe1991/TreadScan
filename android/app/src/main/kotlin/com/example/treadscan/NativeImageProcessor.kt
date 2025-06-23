package com.example.treadscan

object NativeImageProcessor {
    init {
        System.loadLibrary("native-lib")
    }

    external fun processImage(
        image: ByteArray,
        noiseMethod: Int,
        kernelSize: Int,
        sigma: Double,
        brightness: Double,
        contrast: Double,
        skewX: Double,
        skewY: Double
    ): ByteArray
}