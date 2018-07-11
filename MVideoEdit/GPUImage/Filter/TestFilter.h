//
//  TestFilter.h
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/11.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface TestFilter : GPUImageFilter
{
    GLuint opacityUniform;
    
    float count;
}

@end
