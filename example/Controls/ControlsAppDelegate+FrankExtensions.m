//
//  ControlsAppDelegate+FrankExtensions.m
//  Controls
//
//  Created by Pete Hodgson on 5/4/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "ControlsAppDelegate.h"

@implementation ControlsAppDelegate (FrankExtensions)

-(void) popToRootViewController:(BOOL)animated{
    [self.navigationController popViewControllerAnimated:animated];
}

@end
