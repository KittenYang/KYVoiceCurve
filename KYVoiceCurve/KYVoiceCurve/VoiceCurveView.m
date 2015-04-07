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

@interface VoiceCurveView()<AVAudioRecorderDelegate>

@property(readwrite, nonatomic, strong) AVAudioRecorder *recorder;
@property(readwrite, nonatomic, strong) NSDictionary *recordSettings;
@property(nonatomic,strong)CADisplayLink *displayLink;

@end

@implementation VoiceCurveView{
    
    UIVisualEffectView *blurView;
    UIView *SUPERVIEW;
    
    CAShapeLayer *layer1;
    CAShapeLayer *layer2;
    CAShapeLayer *layer3;
    CAShapeLayer *layer4;
    CAShapeLayer *layer5;
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
    
    [self setAudioProperties];
    
    self.backgroundColor = [UIColor clearColor];
    
    blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.frame = self.frame;
    UIGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [blurView addGestureRecognizer:tapGes];
    blurView.alpha = 0.0f;
    blurView.tag = 101;
    
    [self addSubview:blurView];

    //layer1
    layer1 = [CAShapeLayer layer];
    layer1.fillColor = [UIColor yellowColor].CGColor;
    layer1.opacity = 0.7;
    [blurView.layer addSublayer:layer1];
    
    //layer2
    layer2 = [CAShapeLayer layer];
    layer2.fillColor = [UIColor magentaColor].CGColor;
    layer2.opacity = 0.7;
    [blurView.layer addSublayer:layer2];
    
    //layer3
    layer3 = [CAShapeLayer layer];
    layer3.fillColor = [UIColor orangeColor].CGColor;
    layer3.opacity = 0.7;
    [blurView.layer addSublayer:layer3];
    
    //layer4
    layer4 = [CAShapeLayer layer];
    layer4.fillColor = [UIColor redColor].CGColor;
    layer4.opacity = 0.7;
    [blurView.layer addSublayer:layer4];
    
    //layer5
    layer5 = [CAShapeLayer layer];
    layer5.fillColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1].CGColor;
    layer5.opacity = 0.7;
    [blurView.layer addSublayer:layer5];
    
    
    //the label -- 正在聆听
//    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
//    UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc]initWithEffect:vibrancy];
//    vibrancyView.frame = blurView.bounds;
    
    UILabel *listeningLabel = [[UILabel alloc]init];
    listeningLabel.frame =  CGRectMake(ScreenWidth/2 - 320/2, 100, 320, 30);
    listeningLabel.textAlignment = NSTextAlignmentCenter;
    listeningLabel.font = [UIFont systemFontOfSize:30.0f];
    listeningLabel.textColor = [UIColor whiteColor];
    listeningLabel.text = @"正在聆听...";
    [blurView.contentView addSubview:listeningLabel];

//    [vibrancyView.contentView addSubview:listeningLabel];
//    [blurView.contentView addSubview:vibrancyView];
    
}

//---------配置AVAudioRecorder的一些音频采样参数-------------
- (void)setAudioProperties{
    
    self.recordSettings = @{AVFormatIDKey : @(kAudioFormatLinearPCM),
                            AVEncoderBitRateKey:@(16),
                            AVEncoderAudioQualityKey : @(AVAudioQualityMax),
                            AVSampleRateKey : @(8000.0),
                            AVNumberOfChannelsKey : @(1)
                            };
    
    if (self.recorder.isRecording) {
        return;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:[self fullPathAtCache:@"record.wav"]];
    NSDate *existedData = (NSDate *)[NSData dataWithContentsOfFile:[url path] options:NSDataReadingMapped error:&err];
    if (existedData) {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:&err];
    }
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:self.recordSettings error:&err];
    self.recorder.meteringEnabled = YES;
    [self.recorder setDelegate:self];
    [self.recorder record];
    [self.recorder prepareToRecord];
    
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawRealTimeCurve:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (NSString *)fullPathAtCache:(NSString *)fileName{
    NSError *error;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (YES != [fm fileExistsAtPath:path]) {
        if (YES != [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"create dir path=%@, error=%@", path, error);
        }
    }
    return [path stringByAppendingPathComponent:fileName];
}

-(void)drawRealTimeCurve:(CADisplayLink *)dis{
    [self.recorder updateMeters];
    
    NSLog(@"volume:%f",[self.recorder averagePowerForChannel:0]);
    
    //------重绘函数-------
    CGFloat volume = [self.recorder averagePowerForChannel:0];
    CGFloat controlY1 = ScreenHeight - (volume+60);
    CGFloat controlY2 = ScreenHeight - ((volume+60)+10)*1.5;
    CGFloat controlY3 = ScreenHeight - ((volume+60)+30)*2.3;
    CGFloat controlY4 = ScreenHeight - ((volume+60)+15)*2;
    CGFloat controlY5 = ScreenHeight - ((volume+60)+5)*1.5;
    
    layer1.path = [self createBezierPathWithStartPoint:CGPointMake(30, ScreenHeight) endPoint:CGPointMake(ScreenWidth/2-10, ScreenHeight) controlPoint:CGPointMake((ScreenWidth/2-10-30)/2+30, controlY1)].CGPath;
    
    layer2.path = [self createBezierPathWithStartPoint:CGPointMake(50, ScreenHeight) endPoint:CGPointMake(ScreenWidth*5/8, ScreenHeight) controlPoint:CGPointMake((ScreenWidth*5/8-50)/2+35,controlY2)].CGPath;
    
    layer3.path = [self createBezierPathWithStartPoint:CGPointMake((ScreenWidth/2-10-30)/2+30, ScreenHeight) endPoint:CGPointMake((ScreenWidth-20-ScreenWidth*5/8)/2+ScreenWidth*5/8-20, ScreenHeight) controlPoint:CGPointMake(((ScreenWidth-20-ScreenWidth*5/8)/2+ScreenWidth*5/8-20-((ScreenWidth/2-10-30)/2+30))/2+(ScreenWidth/2-10-30)/2+30,controlY3)].CGPath;
    
    layer4.path = [self createBezierPathWithStartPoint:CGPointMake(ScreenWidth/2-20, ScreenHeight) endPoint:CGPointMake(ScreenWidth*7/8, ScreenHeight) controlPoint:CGPointMake((ScreenWidth*7/8-ScreenWidth/2-20)/2+ScreenWidth/2-20, controlY4)].CGPath;
    
    layer5.path = [self createBezierPathWithStartPoint:CGPointMake(ScreenWidth*5/8-20, ScreenHeight) endPoint:CGPointMake(ScreenWidth-20, ScreenHeight) controlPoint:CGPointMake((ScreenWidth-20-(ScreenWidth*5/8-20))/2+ScreenWidth*5/8-20, controlY5)].CGPath;
    
}


//-------------根据返回音量返回实时的曲线----------------------
-(UIBezierPath*)createBezierPathWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint{
    
    UIBezierPath* BezierPath = [UIBezierPath bezierPath];
    [BezierPath moveToPoint: startPoint];
    [BezierPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    return BezierPath;
}



-(void)present{
    
    [UIView animateWithDuration:0.8f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut animations:^{
        UIView *bv = [SUPERVIEW viewWithTag:101];
        bv.alpha = 1.0f;
    } completion:nil];
    
}

-(void)dismiss{
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut animations:^{
        UIView *bv = [SUPERVIEW viewWithTag:101];
        bv.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.displayLink invalidate];
        self.displayLink = nil;
    }];
}



@end
