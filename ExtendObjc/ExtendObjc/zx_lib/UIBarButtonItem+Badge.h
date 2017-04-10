//
//  UIBarButtonItem+Badge.h
//  ZXDropMenuView
//
//  Created by brice Mac on 2017/4/9.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Badge)

+ (instancetype)customBarButtonItemWithClick:(void(^)(UIButton *))click;

@end
