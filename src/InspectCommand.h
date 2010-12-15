//
//  InspectCommand.h
//  Frank
//
//  Created by Cory Smith on 10-12-11.
//  Copyright 2010 assn dot ca inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FrankCommandRoute.h"

@interface InspectCommand : NSObject <FrankCommand> {
	NSMutableArray *accessArray;
}

@end
