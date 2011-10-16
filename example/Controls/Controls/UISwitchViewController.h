//
//  UISwitchViewController.h
//  Controls
//
//  Created by Pete Hodgson on 9/30/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UISwitchViewController : UIViewController {

}

- (IBAction) switchDidChange:(UISwitch *)sender;

@property (nonatomic,retain) IBOutlet UILabel *reportLabel;


@end
