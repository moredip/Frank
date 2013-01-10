//
//  LongTouchViewController.h
//  Controls
//
//  Created by Paddy O'Brien on 2013-01-10.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LongTouchViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *longTouchTriggered;
@property (retain, nonatomic) IBOutlet UILabel *touchLocation;

- (IBAction)resetDidGetPressed:(id)sender;
- (IBAction)longPressDidTrigger:(id)sender;
@end
