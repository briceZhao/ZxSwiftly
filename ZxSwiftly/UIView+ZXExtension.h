//
//  UIView+ZXExtension.h
//  ZXDropMenuView
//
//  Created by brice Mac on 2017/4/3.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZXExtension)

@property (nonatomic, assign) CGFloat zx_x;
@property (nonatomic, assign) CGFloat zx_y;
@property (nonatomic, assign) CGFloat zx_width;
@property (nonatomic, assign) CGFloat zx_height;

@property (nonatomic, assign, readonly) CGFloat zx_maxX;
@property (nonatomic, assign, readonly) CGFloat zx_maxY;
@property (nonatomic, assign, readonly) CGFloat zx_centerX;
@property (nonatomic, assign, readonly) CGFloat zx_centerY;

@property (nonatomic, assign) CGPoint zx_origin;
@property (nonatomic, assign) CGSize zx_size;

/// recurise superview to get UITableViewCell, contains self.
@property (nonatomic, weak, readonly, nullable) UITableViewCell *zx_tableViewCell;

/// lazy load, will automatically add to the sender.
@property (nonatomic, strong, readonly) UITapGestureRecognizer *zx_tapGestureRecognizer;

- (__kindof UIView *(^)(UIColor *))zx_backgroundColor;
- (__kindof UIView *(^)(NSUInteger))zx_backgroundColorHex;

/// layer tricks
- (__kindof UIView *(^)(CGFloat))zx_cornerRadius;
- (__kindof UIView *(^)(CGFloat))zx_borderWidth;
- (__kindof UIView *(^)(CGColorRef))zx_borderColor;


@end

NS_ASSUME_NONNULL_END



