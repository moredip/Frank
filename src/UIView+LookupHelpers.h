//
//  UIView+BKLookupHelpers.h
//  Saturn
//
//  Created by Brian King on 11/29/11.
//  Copyright 2011 AgaMatrix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView(BKLookupHelpers)

- (id)subviewsByAccessibilityLabel;
- (UIView *)subviewContainingAccessibilityLabel:(NSString *)label;

- (NSArray *)subviewsMatchingPredicate:(id)stringOrPredicate;
   
@end
