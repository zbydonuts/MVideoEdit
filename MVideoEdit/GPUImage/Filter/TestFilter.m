//
//  TestFilter.m
//  MVideoEdit
//
//  Created by 朱　冰一 on 2018/07/11.
//  Copyright © 2018年 zhu.bingyi. All rights reserved.
//
#import "TestFilter.h"
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageGiftFilterShaderString = SHADER_STRING
(
 
 precision highp float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform vec2 uResolution;
 uniform float time;
 uniform float opacity;
 
 void main()
{
    
//    highp vec2 leftTextureCoordinate = textureCoordinate;
//    leftTextureCoordinate.x = leftTextureCoordinate.x * 0.5;
//    highp vec2 rightTextureCoordinate = textureCoordinate;
//    rightTextureCoordinate.x = rightTextureCoordinate.x * 0.5 + 0.5;
//
//    highp vec2 thirdTextureCoordinate = rightTextureCoordinate;
//    thirdTextureCoordinate.y = rightTextureCoordinate.y;
//
//    highp vec2 profileCoordinate = vec2(0.0, 0.0);
//    lowp vec4 rgbColor = texture2D(inputImageTexture, leftTextureCoordinate);
//    lowp vec4 alphaValue = texture2D(inputImageTexture, rightTextureCoordinate);
//
//    lowp vec3 gray = vec3(0.299, 0.587, 0.114);
//
//    gl_FragColor.rgb = mix(rgbColor.rgb, vec3(0.0, 0.0, 0.0), 1.0 - alphaValue.r);
//    gl_FragColor.a = alphaValue.r;
    
    lowp vec4 rgbColor = texture2D(inputImageTexture, textureCoordinate);
    rgbColor.r = opacity;
//    rgbColor.g = 1.0 - rgbColor.g;
//    rgbColor.b = 1.0 - rgbColor.b;
    gl_FragColor.rgb = rgbColor.rgb;
//    gl_FragColor.a = opacity;
}
 
 );
#else
#endif
@implementation TestFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageGiftFilterShaderString]))
    {
        return nil;
    }
    count = 0;
    opacityUniform = [filterProgram uniformIndex:@"opacity"];
    return self;
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates
{
    count += 0.01;
    count = MIN(1.0, count);
    [self setFloat:count forUniform:opacityUniform program: filterProgram];
    [super renderToTextureWithVertices:vertices textureCoordinates:textureCoordinates];
}

@end
