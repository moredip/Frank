//
//  CallCache.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//

@interface CallCache : NSObject {

}

-(id)set:(id)object forSelector:(SEL)selector;
-(id)set:(id)object for:(id)key;
-(id)getForSelector:(SEL)selector;
-(id)get:(id)key;
-(void)clear;

+(NSMutableDictionary *)getFullCache;
+(void)clear;

@end
