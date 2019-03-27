// Tencent is pleased to support the open source community by making ncnn available.
//
// Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
//
// Licensed under the BSD 3-Clause License (the "License"); you may not use this file except
// in compliance with the License. You may obtain a copy of the License at
//
// https://opensource.org/licenses/BSD-3-Clause
//
// Unless required by applicable law or agreed to in writing, software distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

#include "matmul.h"

namespace ncnn {
    
    DEFINE_LAYER_CREATOR(MatMul)
    
    MatMul::MatMul() {
        one_blob_only = false;
        support_inplace = false;
        support_vulkan = true;
    }
    
    int MatMul::load_param(const ParamDict& pd) {
        return 0;
    }
    
    int MatMul::forward(const std::vector<Mat>& bottom_blobs,
                        std::vector<Mat>& top_blobs,
                        const Option& opt) const {
        
        if (bottom_blobs.size() != 2) {
            return -1;
        }
        
        int w0 = bottom_blobs[0].w;
        int c0 = bottom_blobs[0].c;
        size_t elemsize0 = bottom_blobs[0].elemsize;
        
        int w1 = bottom_blobs[1].w;
        int c1 = bottom_blobs[1].c;
        
        if (c0 != w1) {
            return -1;
        }
        
        int num_output = w0 * c1;
        Mat& top_blob = top_blobs[0];
        top_blob.create(num_output, elemsize0, opt.blob_allocator);
        if (top_blob.empty()) {
            return -100;
        }
        
        for (int p = 0; p < num_output; p++) {
            float sum = 0.f;
            for (int q = 0; q < c0; q++) {
                const float* b0 = bottom_blobs[0].channel(q);   // 128*1*37
                const float* b1 = bottom_blobs[1].channel(0);   // 37*1*1
                sum += b0[p] * b1[q];
            }
            
            top_blob[p] = sum;
        }
        
        return 0;
    }
    
} // namespace ncnn
