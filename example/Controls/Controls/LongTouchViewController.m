//
//  LongTouchViewController.m
//  Controls
//
//  Created by Paddy O'Brien on 2013-01-10.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "LongTouchViewController.h"

@interface LongTouchViewController ()

@end

@implementation LongTouchViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self resetValues];
	
	self.view.accessibilityLabel = @"Long Touch View";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_longTouchTriggered release];
    [_touchLocation release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setLongTouchTriggered:nil];
    [self setTouchLocation:nil];
    [super viewDidUnload];
}

- (IBAction)resetDidGetPressed:(id)sender {
	[self resetValues];
}

- (IBAction)longPressDidTrigger:(id)sender {
	UILongPressGestureRecognizer *lp = (UILongPressGestureRecognizer *)sender;
	
	CGPoint location = [lp locationInView:self.view];
	
	_longTouchTriggered.text = @"YES";
	_touchLocation.text = NSStringFromCGPoint(location);
}

- (void)resetValues {
	_longTouchTriggered.text = @"NO";
	_touchLocation.text = @"";
}
@end
