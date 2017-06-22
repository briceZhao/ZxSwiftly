//
//  UIView+SeparatorLine.m
//  ZXDropMenuView
//
//  Created by brice Mac on 2017/4/3.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import "UIView+SeparatorLine.h"
#import <objc/runtime.h>
#import <UIView+ZXExtension.h>
#import <Masonry.h>

@implementation UIView (SeparatorLine)

static void* kSeparatorLinePosition = &kSeparatorLinePosition;

- (ZXViewPosition)separatorLinePosition
{
    return [objc_getAssociatedObject(self, kSeparatorLinePosition) integerValue];
}

- (void)setSeparatorLinePosition:(ZXViewPosition)separatorLinePosition
{
    ZXViewPosition positionArray[4];
    positionArray[0] = ZXViewPositionTop;
    positionArray[1] = ZXViewPositionLeft;
    positionArray[2] = ZXViewPositionBottom;
    positionArray[3] = ZXViewPositionRight;
    
    for (NSInteger i = 0; i < 4; i ++) {
        ZXViewPosition position = positionArray[i];
        UIView *line = [self seperator_lineAtPosition:position];
        if (position & separatorLinePosition)
        {
            if (!line)
            {
                UIView *line = [[UIView alloc] init].zx_backgroundColorHex(0xe6e6e6);
                [self addSubview:line];
                [self setSeparatorLine:line atPosition:position];
                [line makeConstraints:^(MASConstraintMaker *make) {
                    if (position == ZXViewPositionTop || position == ZXViewPositionBottom)
                    {
                        make.leading.trailing.equalTo(self);
                        make.height.equalTo(1.0);
                        if (position == ZXViewPositionTop)
                        {
                            make.top.equalTo(self);
                        }
                        else
                        {
                            make.bottom.equalTo(self);
                        }
                    }
                    else
                    {
                        make.top.bottom.equalTo(self);
                        make.width.equalTo(1.0);
                        if (position == ZXViewPositionLeft)
                        {
                            make.left.equalTo(self);
                        }
                        else
                        {
                            make.right.equalTo(self);
                        }
                    }
                }];
            }
        }
        else
        {
            if (line)
            {
                [line removeFromSuperview];
            }
        }
    }
}

- (const void *)seperator_keyForPosition:(ZXViewPosition)pos
{
    static void *kTop = &kTop;
    static void *kLeft = &kLeft;
    static void *kBottom = &kBottom;
    static void *kRight = &kRight;
    
    if (pos == ZXViewPositionTop)
    {
        return kTop;
    }
    else if (pos == ZXViewPositionLeft)
    {
        return kLeft;
    }
    else if (pos == ZXViewPositionRight)
    {
        return kRight;
    }
    else
    {
        return kBottom;
    }
}

- (UIView *)seperator_lineAtPosition:(ZXViewPosition)position
{
    return objc_getAssociatedObject(self, [self seperator_keyForPosition:position]);
}

- (void)setSeparatorLine:(UIView *)line atPosition:(ZXViewPosition)position
{
    objc_setAssociatedObject(self, [self seperator_keyForPosition:position], line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
