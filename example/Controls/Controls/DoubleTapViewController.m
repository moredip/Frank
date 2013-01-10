//
//  DoubleTapViewController.m
//  Controls
//
//  Created by Paddy O'Brien on 2013-01-10.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "DoubleTapViewController.h"

@interface DoubleTapViewController ()

@end

@implementation DoubleTapViewController
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
	
	self.view.accessibilityLabel = @"Double Tap View";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetDidGetPressed:(id)sender {
	[self resetValues];
}

- (IBAction)doubleTapWasTriggered:(id)sender {
	UITapGestureRecognizer *dt = (UITapGestureRecognizer *)sender;
	
	CGPoint location = [dt locationInView:self.view];
	
	_triggeredLabel.text = @"YES";
	_locationLabel.text = NSStringFromCGPoint(location);

}

- (void)dealloc {
    [_triggeredLabel release];
    [_locationLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTriggeredLabel:nil];
    [self setLocationLabel:nil];
    [super viewDidUnload];
}

- (void)resetValues {
	_triggeredLabel.text = @"NO";
	_locationLabel.text = @"";
}
@end
