# Install script for directory: /Users/yangyifan/Documents/workingcopys/Ncnn/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/Users/yangyifan/Documents/workingcopys/Ncnn/build-ios/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/Users/yangyifan/Documents/workingcopys/Ncnn/build-ios/src/libncnn.a")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libncnn.a" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libncnn.a")
    execute_process(COMMAND "ranlib" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libncnn.a")
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "/Users/yangyifan/Documents/workingcopys/Ncnn/src/allocator.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/src/blob.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/src/command.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/src/cpu.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/src/gpu.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/src/layer.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/src/layer_type.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/src/mat.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/src/modelbin.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/src/net.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/src/opencv.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/src/paramdict.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/src/pipeline.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/src/benchmark.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/build-ios/src/layer_type_enum.h"
    "/Users/yangyifan/Documents/workingcopys/Ncnn/build-ios/src/platform.h"
    )
endif()

