//
//  UIBarButtonItem+Badge.m
//  ZXDropMenuView
//
//  Created by brice Mac on 2017/4/9.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#import "UIBarButtonItem+Badge.h"
#import "UIView+Badge.h"
#import "ZxExtension.h"
#import <ReactiveObjC.h>

@implementation UIBarButtonItem (Badge)

+ (instancetype)customBarButtonItemWithClick:(void (^)(UIButton *))click
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"bag"];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    btn.adjustsImageWhenHighlighted = YES;
    
    btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id input){
        click(btn);
        return [RACSignal empty];
    }];
    
    
    btn.badgeValue = @"0";
    btn.shouldHideBadgeAtZero = NO;
    btn.shouldAnimateBadge = YES;
    btn.badgeBGColor = [UIColor zx_colorWithHex:0xee7106];
    btn.badgeOriginX = -10;
    btn.badgePadding = 4;
    
    return [[self alloc] initWithCartButton:btn];
}

- (instancetype)initWithCartButton:(UIButton *)button
{
    self = [self initWithCustomView:button];
    if (self)
    {
        
    }
    return self;
}

@end
