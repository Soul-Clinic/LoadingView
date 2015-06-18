//
//  UIView+Position.m
//  LoadingView
//
//  Created by Can EriK Lu on 6/18/15.
//  Copyright (c) 2015 Can EriK Lu. All rights reserved.
//

#import "UIView+Position.h"

@implementation UIView (Position)

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)newOrigin {
    self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (NSString*)sizeString
{
    return NSStringFromCGSize(self.frameSize);
}

- (NSString*)frameString
{
    return NSStringFromCGRect(self.frame);
}

- (void)setFrameSize:(CGSize)newSize {
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            newSize.width,
                            newSize.height);
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)newX {
    self.frame = CGRectMake(newX,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.frame.size.height);
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)newY {
    self.frame = CGRectMake(self.frame.origin.x,
                            newY,
                            self.frame.size.width,
                            self.frame.size.height);
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newRight {
    self.frame = CGRectMake(newRight - self.frame.size.width,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.frame.size.height);
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newBottom {
    self.frame = CGRectMake(self.frame.origin.x,
                            newBottom - self.frame.size.height,
                            self.frame.size.width,
                            self.frame.size.height);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newWidth {
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            newWidth,
                            self.frame.size.height);
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)boundsHeight
{
    return self.bounds.size.height;
}

- (CGFloat)boundsWidth
{
    return self.bounds.size.width;
}

- (void)setHeight:(CGFloat)newHeight {
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            newHeight);
}

- (void)addCenteredSubview:(UIView *)subview {
    subview.x = (int)((self.bounds.size.width - subview.width) / 2);
    subview.y = (int)((self.bounds.size.height - subview.height) / 2);
    [self addSubview:subview];
}

- (void)moveToCenterOfSuperview {
    self.x = (int)((self.superview.bounds.size.width - self.width) / 2);
    self.y = (int)((self.superview.bounds.size.height - self.height) / 2);
}

- (void)centerVerticallyInSuperview
{
    self.y = (int)((self.superview.bounds.size.height - self.height) / 2);
}

- (void)centerHorizontallyInSuperview
{
    self.x = (int)((self.superview.bounds.size.width - self.width) / 2);
}

@end
