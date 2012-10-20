//
//  ViewPropertiesViewController.m
//  Controls
//
//  Created by Pete Hodgson on 10/19/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "ViewPropertiesViewController.h"

@interface ViewPropertiesViewController ()
@property (retain, nonatomic) IBOutlet UIButton *hideButton;
@property (retain, nonatomic) IBOutlet UIView *blueSquare;
@property (retain, nonatomic) IBOutlet UIView *orangeSquare;

@end

@implementation ViewPropertiesViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_hideButton release];
    [_blueSquare release];
    [_orangeSquare release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setHideButton:nil];
    [self setBlueSquare:nil];
    [self setOrangeSquare:nil];
    [super viewDidUnload];
}

- (IBAction)didTouchHideButton:(id)sender {
    
    if( self.blueSquare.hidden ){
        self.blueSquare.hidden = false;
        [self.hideButton setTitle:@"Hide view" forState:UIControlStateNormal];
    }else{
        self.blueSquare.hidden = true;
        [self.hideButton setTitle:@"Show view" forState:UIControlStateNormal];
    }
}
@end
