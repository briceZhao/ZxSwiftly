//
//  UIView+ZXExtension.m
//  ZXDropMenuView
//
//  Created by brice Mac on 2017/4/3.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#import "UIView+ZXExtension.h"
#import "ZxExtension.h"
#import <objc/runtime.h>

@implementation UIView (ZXExtension)

#pragma mark - Frame

- (CGFloat)zx_x
{
    return self.frame.origin.x;
}

- (void)setZx_x:(CGFloat)zx_x
{
    CGRect frame = self.frame;
    frame.origin.x = zx_x;
    self.frame = frame;
}

- (CGFloat)zx_y
{
    return self.frame.origin.y;
}

- (void)setZx_y:(CGFloat)zx_y
{
    CGRect frame = self.frame;
    frame.origin.y = zx_y;
    self.frame = frame;
}

- (CGFloat)zx_width
{
    return self.frame.size.width;
}

- (void)setZx_width:(CGFloat)zx_width
{
    CGRect frame = self.frame;
    frame.size.width = zx_width;
    self.frame = frame;
}

- (CGFloat)zx_height
{
    return self.frame.size.height;
}

- (void)setZx_height:(CGFloat)zx_height
{
    CGRect frame = self.frame;
    frame.size.height = zx_height;
    self.frame = frame;
}

- (CGFloat)zx_maxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)zx_maxY
{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)zx_centerX
{
    return CGRectGetMidX(self.frame);
}

- (CGFloat)zx_centerY
{
    return CGRectGetMidY(self.frame);
}

- (CGSize)zx_size
{
    return self.frame.size;
}

- (void)setZx_size:(CGSize)zx_size
{
    CGRect frame = self.frame;
    frame.size = zx_size;
    self.frame = frame;
}

- (CGPoint)zx_origin
{
    return self.frame.origin;
}

- (void)setZx_origin:(CGPoint)zx_origin
{
    CGRect frame = self.frame;
    frame.origin = zx_origin;
    self.frame = frame;
}

- (UITapGestureRecognizer *)zx_tapGestureRecognizer
{
    UITapGestureRecognizer *tap = objc_getAssociatedObject(self, _cmd);
    if (tap) return tap;
    
    self.userInteractionEnabled = YES;
    tap = [[UITapGestureRecognizer alloc] init];
    [self addGestureRecognizer:tap];
    objc_setAssociatedObject(self, _cmd, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return tap;
}

#pragma mark - convenient methods

- (UITableViewCell *)zx_tableViewCell
{
    UIView *view = self;
    while (view)
    {
        if ([view isKindOfClass:UITableViewCell.class])
        {
            return (UITableViewCell *)view;
        }
        view = view.superview;
    }
    return nil;
}

#pragma mark - 链式操作

- (__kindof UIView *(^)(UIColor *))zx_backgroundColor
{
    return ^(UIColor *color){
        self.backgroundColor = color;
        return self;
    };
}

- (__kindof UIView *(^)(NSUInteger))zx_backgroundColorHex
{
    return ^(NSUInteger hex){
        self.backgroundColor = [UIColor zx_colorWithHex:hex];
        return self;
    };
}

- (__kindof UIView *(^)(CGFloat))zx_cornerRadius
{
    return ^(CGFloat value){
        self.layer.cornerRadius = value;
        return self;
    };
}

- (__kindof UIView *(^)(CGFloat))zx_borderWidth
{
    return ^(CGFloat value){
        self.layer.borderWidth = value;
        return self;
    };
}

- (__kindof UIView *(^)(CGColorRef))zx_borderColor
{
    return ^(CGColorRef value){
        self.layer.borderColor = value;
        return self;
    };
}

@end
