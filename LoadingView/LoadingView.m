//
//  Loading.m
//  WePlant
//
//  Created by Can EriK Lu on 6/18/15.
//  Copyright (c) 2015 Can EriK Lu. All rights reserved.
//

#import "LoadingView.h"
#import "UIView+Position.h"
#import "UIColor+Utility.h"

@interface LoadingView () {
    CGFloat _diameter;
    NSMutableArray* _ballCenterPoints;
    NSUInteger _offsetFrame;
    NSUInteger _totalFrames;
    BOOL _reversing;
}
@end

@implementation LoadingView

static const CGFloat AnimationFrameRate = 50;
static const CGFloat PeakPortion = 0.3;
static const CGFloat lightestAlpha = 0.4;

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"Please set the size as soon as possible");
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setup];
//    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [self setup];
}

- (void)setup {
    BOOL hozirontal = self.width > self.height;
    _diameter = MIN(MAX(self.width, self.height) / (_numberOfBall * 2 + 1), MIN(self.width, self.height) / 2);
    _totalFrames = _period * AnimationFrameRate;
    _ballCenterPoints = [[NSMutableArray alloc] initWithCapacity:_numberOfBall];

    if (hozirontal) {
        CGFloat y = self.height / 2;
        CGFloat startX = self.width - (_numberOfBall * 2 - 0.5) * _diameter;
        for (int i = 0; i < _numberOfBall; i++) {
            [_ballCenterPoints addObject:[NSValue valueWithCGPoint:CGPointMake(startX + i * 2 * _diameter, y)]];
        }
    }
    else {              //Vertically
        CGFloat x = self.width / 2;
        CGFloat startY = self.height - (_numberOfBall * 2 - 0.5) * _diameter;
        for (int i = 0; i < _numberOfBall; i++) {
            [_ballCenterPoints addObject:[NSValue valueWithCGPoint:CGPointMake(x, startY + i * 2 * _diameter)]];
        }
    }
    _offsetFrame = PeakPortion * _totalFrames;
}

- (void)setNumberOfBall:(NSUInteger)number {
    if (number == 0) {
        NSLog(@"You can't set 0 to numer of ball");
        return;
    }
    _numberOfBall = number;
    NSLog(@"Setting number of ball %lu, Rect = %@", number, NSStringFromCGRect(self.bounds));
    [self setup];
}

- (void)awakeFromNib {
    NSLog(@"Init from awakeFromNib %@", NSStringFromCGRect(self.frame));
    
    //Set the default
    if (_numberOfBall == 0) {
        NSLog(@"Not set number");
        self.numberOfBall = 4;      //Default to 4
    }
    if (_period == 0) {
        NSLog(@"Not set period");
        _period = 2;
    }
    if (_ballColor == nil) {
        NSLog(@"Not set color");
        _ballColor = rgb(126, 211, 33);
    }
    [self setup];
}

- (CGFloat)yOfX:(CGFloat)x {
    while (x > 1) {
        x--;
    }
    x = x / (1 + PeakPortion);
    if (x > PeakPortion) {
        return 0;
    }
    else {
        return sin(x / PeakPortion * M_PI);
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawBallsOfFrame:(NSUInteger)frame {
    CGFloat result = sin(M_PI * 2);
    NSLog(@"Result = %f", result);
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();


//    CGContextSetLineWidth(context, 3.0);
    
    for (int i = 0; i <_ballCenterPoints.count; i++) {
        NSValue* pointValue = _ballCenterPoints[i];
        CGPoint center = pointValue.CGPointValue;

        CGRect rect = CGRectMake(center.x - _diameter / 2, center.y - _diameter / 2, _diameter, _diameter);

        CGFloat frame = (_numberOfBall - i) * (_totalFrames / _numberOfBall) * (1 - PeakPortion) + _offsetFrame;
//        NSLog(@"x = %f", (frame / _totalFrames));
        CGFloat y = [self yOfX:(frame / _totalFrames)];
        CGFloat expand = y * _diameter;

        CGContextBeginPath(context);
        CGContextSetFillColorWithColor(context, [_ballColor colorWithAlpha: y * (1 - lightestAlpha) + lightestAlpha].CGColor);
        
        rect.origin.x -= expand / 2;
        rect.origin.y -= expand / 2;
        rect.size.width += expand;
        rect.size.height += expand;
        
        CGContextAddEllipseInRect(context, rect);
        CGContextFillPath(context);
    }
    

    _offsetFrame = ((_offsetFrame + (_reversing ? -1 : 1)) + _totalFrames) % _totalFrames;
    if (_offsetFrame == PeakPortion * _totalFrames && self.reverse) {
        _reversing = !_reversing;
        NSLog(@"Reverse!");
    }

    [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:(1 / AnimationFrameRate)];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 / AnimationFrameRate * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self setNeedsDisplay];
//    });
}


@end




/*
NO.1画一条线
 
 CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
 CGContextMoveToPoint(context, 20, 20);
 CGContextAddLineToPoint(context, 200,20);
 CGContextStrokePath(context);



NO.2写文字
 
 CGContextSetLineWidth(context, 1.0);
 CGContextSetRGBFillColor (context, 0.5, 0.5, 0.5, 0.5);
 UIFont  *font = [UIFont boldSystemFontOfSize:18.0];
 [@"公司：北京中软科技股份有限公司\n部门：ERP事业部\n姓名：McLiang" drawInRect:CGRectMake(20, 40, 280, 300) withFont:font];



NO.3画一个正方形图形 没有边框
 
 CGContextSetRGBFillColor(context, 0, 0.25, 0, 0.5);
 CGContextFillRect(context, CGRectMake(2, 2, 270, 270));
 CGContextStrokePath(context);
 


NO.4画正方形边框
 
 CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
 CGContextSetLineWidth(context, 2.0);
 CGContextAddRect(context, CGRectMake(2, 2, 270, 270));
 CGContextStrokePath(context);
 


NO.5画方形背景颜色
 
 CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
 CGContextScaleCTM(context, 1.0f, -1.0f);
 UIGraphicsPushContext(context);
 CGContextSetLineWidth(context,320);
 CGContextSetRGBStrokeColor(context, 250.0/255, 250.0/255, 210.0/255, 1.0);
 CGContextStrokeRect(context, CGRectMake(0, 0, 320, 460));
 UIGraphicsPopContext();
 

NO.6椭圆
 
 CGRect aRect= CGRectMake(80, 80, 160, 100);
 CGContextSetRGBStrokeColor(context, 0.6, 0.9, 0, 1.0);
 CGContextSetLineWidth(context, 3.0);
 CGContextAddEllipseInRect(context, aRect); //椭圆
 CGContextDrawPath(context, kCGPathStroke);
 

NO.7
 CGContextBeginPath(context);
 CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);
 CGContextMoveToPoint(context, 100, 100);
 CGContextAddArcToPoint(context, 50, 100, 50, 150, 50);
 CGContextStrokePath(context);
 

NO.8渐变
 CGContextClip(context);
 CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
 CGFloat colors[] =
 {
 204.0 / 255.0, 224.0 / 255.0, 244.0 / 255.0, 1.00,
 29.0 / 255.0, 156.0 / 255.0, 215.0 / 255.0, 1.00,
 0.0 / 255.0,  50.0 / 255.0, 126.0 / 255.0, 1.00,
 };
 CGGradientRef gradient = CGGradientCreateWithColorComponents
 (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
 CGColorSpaceRelease(rgb);
 CGContextDrawLinearGradient(context, gradient,CGPointMake
 (0.0,0.0) ,CGPointMake(0.0,self.frame.size.height),
 kCGGradientDrawsBeforeStartLocation);
 


 NO.9四条线画一个正方形
 //画线
 UIColor *aColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0];
 CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
 CGContextSetFillColorWithColor(context, aColor.CGColor);
 CGContextSetLineWidth(context, 4.0);
 CGPoint aPoints[5];
 aPoints[0] =CGPointMake(60, 60);
 aPoints[1] =CGPointMake(260, 60);
 aPoints[2] =CGPointMake(260, 300);
 aPoints[3] =CGPointMake(60, 300);
 aPoints[4] =CGPointMake(60, 60);
 CGContextAddLines(context, aPoints, 5);
 CGContextDrawPath(context, kCGPathStroke); //开始画线
 



  NO.10
 UIColor *aColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0];
 CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
 CGContextSetFillColorWithColor(context, aColor.CGColor);
 //椭圆
 CGRect aRect= CGRectMake(80, 80, 160, 100);
 CGContextSetRGBStrokeColor(context, 0.6, 0.9, 0, 1.0);
 CGContextSetLineWidth(context, 3.0);
 CGContextSetFillColorWithColor(context, aColor.CGColor);
 CGContextAddRect(context, rect); //矩形
 CGContextAddEllipseInRect(context, aRect); //椭圆
 CGContextDrawPath(context, kCGPathStroke);
 



  NO.11
 画一个实心的圆
 
 CGContextFillEllipseInRect(context, CGRectMake(95, 95, 100.0, 100));
 



NO.12
 画一个菱形
 CGContextSetLineWidth(context, 2.0);
 CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
 CGContextMoveToPoint(context, 100, 100);
 CGContextAddLineToPoint(context, 150, 150);
 CGContextAddLineToPoint(context, 100, 200);
 CGContextAddLineToPoint(context, 50, 150);
 CGContextAddLineToPoint(context, 100, 100);
 CGContextStrokePath(context);
 

NO.13 画矩形
 CGContextSetLineWidth(context, 2.0);
 
 CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
 
 CGRect rectangle = CGRectMake(60,170,200,80);
 
 CGContextAddRect(context, rectangle);
 
 CGContextStrokePath(context);
 


椭圆
 CGContextSetLineWidth(context, 2.0);
 
 CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
 
 CGRect rectangle = CGRectMake(60,170,200,80);
 
 CGContextAddEllipseInRect(context, rectangle);
 
 CGContextStrokePath(context);
 

用红色填充了一段路径:
 
 CGContextMoveToPoint(context, 100, 100);
 CGContextAddLineToPoint(context, 150, 150);
 CGContextAddLineToPoint(context, 100, 200);
 CGContextAddLineToPoint(context, 50, 150);
 CGContextAddLineToPoint(context, 100, 100);
 CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
 CGContextFillPath(context);
 

填充一个蓝色边的红色矩形
 CGContextSetLineWidth(context, 2.0);
 CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
 CGRect rectangle = CGRectMake(60,170,200,80);
 CGContextAddRect(context, rectangle);
 CGContextStrokePath(context);
 CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
 CGContextFillRect(context, rectangle);
 

画弧
 //弧线的是通过指定两个切点，还有角度，调用CGContextAddArcToPoint()绘制
 CGContextSetLineWidth(context, 2.0);
 CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
 CGContextMoveToPoint(context, 100, 100);
 CGContextAddArcToPoint(context, 100,200, 300,200, 100);
 CGContextStrokePath(context);
 



 绘制贝兹曲线
 //贝兹曲线是通过移动一个起始点，然后通过两个控制点,还有一个中止点，调用CGContextAddCurveToPoint() 函数绘制
 CGContextSetLineWidth(context, 2.0);
 
 CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
 
 CGContextMoveToPoint(context, 10, 10);
 
 CGContextAddCurveToPoint(context, 0, 50, 300, 250, 300, 400);
 
 CGContextStrokePath(context);
 

绘制二次贝兹曲线
 
 CGContextSetLineWidth(context, 2.0);
 
 CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
 
 CGContextMoveToPoint(context, 10, 200);
 
 CGContextAddQuadCurveToPoint(context, 150, 10, 300, 200);
 
 CGContextStrokePath(context);
 

绘制虚线
 CGContextSetLineWidth(context, 5.0);
 
 CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
 
 CGFloat dashArray[] = {2,6,4,2};
 
 CGContextSetLineDash(context, 3, dashArray, 4);//跳过3个再画虚线，所以刚开始有6-（3-2）=5个虚点
 
 CGContextMoveToPoint(context, 10, 200);
 
 CGContextAddQuadCurveToPoint(context, 150, 10, 300, 200);
 
 CGContextStrokePath(context);
 
绘制图片
 NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"dog" ofType:@"png"];
 UIImage* myImageObj = [[UIImage alloc] initWithContentsOfFile:imagePath];
 //[myImageObj drawAtPoint:CGPointMake(0, 0)];
 [myImageObj drawInRect:CGRectMake(0, 0, 320, 480)];
 
 NSString *s = @"我的小狗";
 
 [s drawAtPoint:CGPointMake(100, 0) withFont:[UIFont systemFontOfSize:34.0]];
 


 NSString *path = [[NSBundle mainBundle] pathForResource:@"dog" ofType:@"png"];
 UIImage *img = [UIImage imageWithContentsOfFile:path];
 CGImageRef image = img.CGImage;
 CGContextSaveGState(context);
 CGRect touchRect = CGRectMake(0, 0, img.size.width, img.size.height);
 CGContextDrawImage(context, touchRect, image);
 CGContextRestoreGState(context);
 


NSString *path = [[NSBundle mainBundle] pathForResource:@"dog" ofType:@"png"];
 UIImage *img = [UIImage imageWithContentsOfFile:path];
 CGImageRef image = img.CGImage;
 CGContextSaveGState(context);
 
 CGContextRotateCTM(context, M_PI);
 CGContextTranslateCTM(context, -img.size.width, -img.size.height);
 
 CGRect touchRect = CGRectMake(0, 0, img.size.width, img.size.height);
 CGContextDrawImage(context, touchRect, image);
 CGContextRestoreGState(context);


 NSString *path = [[NSBundle mainBundle] pathForResource:@"dog" ofType:@"png"];
 UIImage *img = [UIImage imageWithContentsOfFile:path];
 CGImageRef image = img.CGImage;
 
 CGContextSaveGState(context);
 
 CGAffineTransform myAffine = CGAffineTransformMakeRotation(M_PI);
 myAffine = CGAffineTransformTranslate(myAffine, -img.size.width, -img.size.height);
 CGContextConcatCTM(context, myAffine);
 
 CGContextRotateCTM(context, M_PI);
 CGContextTranslateCTM(context, -img.size.width, -img.size.height);
 
 CGRect touchRect = CGRectMake(0, 0, img.size.width, img.size.height);
 CGContextDrawImage(context, touchRect, image);
 CGContextRestoreGState(context);
 
*/