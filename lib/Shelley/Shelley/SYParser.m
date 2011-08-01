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

@implementation SYParser

- (id)initWithSelectorString:(NSString *)selectorString {
    self = [super init];
    if (self) {
        _scanner = [[NSScanner alloc] initWithString:selectorString];
        
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

- (BOOL) parseIdentifierWithoutColon{
    NSString *paramString;
    if( [_scanner scanCharactersFromSet:_paramChars intoString:&paramString] ){
        [_currentParams addObject:paramString];
        return YES;
    }else{
        return NO;
    }
}

- (BOOL) parseColon{
	return [_scanner scanString:@":" intoString:NULL];
}

- (BOOL) parseIdentifierWithColon{
    if( ![self parseIdentifierWithoutColon] )
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

- (BOOL) parseStringClosedWithDoubleQuote{
    NSString *string;
    if( ![_scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\""] intoString:&string] )
        return NO;
    [_currentArgs addObject:string];
    [self parseDoubleQuote];
    return YES;
}

- (NSNumber *) parseNumber{
    NSString *numberString;
    if( ![_scanner scanCharactersFromSet:_numberChars intoString:&numberString] )
        return nil;
    
    NSNumberFormatter *f = [[[NSNumberFormatter alloc] init] autorelease];
    return [f numberFromString:numberString];
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

- (id) parseArg{
    NSString *parsedString = [self parseQuotedString];
    if( parsedString )
        return parsedString;
    
    return [self parseNumber];
}

- (BOOL) parsePredicateArg{
    id arg = [self parseArg];
    if( !arg )
        return NO;
    
    [_currentArgs addObject:[self parseArg]];
    return YES;
}

// a predicate is e.g. "marked:'foo'"
- (void) parsePredicate{
    [_currentArgs removeAllObjects];
    [_currentParams removeAllObjects];
    
    [self parseIdentifierWithoutColon];
    if( ![self parseColon] ){
        // looks like we were a no-arg message
        if( ![_scanner isAtEnd] )
            [NSException raise:@"Parse Error" format:@"unexpected character after no-arg filter predicate"];
        
        return; 
    }
    
    [self parsePredicateArg];
    while( YES ){
        if( ![self parseIdentifierWithColon] )
            break;
        [self parsePredicateArg];
    }
}

- (SYPredicateFilter *) parsePredicateFilter{
    [self parsePredicate];
    
    NSString *selectorDesc;
    if( [_currentArgs count] == 0 ){
        selectorDesc = [_currentParams objectAtIndex:0];
    }else{
        selectorDesc = [[_currentParams componentsJoinedByString:@":"] stringByAppendingString:@":"];
    }
    
    return [[[SYPredicateFilter alloc] initWithSelector:NSSelectorFromString(selectorDesc) 
                                                   args:_currentArgs] autorelease];
}

- (id<SYFilter>) parseSpecialFilters{
    
    if( [_scanner scanString:@"view" intoString:NULL] ){
        return [[[SYClassFilter alloc] initWithClass:[UIView class]] autorelease];
    }else if( [_scanner scanString:@"parent" intoString:NULL] ){
        return [[[SYParents alloc] init] autorelease];
    }else if( [_scanner scanString:@"button" intoString:NULL] ){
        return [[[SYClassFilter alloc] initWithClass:[UIButton class]] autorelease];
    }else{
        return nil;
    }
}
          
- (BOOL) parseSpace{
    return [_scanner scanString:@" " intoString:NULL];
}

- (id<SYFilter>) nextFilter{
    if( [_scanner isAtEnd] )
        return nil;
    
    id<SYFilter> nextFilter = [self parseSpecialFilters];
    if( !nextFilter )
        nextFilter = [self parsePredicateFilter];
    
    [self parseSpace];
    return nextFilter;
}

@end
