//
//  DoubleTapViewController.h
//  Controls
//
//  Created by Paddy O'Brien on 2013-01-10.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleTapViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *triggeredLabel;
@property (retain, nonatomic) IBOutlet UILabel *locationLabel;

- (IBAction)resetDidGetPressed:(id)sender;
- (IBAction)doubleTapWasTriggered:(id)sender;
@end
