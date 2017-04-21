//
//  UIView+SeparatorLine.h
//  ZXDropMenuView
//
//  Created by brice Mac on 2017/4/3.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, ZXViewPosition) {
    ZXViewPositionNone = 0,
    ZXViewPositionTop = 1 << 0,
    ZXViewPositionLeft = 1 << 1,
    ZXViewPositionBottom = 1 << 2,
    ZXViewPositionRight = 1 << 3,
    ZXViewPositionAny = ZXViewPositionTop | ZXViewPositionLeft | ZXViewPositionBottom | ZXViewPositionRight,
};

@interface UIView (SeparatorLine)

@property (nonatomic, assign) ZXViewPosition separatorLinePosition;

@end
