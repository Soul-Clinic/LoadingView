//
//  Loading.h
//  WePlant
//
//  Created by Can EriK Lu on 6/18/15.
//  Copyright (c) 2015 Can EriK Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface LoadingView : UIView

@property (assign, nonatomic) IBInspectable NSUInteger numberOfBall;
@property (strong, nonatomic) IBInspectable UIColor* ballColor;
@property (assign, nonatomic) IBInspectable BOOL reverse;
@property (assign, nonatomic) IBInspectable CGFloat period;

@end
