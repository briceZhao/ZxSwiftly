//
//  UINavigationController+ZXExtension.h
//  ZXDropMenuView
//
//  Created by brice Mac on 2017/4/7.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ZXExtension)

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *full_popGestureRecognizer;

@end
