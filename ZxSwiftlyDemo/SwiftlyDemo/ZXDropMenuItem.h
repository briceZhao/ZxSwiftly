//
//  ZXDropMenuItem.h
//  ZXDropMenuView
//
//  Created by brice Mac on 2017/4/3.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXDropMenuItem : NSObject

/// initial option index is 0
- (instancetype)initWithTitle:(NSString *)title
                      options:(nullable NSArray<NSString *> *)options
                        image:(UIImage *)image
                selectedImage:(nullable UIImage *)selectedImage;

- (instancetype)initWithTitle:(NSString *)title
                      options:(nullable NSArray<NSString *> *)options
                        image:(UIImage *)image
                selectedImage:(nullable UIImage *)selectedImage
           initialOptionIndex:(NSUInteger)initialOptionIndex NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, readonly, strong) RACSignal<ZXDropMenuItem *> *itemClickSignal;

@property (nonatomic, readonly, assign) NSUInteger selectedOptionIndex;

@property (nonatomic, readonly, copy) NSString *title;

@property (nonatomic, readonly, copy, nullable) NSArray<NSString *> *options;

@property (nonatomic, readonly, strong) UIImage *image;

@property (nonatomic, readonly, strong) UIImage *selectedImage;


@property (nonatomic, assign) BOOL usingOptionAsTitle;

@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END


