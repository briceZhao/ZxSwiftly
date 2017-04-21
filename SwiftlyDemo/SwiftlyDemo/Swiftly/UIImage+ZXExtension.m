//
//  UIImage+ZXExtension.m
//  ZXDropMenuView
//
//  Created by brice Mac on 2017/4/5.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#import "UIImage+ZXExtension.h"
#import "ZxExtension.h"

@implementation UIImage (ZXExtension)

- (CGSize)zx_sizeThatFitWidth:(CGFloat)width
{
    CGSize size = self.size;
    return CGSizeMake(width, floor(width / size.width) * size.height);
}

#pragma mark - add corner radius -
- (UIImage *)zx_cornerAddRadius:(CGFloat)radius andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    
    CGContextAddPath(ctx,path.CGPath);
    
    CGContextClip(ctx);
    
    [self drawInRect:rect];
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *)zx_cornerAddRadius:(CGFloat)radius andSize:(CGSize)size borderColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    [bezier setLineWidth:1.0 / [UIScreen scale]];
    
    CGContextAddPath(context, bezier.CGPath);
    
    CGContextClip(context);
    
    [self drawInRect:rect];
    [color setStroke];
    
    [bezier stroke];
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (UIImage *)zx_centerResizingImage
{
    CGSize size = self.size;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(floor(size.height / 2.f),
                                           floor(size.width / 2.f),
                                           floor(size.height / 2.f),
                                           floor(size.width / 2.f));
    return [self resizableImageWithCapInsets:insets];
}

+ (UIImage *)zx_imageWithColor:(UIColor *)color size:(CGSize)size ellipse:(BOOL)ellipse
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    if (ellipse)
    {
        CGContextAddEllipseInRect(context, rect);
    }
    else
    {
        CGContextAddRect(context, rect);
    }
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)zx_imageWithColor:(UIColor *)color
{
    return [self zx_imageWithColor:color size:CGSizeMake(1.f, 1.f) ellipse:NO];
}

#pragma mark - border

+ (UIImage *)zx_borderImageWithColor:(UIColor *)color
{
    CGSize size = CGSizeMake(3, 3);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.f);
    
    [color setStroke];
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
