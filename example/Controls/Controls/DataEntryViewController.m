//
//  DataEntryViewController.m
//  Controls
//
//  Created by Pete Hodgson on 5/20/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "DataEntryViewController.h"

@interface DataEntryViewController ()
@property (retain, nonatomic) IBOutlet UILabel *outputLabel;
@property (retain, nonatomic) IBOutlet UITextField *theTextField;
@property (retain, nonatomic) IBOutlet UISegmentedControl *keyboardSelector;
@property (retain, nonatomic) IBOutlet UISwitch *capitalizationSwitch;

@end

@implementation DataEntryViewController
@synthesize outputLabel;
@synthesize theTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Data Entry Controls";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [outputLabel setText:@"Do something..."];
}

- (void)viewDidUnload
{
    [self setOutputLabel:nil];
    [self setTheTextField:nil];
    [self setKeyboardSelector:nil];
    [self setCapitalizationSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)didEndEditing:(id)sender {
    [outputLabel setText:[NSString stringWithFormat:@"text entered into text field: %@", theTextField.text]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)keyboardSelectorValueDidChange:(UISegmentedControl *)selector {
    switch(selector.selectedSegmentIndex){
        case 0:
            theTextField.keyboardType = UIKeyboardTypeDefault;
            break;
        case 1:
            theTextField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        default:
            assert(false);
    }
    [theTextField resignFirstResponder];
}
- (IBAction)capitalizationSwitchDidChange:(UISwitch *)capSwitch {
    theTextField.autocapitalizationType = (capSwitch.on ? UITextAutocapitalizationTypeWords : UITextAutocapitalizationTypeNone);
    [theTextField resignFirstResponder];
}


- (void)dealloc {
    [outputLabel release];
    [theTextField release];

    [_keyboardSelector release];
    [_capitalizationSwitch release];
    [super dealloc];
}
@end
