//
//  SYParser.h
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYFilter.h"


@interface SYParser : NSObject {
    NSScanner *_scanner;

    NSCharacterSet *_paramChars;
    NSCharacterSet *_numberChars;
    
    NSMutableArray *_currentParams;
    NSMutableArray *_currentArgs;
}

- (id)initWithSelectorString:(NSString *)selectorString;

- (id<SYFilter>) nextFilter;

@end
