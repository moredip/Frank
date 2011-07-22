//
//  SYParser.m
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYParser.h"
#import "SYDescendants.h"
#import "SYParents.h"
#import "SYPredicateFilter.h"
#import "SYClassFilter.h"

@interface SYSelectorParser : NSObject {
    NSScanner *_scanner;
    NSCharacterSet *_paramChars;
    NSCharacterSet *_numberChars;
    NSMutableArray *_params;
    NSMutableArray *_args;
}
@property(readonly) NSArray *params, *args;

- (id)initWithString:(NSString *)stringToParse;
- (void) parse;
@end

@implementation SYSelectorParser
@synthesize params=_params,args=_args;

- (id)initWithString:(NSString *)stringToParse {
    self = [super init];
    if (self) {
        _scanner = [[NSScanner alloc] initWithString:stringToParse];
        _paramChars = [[NSCharacterSet letterCharacterSet] retain];
        _numberChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."]retain];
        _params = [[NSMutableArray alloc] init];
        _args = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)dealloc {
    [_scanner release];
    [_paramChars release];
    [_numberChars release];
    [_params release];
    [_args release];
    
    [super dealloc];
}

- (BOOL) parseParamWithoutColon{
    NSString *paramString;
    if( [_scanner scanCharactersFromSet:_paramChars intoString:&paramString] ){
        [_params addObject:paramString];
        return YES;
    }else{
        return NO;
    }
}

- (BOOL) parseColon{
	return [_scanner scanString:@":" intoString:NULL];
}

- (BOOL) parseParamWithColon{
    if( ![self parseParamWithoutColon] )
        return NO;
    if( ![self parseColon] )
        [NSException raise:@"Parse Error" format:@"expected a :"];
    return YES;
}

- (BOOL) parseNumber{
    NSString *numberString;
    if( ![_scanner scanCharactersFromSet:_numberChars intoString:&numberString] )
        return NO;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [_args addObject:[f numberFromString:numberString]];
    [f release];
    return YES;
}

- (BOOL) parseArg{
    // FIXME, NEED TO SCAN STRINGS, etc
    return [self parseNumber];
}

- (void) parse{
    [self parseParamWithoutColon];
    if( ![self parseColon] ){
        // looks like we were a no-arg message
        if( ![_scanner isAtEnd] )
            [NSException raise:@"Parse Error" format:@"unexpected character after no-arg filter predicate"];
        
        return; 
    }
    
    
    [self parseArg];
    while( YES ){
        if( ![self parseParamWithColon] )
            break;
        [self parseArg];
    }
}

@end

@implementation SYParser

- (id)initWithSelectorString:(NSString *)selectorString {
    self = [super init];
    if (self) {
        _scanner = [[NSScanner alloc] initWithString:selectorString];
    }
    return self;
}

- (void)dealloc {
    [_scanner release];
    [super dealloc];
}

- (SYPredicateFilter *) parsePredicateFilter:(NSString *) filterString{
    SYSelectorParser *parser = [[[SYSelectorParser alloc] initWithString:filterString] autorelease];
    [parser parse];
    
    NSString *selectorDesc;
    if( [[parser args] count] == 0 ){
        selectorDesc = [[parser params] objectAtIndex:0];
    }else{
        selectorDesc = [[[parser params] componentsJoinedByString:@":"] stringByAppendingString:@":"];
    }
    
    return [[[SYPredicateFilter alloc] initWithSelector:NSSelectorFromString(selectorDesc) 
                                                   args:[parser args]] autorelease];
}

- (id<SYFilter>) nextFilter{
    NSString *filterString;
    if( ![_scanner scanUpToString:@" " intoString:&filterString] )
        return nil;
    
    if( [filterString isEqualToString:@"view"] ){
        return [[[SYDescendants alloc] init] autorelease];
    }else if( [filterString isEqualToString:@"parent"] ){
        return [[[SYParents alloc] init] autorelease];
    }else if( [filterString isEqualToString:@"button"] ){
        return [[[SYClassFilter alloc] initWithClass:[UIButton class]] autorelease];
    }
    
    return [self parsePredicateFilter:filterString];
}

@end
