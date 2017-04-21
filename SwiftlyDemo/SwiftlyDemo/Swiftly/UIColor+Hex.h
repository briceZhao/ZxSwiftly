//
//  UIColor+Hex.h
//  RACDemo
//
//  Created by brice Mac on 2017/4/1.
//  Copyright © 2017年 brice Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

+ (UIColor *)zx_colorWithHex:(NSUInteger)hex;

/**
 UIColor with hex string, Optionally prefixed with '0x' or '0X'.
 @see [NSScanner scanHexLongLong:]
 
 @param hexString the hex string
 @return the color
 */
+ (UIColor *)zx_colorWithHexString:(NSString *)hexString;


- (NSUInteger)zx_hex;
- (NSString *)zx_hexString;

@end

NS_ASSUME_NONNULL_END
