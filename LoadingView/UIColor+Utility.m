//
//  UIColor+Utility.m
//  Instantly
//
//  Created by Can EriK Lu on 7/23/14.
//  Copyright (c) 2014 App With Love. All rights reserved.
//

#import "UIColor+Utility.h"

@implementation UIColor (Utility)

- (UIImage *)image
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self setFill];
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (BOOL)isEqualToColor:(UIColor*)color
{
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color getRed:&r2 green:&g2 blue:&b2 alpha:&a2];

    return (r1 == r2 && g1 == g2 && b1 == b2 && a1 == a2);
}
- (CGFloat)darkFactor
{
    CGFloat red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    CGFloat darkFactor = .2126 * red + .7152 * green + .0722 * blue;
    return darkFactor;
}

- (UIColor*)blendWithColor:(UIColor*)color2 alpha:(CGFloat)alpha2
{
    alpha2 = MIN( 1.0, MAX( 0.0, alpha2 ) );
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    if (alpha2 == 1) {
        alpha2 = a2;
    }
    CGFloat beta = 1.0 - alpha2;
    CGFloat red     = r1 * beta + r2 * alpha2;
    CGFloat green   = g1 * beta + g2 * alpha2;
    CGFloat blue    = b1 * beta + b2 * alpha2;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}


- (instancetype)opaqueColor
{
    return [self colorWithAlpha:1.0];
}

- (CGFloat)alpha
{
    CGFloat a;
    [self getRed:NULL green:NULL blue:NULL alpha:&a];
    return a;
}

- (instancetype)colorWithAlpha:(CGFloat)alpha
{
    CGFloat r, g, b;
    [self getRed:&r green:&g blue:&b alpha:NULL];
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

@end

UIColor* rgba(int r, int g, int b, float a)
{
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];;
}
UIColor* rgb(int r, int g, int b)
{
    return rgba(r, g, b, 1.0);
}