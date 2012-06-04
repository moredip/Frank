//
//  UIProgressViewViewController.h
//  Controls
//
//  Created by Marcelo Emmerich on 04.06.12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIProgressViewController : UIViewController
{
}

- (IBAction) onStartTimer:(id)sender;

@property (nonatomic,retain) IBOutlet UIProgressView *progressView;

@end
