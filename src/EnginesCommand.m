#import "EnginesCommand.h"
#import "SelectorEngineRegistry.h"
#import "JSON.h"

@implementation EnginesCommand {

}
- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
    return [[SelectorEngineRegistry getEngineNames] JSONRepresentation];
}


@end