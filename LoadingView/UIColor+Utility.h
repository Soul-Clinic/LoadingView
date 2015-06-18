//
//  UIColor+Utility.h
//  Instantly
//
//  Created by Can EriK Lu on 7/23/14.
//  Copyright (c) 2014 App With Love. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utility)

- (BOOL)isEqualToColor:(UIColor*)color;

- (UIImage*)image;

- (CGFloat)darkFactor;


- (instancetype)blendWithColor:(UIColor*)color2 alpha:(CGFloat)alpha2;
- (instancetype)colorWithAlpha:(CGFloat)alpha;

@property (assign, nonatomic, readonly) CGFloat alpha;
@property (strong, nonatomic, readonly) UIColor* opaqueColor;

@end

UIColor* rgba(int r, int g, int b, float a);
UIColor* rgb(int r, int g, int b);