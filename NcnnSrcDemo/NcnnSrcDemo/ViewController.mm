//
//  ViewController.m
//  NcnnSrcDemo
//
//  Created by Chris on 2019/3/27.
//  Copyright © 2019 Chris. All rights reserved.
//

#import "net.h"
#import "mat.h"

#import "ViewController.h"

@interface ViewController () {
    ncnn::Net ncnn_net;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadModel];
    [self detect];
}

- (void)loadModel {
    
    NSString *paramPath = [[NSBundle mainBundle] pathForResource:@"squeezenet_v1.1" ofType:@"param"];
    NSString *binPath = [[NSBundle mainBundle] pathForResource:@"squeezenet_v1.1" ofType:@"bin"];
    
    /* Step1.1 : 加载.parma 文件 */
    ncnn_net.load_param(paramPath.UTF8String);
    
    /* Step1.2 : 加载.bin 文件 */
    ncnn_net.load_model(binPath.UTF8String);
}

- (void)detect {
    
    /* Step2.1 : 构建并配置 提取器 */
    ncnn::Extractor extractor = ncnn_net.create_extractor();
    extractor.set_light_mode(true);

    /* Step2.2 : 设置输入（将图片转换成ncnn::Mat结构作为输入） */
    UIImage *srcImage = [UIImage imageNamed:@"mouth"];
    ncnn::Mat mat_src;
    [self __fillNcnnMat:mat_src withImage:srcImage];
    extractor.input("data", mat_src);
    
    /* Step2.3 : 提取输出 */
    ncnn::Mat mat_dst;
    extractor.extract("prob", mat_dst);
    
    /* Step3.1 : 结果处理(获取检测概率最高的5种物品，认为存在) */
    NSArray *rstArray = [self __arrayFromMat:mat_dst];
    NSArray *top5Array = [self __top5ArrayFromArray:rstArray];
    
    /* Step3.2 : 打印输出 */
    NSLog(@"%@", top5Array);
    
    /* 说明：该Demo中发现输出的第一项是 index 为 673 的项目，
     * 在result_info.json中查找下 "index" : "673" 发现对应的描述是 鼠标
     * 也可以换其他图片进行检测，但要将图片规格化成 227 * 227 的大小才可以保证结果的准确性
     */
}

#pragma mark - MISC

- (void)__fillNcnnMat:(ncnn::Mat &)tarMat withImage:(UIImage *)inputImage {
    
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
    
    tarMat = ncnn::Mat::from_pixels(rgba, ncnn::Mat::PIXEL_RGBA2BGR, w, h);
    free((unsigned char *)rgba);
}

- (NSArray *)__arrayFromMat:(ncnn::Mat &)inputMat {
    
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

- (NSArray *)__top5ArrayFromArray:(NSArray *)inputArray {
    
    NSArray *sortArray =
    [inputArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        NSComparisonResult ret =
        ([obj1[@"value"] floatValue] > [obj2[@"value"] floatValue]) ? NSOrderedAscending : NSOrderedDescending;
        return ret;
    }];
    
    return [sortArray subarrayWithRange:NSMakeRange(0, 5)];
}

@end
