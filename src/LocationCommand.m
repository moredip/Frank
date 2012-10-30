//
//  LocationCommand.m
//  Frank
//
//  Created by Micke Lisinge on 10/30/12.
//
//

#import "LocationCommand.h"

#import <PublicAutomation/UIAutomationBridge.h>
#import "FranklyProtocolHelper.h"
#import "JSON.h"


@implementation LocationCommand

- (NSString *)handlePost:(NSString *)requestBody{
    NSDictionary *requestCommand = FROM_JSON(requestBody);
    
    if( ![requestCommand objectForKey:@"latitude"] && ![requestCommand objectForKey:@"longitude"]){
        return [FranklyProtocolHelper generateErrorResponseWithReason:@"nil location"
                                                           andDetails:[NSString stringWithFormat:@"you have to provide both longitude and latitude"]];
    }
    
    CGPoint locationAsPoint = CGPointMake([[requestCommand objectForKey:@"latitude"] floatValue],[[requestCommand objectForKey:@"longitude"] floatValue]);
    
    NSLog(@"simulating location of %f,%f",locationAsPoint.x, locationAsPoint.y);
    
    [UIAutomationBridge setLocation:locationAsPoint];
    
    return [FranklyProtocolHelper generateSuccessResponseWithoutResults];
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
    if( !requestBody || [requestBody isEqualToString:@""] )
        return [FranklyProtocolHelper generateErrorResponseWithReason:@"get not supported"
                                                          andDetails:[NSString stringWithFormat:@"this interface does not support getting the location"]];
    else
        return [self handlePost:requestBody];
}

@end