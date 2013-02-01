//
//  VersionCommand.h
//  Frank
//
//  Created by Pete Hodgson on 1/31/13.
//
//

#import "FrankCommandRoute.h"

@interface VersionCommand : NSObject<FrankCommand>
- (id)initWithVersion:(NSString *)version;
@end
