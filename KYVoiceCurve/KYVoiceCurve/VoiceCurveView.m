//
//  VoiceCurveView.m
//  KYVoiceCurve
//
//  Created by Kitten Yang on 4/6/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//


#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height

#import "VoiceCurveView.h"

@implementation VoiceCurveView{
    
    UIVisualEffectView *blurView;
    UIView *SUPERVIEW;
}

-(id)initWithFrame:(CGRect)frame superView:(UIView *)superView{
    self = [super initWithFrame:frame];
    if (self) {
        SUPERVIEW = superView;
        [self setUp];
        [superView addSubview:self];
    }
    
    return self;
}

-(void)setUp{
    
    self.backgroundColor = [UIColor clearColor];
    
    blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.frame = self.frame;
    UIGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [blurView addGestureRecognizer:tapGes];
    blurView.alpha = 0.0f;
    blurView.tag = 101;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [blurView addSubview:lineView];
    
    // blue Bezier Drawing
//    [self createBezierPathWithStartPoint:CGPointMake(20,ScreenHeight) endPoint:CGPointMake(ScreenWidth/4,ScreenHeight) controlPoint:CGPointMake((ScreenWidth/4-20)/2+20, ScreenHeight - 30) fillColor:[UIColor colorWithRed:0 green:0.722 blue:1 alpha:1]];
    
    [self createBezierPathWithStartPoint:CGPointMake(30, ScreenHeight) endPoint:CGPointMake(ScreenWidth/2-10, ScreenHeight) controlPoint:CGPointMake((ScreenWidth/2-10-30)/2+30, ScreenHeight - 20) fillColor:[UIColor yellowColor]];
    
    [self createBezierPathWithStartPoint:CGPointMake(50, ScreenHeight) endPoint:CGPointMake(ScreenWidth*5/8, ScreenHeight) controlPoint:CGPointMake((ScreenWidth*5/8-50)/2+35, ScreenHeight-40) fillColor:[UIColor magentaColor]];
    
    [self createBezierPathWithStartPoint:CGPointMake((ScreenWidth/2-10-30)/2+30, ScreenHeight) endPoint:CGPointMake((ScreenWidth-20-ScreenWidth*5/8)/2+ScreenWidth*5/8-20, ScreenHeight) controlPoint:CGPointMake(((ScreenWidth-20-ScreenWidth*5/8)/2+ScreenWidth*5/8-20-((ScreenWidth/2-10-30)/2+30))/2+(ScreenWidth/2-10-30)/2+30, ScreenHeight-90) fillColor:[UIColor orangeColor]];
    
    [self createBezierPathWithStartPoint:CGPointMake(ScreenWidth/2-20, ScreenHeight) endPoint:CGPointMake(ScreenWidth*7/8, ScreenHeight) controlPoint:CGPointMake((ScreenWidth*7/8-ScreenWidth/2-20)/2+ScreenWidth/2-20, ScreenHeight-50) fillColor:[UIColor redColor]];
    
    [self createBezierPathWithStartPoint:CGPointMake(ScreenWidth*5/8-20, ScreenHeight) endPoint:CGPointMake(ScreenWidth-20, ScreenHeight) controlPoint:CGPointMake((ScreenWidth-20-(ScreenWidth*5/8-20))/2+ScreenWidth*5/8-20, ScreenHeight-35) fillColor:[UIColor colorWithRed:0 green:0.722 blue:1 alpha:1]];
    
    [self addSubview:blurView];
}

-(void)createBezierPathWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint fillColor:(UIColor *)color{
    
    UIBezierPath* BezierPath = [UIBezierPath bezierPath];
    [BezierPath moveToPoint: startPoint];
    [BezierPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = BezierPath.CGPath;
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.opacity = 0.7;
    [blurView.layer addSublayer:shapeLayer];
    
}

- (void)drawRect:(CGRect)rect {
    
}

-(void)present{
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut animations:^{
        UIView *bv = [SUPERVIEW viewWithTag:101];
        bv.alpha = 1.0f;
    } completion:nil];
    
}

-(void)dismiss{
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut animations:^{
        UIView *bv = [SUPERVIEW viewWithTag:101];
        bv.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
