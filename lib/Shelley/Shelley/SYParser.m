//
//  SYParser.m
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYParser.h"
#import "SYParents.h"
#import "SYPredicateFilter.h"
#import "SYClassFilter.h"
#import "SYNthElementFilter.h"

@interface SYSectionParser : NSObject {
    NSScanner *_scanner;
    NSCharacterSet *_paramChars;
    NSCharacterSet *_numberChars;
    NSMutableArray *_params;
    NSMutableArray *_args;
}
@property(readonly) NSArray *params, *args;

- (id)initWithScanner: (NSScanner *)scanner;
- (void) parse;
- (BOOL) hasNoArgs;
@end

@implementation SYSectionParser
@synthesize params=_params,args=_args;

- (id)initWithScanner: (NSScanner *)scanner{
    self = [super init];
    if (self) {
        _scanner = [scanner retain];
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

- (BOOL) hasNoArgs {
    return [_args count] == 0;
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

- (BOOL) parseSingleQuote{
    return [_scanner scanString:@"'" intoString:NULL];
}

- (BOOL) parseDoubleQuote{
    return [_scanner scanString:@"\"" intoString:NULL];
}

- (NSString *)parseSingleQuotedString{
    if( ![self parseSingleQuote] )
        return nil;
    
    NSString *string;
    [_scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"'"] intoString:&string];
    [self parseSingleQuote];    
    return string;
}

- (NSString *)parseDoubleQuotedString{
    if( ![self parseDoubleQuote] )
        return nil;
    
    NSString *string;
    [_scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\""] intoString:&string];
    [self parseDoubleQuote];    
    return string;
}


- (NSString *)parseQuotedString{
    NSString *string = [self parseSingleQuotedString];
    if( !string )
        string = [self parseDoubleQuotedString];
    
    return string;
}

- (NSNumber *) parseNumber{
    NSString *numberString;
    if( ![_scanner scanCharactersFromSet:_numberChars intoString:&numberString] )
        return nil;
    
    NSNumberFormatter *f = [[[NSNumberFormatter alloc] init] autorelease];
    return [f numberFromString:numberString];
}

- (id) parseArg{
    NSString *parsedString = [self parseQuotedString];
    if( parsedString )
        return parsedString;
    
    return [self parseNumber];
}

- (void) parseArgAndCollect{
    id arg = [self parseArg];
    if( arg )
        [_args addObject:arg];
}

- (void) parse{
    [self parseParamWithoutColon];
    if( ![self parseColon] ){
        return; 
    }
    
    
    [self parseArgAndCollect];
    while( YES ){
        if( ![self parseParamWithColon] )
            break;
        [self parseArgAndCollect];
    }
}

@end


@implementation SYParser

- (id)initWithSelectorString:(NSString *)selectorString {
    self = [super init];
    if (self) {
        _scanner = [[NSScanner alloc] initWithString:selectorString];
        [_scanner setCharactersToBeSkipped:nil];
        
        _paramChars = [[NSCharacterSet letterCharacterSet] retain];
        _numberChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."]retain];
        _currentParams = [[NSMutableArray alloc] init];
        _currentArgs = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)dealloc {
    [_scanner release];
    
    [_paramChars release];
    [_numberChars release];
    [_currentParams release];
    [_currentArgs release];

    [super dealloc];
}

- (id<SYFilter>) interpretSectionAsClassFilterShorthand:(SYSectionParser *)parsedSection{
    if( ![parsedSection hasNoArgs] ){
        return nil;
    }
        
    NSString *firstParam = [[parsedSection params] objectAtIndex:0];
 
 
    Class shorthandClass = nil;
    if( [firstParam isEqualToString:@"view"] )
        shorthandClass = [UIView class];
    else if( [firstParam isEqualToString:@"button"] )
        shorthandClass = [UIButton class];
    else if( [firstParam isEqualToString:@"label"] )
        shorthandClass = [UILabel class];
    else if( [firstParam isEqualToString:@"alertView"] )
        shorthandClass = [UIAlertView class];
    else if( [firstParam isEqualToString:@"navigationButton"] )
        shorthandClass = NSClassFromString(@"UINavigationButton");
    else if( [firstParam isEqualToString:@"navigationItemView"] )
        shorthandClass = NSClassFromString(@"UINavigationItemView");
    else if( [firstParam isEqualToString:@"textField"] )
        shorthandClass = [UITextField class];
    else if( [firstParam isEqualToString:@"tableView"] )
        shorthandClass = [UITableView class];
    else if( [firstParam isEqualToString:@"tableViewCell"] )
        shorthandClass = [UITableViewCell class];

    if( shorthandClass )
        return [[[SYClassFilter alloc] initWithClass:shorthandClass] autorelease];
    else
        return nil;
}

- (id<SYFilter>) interpretSectionIntoFilter:(SYSectionParser *)parsedSection{
    
    id<SYFilter> classFilter = [self interpretSectionAsClassFilterShorthand:parsedSection];
    
    if( classFilter )
        return classFilter;
    
    NSString *firstParam = [[parsedSection params] objectAtIndex:0];
    
    if( [parsedSection hasNoArgs] ){
        if( [firstParam isEqualToString:@"parent"] )
            return [[[SYParents alloc] init] autorelease];
        if( [firstParam isEqualToString:@"first"] )
            return [[[SYNthElementFilter alloc] initWithIndex:0] autorelease];
        else if( [firstParam isEqualToString:@"descendant"] )
            return [[[SYClassFilter alloc] initWithClass:[UIView class] includeSelf:YES] autorelease];
    }else if( [[parsedSection args] count] == 1 ){
        if( [firstParam isEqualToString:@"view"] ) {
            NSString *firstArg = [[parsedSection args] objectAtIndex:0];
            return [[[SYClassFilter alloc] initWithClass:(NSClassFromString(firstArg))] autorelease];
        }else if( [firstParam isEqualToString:@"index"] ) {
            NSNumber *firstArg = [[parsedSection args] objectAtIndex:0];
            return [[[SYNthElementFilter alloc] initWithIndex:[firstArg unsignedIntValue]] autorelease];            
        }
    }
    
    NSString *selectorDesc;
    if( [parsedSection hasNoArgs] ){
        selectorDesc = [[parsedSection params] objectAtIndex:0];
    }else{
        selectorDesc = [[[parsedSection params] componentsJoinedByString:@":"] stringByAppendingString:@":"];
    }
    
    return [[[SYPredicateFilter alloc] initWithSelector:NSSelectorFromString(selectorDesc) 
                                                   args:[parsedSection args]] autorelease];
}

- (id<SYFilter>) nextFilter{
    
    [_scanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:nil];
    
    if( [_scanner isAtEnd] )
        return nil;
    
    SYSectionParser *sectionParser = [[[SYSectionParser alloc] initWithScanner:_scanner] autorelease];
    [sectionParser parse];
    
    return [self interpretSectionIntoFilter:sectionParser];
}

@end
