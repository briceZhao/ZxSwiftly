//
//  ZXDropMenuView.h
//  ZXDropMenuView
//
//  Created by brice Mac on 2017/4/3.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXDropMenuItem;

@interface ZXDropMenuView : UIView

@property (nonatomic, copy) NSArray<ZXDropMenuItem *> *items;

// call it initiatively if dealloc
- (void)dismissDropMenuWithAnimated:(BOOL)animated;

@end
