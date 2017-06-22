//
//  ZXDropMenuItem.m
//  ZXDropMenuView
//
//  Created by brice Mac on 2017/4/3.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#import "ZXDropMenuItem.h"

@implementation ZXDropMenuItem


@synthesize itemClickSignal = _itemClickSignal;

- (instancetype)initWithTitle:(NSString *)title options:(NSArray<NSString *> *)options image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    return [self initWithTitle:title options:options image:image selectedImage:selectedImage initialOptionIndex:0];
}

- (instancetype)initWithTitle:(NSString *)title options:(NSArray<NSString *> *)options image:(UIImage *)image selectedImage:(UIImage *)selectedImage initialOptionIndex:(NSUInteger)initialOptionIndex
{
    self = [super init];
    if (self)
    {
        _title = [title copy];
        _options = [options copy];
        _image = image;
        _selectedImage = selectedImage;
        _selectedOptionIndex = initialOptionIndex;
    }
    return self;
}

- (RACSignal<ZXDropMenuItem *> *)itemClickSignal
{
    if (!_itemClickSignal)
    {
        _itemClickSignal = [RACSubject subject];
    }
    return _itemClickSignal;
}



@end



