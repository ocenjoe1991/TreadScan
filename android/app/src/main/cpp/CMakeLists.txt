cmake_minimum_required(VERSION 3.4.1)


set(OpenCV_DIR "K:/android/treadscan/android/opencv/sdk/native/jni")


find_package(OpenCV REQUIRED)


add_library(native-lib SHARED native-lib.cpp)


target_include_directories(native-lib PRIVATE ${OpenCV_INCLUDE_DIRS})


target_link_libraries(native-lib ${OpenCV_LIBS} log)