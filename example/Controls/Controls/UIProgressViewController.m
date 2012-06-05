//
//  UIProgressViewViewController.m
//  Controls
//
//  Created by Marcelo Emmerich on 04.06.12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "UIProgressViewController.h"

@implementation UIProgressViewController

@synthesize progressView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    progressView.progress = 0.342f;
}

- (IBAction) onStartTimer:(id)sender
{
    progressView.progress = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void) onTimer:(NSTimer*)timer
{
    float progress = progressView.progress;
    if( progress < 1 )
    {
        progress += 0.1;
        progressView.progress = progress;
    }
    else
    {
        [timer invalidate];
    }
}

@end
