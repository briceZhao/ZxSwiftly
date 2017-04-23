//
//  UIScreen+ZXExtension.m
//  ZXDropMenuView
//
//  Created by brice Mac on 2017/4/5.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#import "UIScreen+ZXExtension.h"

@implementation UIScreen (ZXExtension)

+ (float)screenW
{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (float)screenH
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (float)scale
{
    return [UIScreen mainScreen].scale;
}

+ (CGRect)bounds
{
    return [UIScreen mainScreen].bounds;
}

+ (BOOL)isRetina
{
    return [UIScreen mainScreen].scale >= 2;
}

@end
