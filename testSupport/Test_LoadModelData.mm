//
//  Test_LoadModelData.m
//  NcnnSrcDemo
//
//  Created by Chris on 2019/4/8.
//  Copyright © 2019 Chris. All rights reserved.
//

#import "Test_LoadModelData.h"

#pragma mark -

const void * __log_binInfo_data(const void *dataOffset) {
    printf("\n【data】层类型为【Input】，没有数据参数\n");
    return dataOffset;
}

const void * __log_binInfo_conv1(const void *dataOffset) {
    printf("\n【conv1】层类型为【Convolution】(卷积层)\n"
          "参数配置 0=64 1=3 2=1 3=2 4=0 5=1 6=1728，即：\n"
          "输出单元 数量: 64\n"
          "核 大小: 3, 3\n"
          "核 膨胀: 2, 2\n"
          "Pad 大小: 0, 0\n"
          "是否有偏置项: 1(是)\n"
          "权重数据 数量: 1728 (= 3(核高) * 3(核宽) * 3(RGB三通道) * 64(输出单元数量)\n");
    
    printf("\n【conv1】Load1_1: 加载weight_data数据类型标志（固定为自动类型）\n");
    unsigned char *p_load1_1 = (unsigned char *)dataOffset;
    for (int i = 0; i < 4; i++) {
        printf("Flag %d : %d\n", i, p_load1_1[i]);
    }
    p_load1_1 += 4;
    
    printf("\n【conv1】Load1_2: 加载weight_data数据（1728项，自动为float32类型）\n");
    float *p_load1_2 = (float *)p_load1_1;
    for (int i = 0; i < 1728; i++) {
        if (i < 10 || i > 1720) {
            printf("Weight %d : %.9f\n", i, p_load1_2[i]);
        }
    }
    p_load1_2 += 1728;
    
    printf("\n【conv1】Load2: 加载bias偏置数据（64项，固定为float32类型）\n");
    float *p_load2 = (float *)p_load1_2;
    for (int i = 0; i < 64; i++) {
        if (i < 5 || i > 60) {
            printf("Bias %d : %.9f\n", i, p_load2[i]);
        }
    }
    p_load2 += 64;
    
    return p_load2;
}

const void * __log_binInfo_relu_conv1(const void *dataOffset) {
    printf("\n【relu_conv1】层类型为【ReLU】，没有数据参数\n");
    return dataOffset;
}

const void * __log_binInfo_pool1(const void *dataOffset) {
    printf("\n【pool1】层类型为【Pooling】，没有数据参数\n");
    return dataOffset;
}

const void * __log_binInfo_fire2_squeeze1x1(const void *dataOffset) {
    printf("\n【fire2/squeeze1x1】层类型为【Convolution】，没有数据参数\n"
           "参数配置 0=16 1=1 2=1 3=1 4=0 5=1 6=1024，即：\n"
           "输出单元 数量: 16\n"
           "核 大小: 1, 1\n"
           "核 膨胀: 1, 1\n"
           "步长: 1, 1\n"
           "Pad 大小: 0, 0\n"
           "是否有偏置项: 1(是)\n"
           "权重数据 数量: 1024 (= 1(核高) * 1(核宽) * 64(组) * 16(输出单元数量)\n");
    
    printf("\n【fire2/squeeze1x1】Load1_1: 加载weight_data数据类型标志（固定为自动类型）\n");
    unsigned char *p_load1_1 = (unsigned char *)dataOffset;
    for (int i = 0; i < 4; i++) {
        printf("Flag %d : %d\n", i, p_load1_1[i]);
    }
    p_load1_1 += 4;
    
    printf("\n【fire2/squeeze1x1】Load1_2: 加载weight_data数据（1024项，自动为float32类型）\n");
    float *p_load1_2 = (float *)p_load1_1;
    for (int i = 0; i < 1024; i++) {
        if (i < 10 || i > 1015) {
            printf("Weight %d : %.9f\n", i, p_load1_2[i]);
        }
    }
    p_load1_2 += 1024;
    
    printf("\n【fire2/squeeze1x1】Load2: 加载bias偏置数据（16项，固定为float32类型）\n");
    float *p_load2 = (float *)p_load1_2;
    for (int i = 0; i < 16; i++) {
        printf("Bias %d : %.9f\n", i, p_load2[i]);
    }
    p_load2 += 16;
    
    return p_load2;
}

void __log_binInfo_final(void) {
    printf("\n不再具体分析每一层的Bin信息解读，起码我们了解到：\n"
           "1. Bin文件实际就是二进制数据的直接存储\n"
           "2. 有些层可能不需要Bin文件存储数据\n"
           "3. 不同层存储在Bin文件中的数据内容和结构是不同的。");
}

void ts_loadBinFile(NSString *binFilePath) {
    
    NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:binFilePath];
    
    const void *p_offset = fileData.bytes;
    
    p_offset = __log_binInfo_data(p_offset);
    p_offset = __log_binInfo_conv1(p_offset);
    p_offset = __log_binInfo_relu_conv1(p_offset);
    p_offset = __log_binInfo_pool1(p_offset);
    p_offset = __log_binInfo_fire2_squeeze1x1(p_offset);
    __log_binInfo_final();
}
