//
//  AlertViewController.m
//  Controls
//
//  Created by Francis Chary on 2013-01-07.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()

@property (retain, nonatomic) IBOutlet UIButton *showAlertView;
@property (retain, nonatomic) UIAlertView *alertView;

@end

@implementation AlertViewController

@synthesize showAlertView;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setShowAlertView:nil];
    [self setAlertView:nil];
}

- (IBAction) showAlertViewPressed:(id)sender
{
    self.alertView = [[UIAlertView alloc] initWithTitle:@"AlertView Title" message:@"This is a UIAlertView" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"Button1", @"Button 2", nil];
    [self.alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [showAlertView release];
    [self.alertView release];
    
    [super dealloc];
}

@end
