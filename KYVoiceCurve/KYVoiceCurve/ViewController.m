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

@end

@implementation ViewController{
    AVAudioRecorder *recorder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)presentAction:(id)sender {

    VoiceCurveView *voiceCurveView = [[VoiceCurveView alloc]initWithFrame:self.view.frame superView:self.view];
    [voiceCurveView present];
}




@end
