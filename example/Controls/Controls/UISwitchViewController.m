//
//  UISwitchViewController.m
//  Controls
//
//  Created by Pete Hodgson on 9/30/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "UISwitchViewController.h"


@implementation UISwitchViewController

@synthesize reportLabel=_reportLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"UISwitch";
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction) switchDidChange:(UISwitch *)sender {
    if( [sender isOn] ){
        self.reportLabel.text = @"Switch is on";
    }else{
        self.reportLabel.text = @"Switch is off";    
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
