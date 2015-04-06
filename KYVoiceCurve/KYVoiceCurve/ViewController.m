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

@implementation ViewController{
    AVAudioRecorder *recorder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.longPressBt addGestureRecognizer:longGes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)presentAction:(id)sender {

//    VoiceCurveView *voiceCurveView = [[VoiceCurveView alloc]initWithFrame:self.view.frame superView:self.view];
//    [voiceCurveView present];
}

-(void)longPress:(UILongPressGestureRecognizer *)longGes{
    longGes.minimumPressDuration = 0.8;
    VoiceCurveView *voiceCurveView = [[VoiceCurveView alloc]initWithFrame:self.view.frame superView:self.view];
    [voiceCurveView present];
}


@end
