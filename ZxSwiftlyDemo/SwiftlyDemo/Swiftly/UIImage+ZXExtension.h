//
//  UIImage+ZXExtension.h
//  ZXDropMenuView
//
//  Created by brice Mac on 2017/4/5.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZXExtension)

- (UIImage *)zx_centerResizingImage;

/// 给 UIImage 添加 radius 大小的圆角 (注意: 不适合用于大图的圆角处理)
- (UIImage *)zx_cornerAddRadius:(CGFloat)radius andSize:(CGSize)size;

/// 给 UIImage 添加 radius 大小的圆角和 1px 边框
- (UIImage *)zx_cornerAddRadius:(CGFloat)radius andSize:(CGSize)size borderColor:(UIColor *)color;

/// 中间透明, 1px边框
+ (UIImage *)zx_borderImageWithColor:(UIColor *)color;

+ (UIImage *)zx_imageWithColor:(UIColor *)color size:(CGSize)size ellipse:(BOOL)ellipse;
+ (UIImage *)zx_imageWithColor:(UIColor *)color; // (1, 1), no ellipse.

- (CGSize)zx_sizeThatFitWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
