//
//  Shelley.h
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SYParser.h"

@interface Shelley : NSObject {
    SYParser *_parser;
    
}
+ (Shelley *) withSelectorString:(NSString *)selectorString;

- (id)initWithSelectorString:selectorString;

- (NSArray *) selectFrom:(UIView *)rootView;

@end
