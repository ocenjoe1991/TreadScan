cmake_minimum_required(VERSION 3.10.2)

# OpenCV SDK path
set(OpenCV_DIR "K:/android/treadscan/android/opencv/sdk/native/jni")

# OpenCV header path
include_directories(${OpenCV_DIR}/include)

# navtiv
add_library(native-lib SHARED native-lib.cpp)

# OpenCV libirary
add_library(opencv_java4 SHARED IMPORTED)

# ABI  OpenCV .so
set_target_properties(opencv_java4 PROPERTIES IMPORTED_LOCATION
        "K:/android/treadscan/android/opencv/sdk/native/libs/${ANDROID_ABI}/libopencv_java4.so"
)

# native-lib OpenCV , Android log
target_link_libraries(native-lib opencv_java4 log)