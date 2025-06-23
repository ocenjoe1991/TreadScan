#include <jni.h>
#include <opencv2/opencv.hpp>
#include <android/bitmap.h>

using namespace cv;

extern "C"{
    JNIEXPORT jbyteArray JNICALL
    Java_com_example_treadscan_NativeImageProcessor_processImage(
        JNIEnv *env,
        jobject,
        jbyteArray imageData,
        jint noiseMethod,
        jint kernelSize,
        jdouble sigma,
        jdouble brightness,
        jdouble contrast,
        jdouble skewX,
        jdouble skewY) {

    jbyte *data = env->GetByteArrayElements(imageData, nullptr);
    jsize length = env->GetArrayLength(imageData);

    std::vector<uchar> buf(data, data + length);
    Mat inputImage = imdecode(buf, IMREAD_COLOR);
    env->ReleaseByteArrayElements(imageData, data, JNI_ABORT);

    if (inputImage.empty()) {
        return nullptr; //
    }

    //
    if (noiseMethod == 1)
        GaussianBlur(inputImage, inputImage, Size(kernelSize, kernelSize), sigma);

    //
    inputImage.convertTo(inputImage, -1, contrast, brightness );

    //
    Mat skewMat = (Mat_<double>(2,3) << 1, skewX, 0, skewY, 1, 0);
    warpAffine(inputImage, inputImage, skewMat, inputImage.size());

    //
    std::vector<int> compression_params;
    compression_params.push_back(IMWRITE_JPEG_QUALITY);
    compression_params.push_back(95);

    //
    std::vector<uchar> outBuf;
    imencode(".jpg", inputImage, outBuf, compression_params);

    //
    jbyteArray result = env->NewByteArray(outBuf.size());
    env->SetByteArrayRegion(result, 0, outBuf.size(), reinterpret_cast<jbyte*>(outBuf.data()));
    return result;

    }

}