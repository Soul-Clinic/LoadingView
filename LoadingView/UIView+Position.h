//
//  UIView+Position.h
//  LoadingView
//
//  Created by Can EriK Lu on 6/18/15.
//  Copyright (c) 2015 Can EriK Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Position)
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize frameSize;

- (NSString*)sizeString;
- (NSString*)frameString;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

// Setting these modifies the origin but not the size.
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic, readonly) CGFloat boundsWidth;
@property (nonatomic, readonly) CGFloat boundsHeight;

// Methods for centering.
- (void)addCenteredSubview:(UIView *)subview;
- (void)moveToCenterOfSuperview;
- (void)centerVerticallyInSuperview;
- (void)centerHorizontallyInSuperview;
@end
