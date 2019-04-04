//
//  TestSupport.h
//  NcnnSrcDemo_MoltenVK
//
//  Created by Chris on 2019/4/4.
//  Copyright © 2019 Chris. All rights reserved.
//

#ifndef TestSupport_hpp
#define TestSupport_hpp

#include <UIKit/UIKit.h>
#ifdef NSD_SOURCE
#import "net.h"
#import "mat.h"
#else
#import <ncnn/net.h>
#import <ncnn/mat.h>
#endif

#endif /* TestSupport_hpp */

/* 加载对象检测模型 */
void ts_load_model(ncnn::Net &inputNet);

/* 将UIImage转化成Mat */
void ts_image2mat(ncnn::Mat &outMat, UIImage *inputImage);

/* 对默认图片进行对象检测，并输出检测结果（ncnn::Mat) */
void ts_detect(ncnn::Mat &outputMat, ncnn::Net &inputNet);

/* 打印ncnn::Mat信息 */
void ts_print_mat(ncnn::Mat &inputMat);

/* 将ncnn::Mat 转化为 NSArray */
NSArray * ts_mat2array(ncnn::Mat &inputMat);

/* 去 value 最大的 n 个 arrayItem */
NSArray * ts_topN(NSArray *inputArray, int n);

