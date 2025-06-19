#include <jni.h>
#include <opencv2/opencv.hpp>

extern "C" {
    JNIEXPORT jbyteArray JNICALL
    Java_com_example_treadscan_NativeLib_processImage(JNIEnv *env, jobject /* this */, jbyteArray inputImageBytes) {
        // inputImageBytes -> cv::Mat
        jbyte* bytes = env->GetByteArrayElements(inputImageBytes, NULL);
        jsize length = env->GetArrayLength(inputImageBytes);
        std::vector<uchar> buffer(bytes, bytes + length);
        env->ReleaseByteArrayElements(inputImageBytes, bytes, 0);

        cv::Mat img = cv::imdecode(buffer, cv::IMREAD_COLOR);
        if (img.empty()) return NULL;

        // OpenCV GaussianBlur
        cv::GaussianBlur(img, img, cv::Size(5,5), 0);

        //  (alpha , beta)
        double alpha = 1.2; //
        int beta = 10;
        img.convertTo(img, -1, alpha, beta);

        //
        std::vector<uchar> outBuf;
        cv::imencode(".jpg", img, outBuf);

        jbyteArray outputArray = env->NewByteArray(outBuf.size());
        env->SetByteArrayRegion(outputArray, 0, outBuf.size(), reinterpret_cast<jbyte*>(outBuf.data()));

        return outputArray;
    }
}
