#include <jni.h>
#include <opencv2/opencv.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

extern "C" {
    JNIEXPORT void JNICALL
    Java_com_example_treadscan_NativeLib_processImage(JNIEnv *env, jobject thiz, jlong mat_addr, jint kernel_size, jdouble sigma, jstring filter_method, jdouble brightness, jdouble contrast, jfloat skew_x, jfloat skew_y) {

        // OpenCV Mat get object
        cv::Mat &mat = *(cv::Mat *) mat_addr;

        // Filter Method get param
        const char *filter_method_str = env->GetStringUTFChars(filter_method, 0);

        // Gaussian Blur or  Median Filter apply
        cv::Mat result;
        if (strcmp(filter_method_str, "Gaussian") == 0) {
            // Gaussian Blur
            cv::GaussianBlur(mat, result, cv::Size(kernel_size, kernel_size), sigma);
        } else {
            // Median Filter
            cv::medianBlur(mat, result, kernel_size);
        }

        // brightness/ contrast
        result.convertTo(result, -1, contrast, brightness);

        // perspective
        cv::Mat transform_matrix = cv::getRotationMatrix2D(cv::Point2f(result.cols / 2, result.rows / 2), skew_x, 1.0);
        cv::warpAffine(result, result, transform_matrix, result.size());

        // result
        mat = result;

        // JNI release
        env->ReleaseStringUTFChars(filter_method, filter_method_str);
    }
}