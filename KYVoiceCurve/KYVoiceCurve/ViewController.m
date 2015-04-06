//
//  ViewController.m
//  KYVoiceCurve
//
//  Created by Kitten Yang on 4/5/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//



#import "ViewController.h"
#import "VoiceCurveView.h"


@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *longPressBt;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longGes.minimumPressDuration = 0.8;
    [self.longPressBt addGestureRecognizer:longGes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)longPress:(UILongPressGestureRecognizer *)longGes{
    if (longGes.state == UIGestureRecognizerStateBegan) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"record" ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:path];
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(url), &soundId);
        AudioServicesPlaySystemSound(soundId);
        
        VoiceCurveView *voiceCurveView = [[VoiceCurveView alloc]initWithFrame:self.view.frame superView:self.view];
        [voiceCurveView present];        
    }
}


@end
