//
//  ViewController.m
//  KYVoiceCurve
//
//  Created by Kitten Yang on 4/5/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)presentAction:(id)sender {

    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.frame = self.view.frame;
    UIGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissPresentingViewController)];
    [blurView addGestureRecognizer:tapGes];
    blurView.alpha = 0.0f;
    blurView.tag = 101;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [blurView addSubview:lineView];
    
    // Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(0,ScreenHeight)];
    [bezierPath addQuadCurveToPoint:CGPointMake(ScreenWidth/2,ScreenHeight) controlPoint:CGPointMake(ScreenWidth/4, ScreenHeight - 150)];
    bezierPath.lineWidth = 1;

    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:0.8].CGColor;
    [blurView.layer addSublayer:shapeLayer];
    

    [self.view addSubview:blurView];
    
    //animation
    [UIView animateWithDuration:0.3 animations: ^ {
        self.view.transform = CGAffineTransformScale(self.view.transform, 0.95, 0.95);
        blurView.alpha = 1.0f;
    } completion:nil];
    
}

-(void)dismissPresentingViewController{
    [UIView animateWithDuration:0.3 animations: ^ {
        self.view.transform = CGAffineTransformIdentity;
        UIView *bv = [self.view viewWithTag:101];
        bv.alpha = 0.0f;
    } completion:^(BOOL finished) {
        UIView *bv = [self.view viewWithTag:101];
        [bv removeFromSuperview];
    }];
}
@end
