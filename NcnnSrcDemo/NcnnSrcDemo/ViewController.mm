//
//  ViewController.m
//  NcnnSrcDemo
//
//  Created by Chris on 2019/3/27.
//  Copyright © 2019 Chris. All rights reserved.
//

#import "net.h"
#import "mat.h"
#import "TestSupport.h"
#import "Test_LoadModelData.h"

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

    /* 自定义 bin 文件加载测试 */
//    [self loadModel_myAnalysis];
}
    
- (void)loadModel_myAnalysis {
    NSString *binPath = [[NSBundle mainBundle] pathForResource:@"squeezenet_v1.1" ofType:@"bin"];
    ts_loadBinFile(binPath);
}

- (void)loadModel {
    
    /* Step1.1 : 加载.parma 文件 */
    NSString *paramPath = [[NSBundle mainBundle] pathForResource:@"squeezenet_v1.1" ofType:@"param"];
    ncnn_net.load_param(paramPath.UTF8String);
    
    /* Step1.2 : 加载.bin 文件 */
    NSString *binPath = [[NSBundle mainBundle] pathForResource:@"squeezenet_v1.1" ofType:@"bin"];
    ncnn_net.load_model(binPath.UTF8String);
}

- (void)detect {
    
    /* Step2.1 : 构建并配置 提取器 */
    ncnn::Extractor extractor = ncnn_net.create_extractor();
    extractor.set_light_mode(true);

    /* Step2.2 : 设置输入（将图片转换成ncnn::Mat结构作为输入） */
    UIImage *srcImage = [UIImage imageNamed:@"mouth"];
    ncnn::Mat mat_src;
    ts_image2mat(mat_src, srcImage);
    extractor.input("data", mat_src);
    
    /* Step2.3 : 提取输出 */
    ncnn::Mat mat_dst;
    extractor.extract("prob", mat_dst);
    
    /* Step3.1 : 结果处理(获取检测概率最高的5种物品，认为存在) */
    NSArray *rstArray = ts_mat2array(mat_dst);
    NSArray *top5Array = ts_topN(rstArray, 5);
    
    /* Step3.2 : 打印输出 */
    NSLog(@"%@", top5Array);
    
    /* 说明：该Demo中发现输出的第一项是 index 为 673 的项目，
     * 在result_info.json中查找下 "index" : "673" 发现对应的描述是 鼠标
     * 也可以换其他图片进行检测，但要将图片规格化成 227 * 227 的大小才可以保证结果的准确性
     */
}

@end
