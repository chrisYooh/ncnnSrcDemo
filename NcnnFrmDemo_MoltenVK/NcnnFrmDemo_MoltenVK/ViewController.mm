//
//  ViewController.m
//  NcnnFrmDemo_MoltenVK
//
//  Created by Chris on 2019/4/4.
//  Copyright © 2019 Chris. All rights reserved.
//

#import "TestSupport.h"
#import "ViewController.h"

#define __USE_VULKAN        1

@interface ViewController () {
    ncnn::Net ncnn_net;
}

@end

@implementation ViewController

- (void)dealloc {
#if __USE_VULKAN
    ncnn::destroy_gpu_instance();
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
#if __USE_VULKAN
    ncnn::create_gpu_instance();
    ncnn_net.use_vulkan_compute = 1;
#endif
    
    ts_load_model(ncnn_net);
    [self detect];
}

#pragma mark -

- (void)detect {
    
    /* 提取输出 */
    ncnn::Mat mat_dst;
    ts_detect(mat_dst, ncnn_net);
    
    /* 输出规范化 */
    NSArray *rstArray = ts_mat2array(mat_dst);
    NSArray *top5Array = ts_topN(rstArray, 5);
    
    /* 打印输出 */
    NSLog(@"%@", top5Array);
}

@end
