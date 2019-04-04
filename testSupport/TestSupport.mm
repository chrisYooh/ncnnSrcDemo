//
//  TestSupport.mm
//  NcnnSrcDemo_MoltenVK
//
//  Created by Chris on 2019/4/4.
//  Copyright © 2019 Chris. All rights reserved.
//

#include "TestSupport.h"

void ts_load_model(ncnn::Net &inputNet) {
    NSString *paramPath = [[NSBundle mainBundle] pathForResource:@"squeezenet_v1.1" ofType:@"param"];
    NSString *binPath = [[NSBundle mainBundle] pathForResource:@"squeezenet_v1.1" ofType:@"bin"];
    inputNet.load_param(paramPath.UTF8String);
    inputNet.load_model(binPath.UTF8String);
}

void ts_image2mat(ncnn::Mat &outMat, UIImage *inputImage) {
    
    int w = inputImage.size.width;
    int h = inputImage.size.height;
    int c = 4;
    
    unsigned char * rgba = (unsigned char *)malloc(w * h * c);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(inputImage.CGImage);
    CGBitmapInfo bitmapInfo = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault;
    CGContextRef contextRef =
    CGBitmapContextCreate(
                          rgba,         /* data */
                          w,            /* Widht */
                          h,            /* Height */
                          8,            /* bitsPerComponent */
                          w * c,        /* BytesPerRow */
                          colorSpace,   /* ColorSpace */
                          bitmapInfo    /* bitmapInfo */
                          );
    CGContextDrawImage(contextRef, CGRectMake(0, 0, inputImage.size.width, inputImage.size.height), inputImage.CGImage);
    CGContextRelease(contextRef);
    
    outMat = ncnn::Mat::from_pixels(rgba, ncnn::Mat::PIXEL_RGBA2BGR, w, h);
    free((unsigned char *)rgba);
}

void ts_detect(ncnn::Mat &outputMat, ncnn::Net &inputNet) {
    
    /* 构建并配置 提取器 */
    ncnn::Extractor extractor = inputNet.create_extractor();
    extractor.set_light_mode(true);
    
    /* 设置输入（将图片转换成ncnn::Mat结构作为输入） */
    UIImage *srcImage = [UIImage imageNamed:@"mouth"];
    ncnn::Mat mat_src;
    ts_image2mat(mat_src, srcImage);
    extractor.input("data", mat_src);
    
    /* 提取输出 */
    extractor.extract("prob", outputMat);
}

void ts_print_mat(ncnn::Mat &inputMat) {
    
    float *p_data = &inputMat[0];
    for (int c = 0; c < inputMat.c; c++) {
        printf("ccccccccccccccccccc %d ccccccccccccccccccc\n", c);
        for (int h = 0; h < inputMat.h; h++) {
            printf("hhhhhhhhhhhhhhhhhhh %d hhhhhhhhhhhhhhhhhhh\n", h);
            for (int w = 0; w < (inputMat.w / 4 + 1) * 4; w++) {
                printf("%d %.6f\n", w, *p_data);
                p_data++;
            }
        }
    }
    
    printf("c:%d, h:%d, w:%d, cStep:%d\n",
           inputMat.c, inputMat.h, inputMat.w, (int)inputMat.cstep);
}

NSArray * ts_mat2array(ncnn::Mat &inputMat) {
    
    NSMutableArray *tmpMulArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < inputMat.w * inputMat.h * inputMat.c; i++) {
        NSDictionary *tmpDic =
        @{
            @"index": @(i),
            @"value": @(inputMat[i])
        };
        [tmpMulArray addObject:tmpDic];
    }
    
    return tmpMulArray.copy;
}

NSArray * ts_topN(NSArray *inputArray, int n) {
    
    if (inputArray.count <= 0) {
        return nil;
    }
    
    if (n >= inputArray.count) {
        n = (int)(inputArray.count - 1);
    }
    
    NSArray *sortArray =
    [inputArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
     NSComparisonResult ret =
     ([obj1[@"value"] floatValue] > [obj2[@"value"] floatValue]) ? NSOrderedAscending : NSOrderedDescending;
     return ret;
     }];
    
    return [sortArray subarrayWithRange:NSMakeRange(0, n)];
}

