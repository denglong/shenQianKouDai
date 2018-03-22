//
//  DataCheck.m
//  Discuz2
//
//  Created by rexshi on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataCheck.h"

@implementation DataCheck

+ (BOOL) isValidNumber:(id)input
{
    if (!input) {
        return NO;
    }
    
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    
    if (![input isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    
    return YES;
}


+ (BOOL) isValidString:(id)input
{
    if (!input) {
        return NO;
    }
 
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    
    if (![input isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([input isEqualToString:@""]) {
        return NO;
    }
    if ([input isEqualToString:@"(null)"]) {
        return NO;
    }
    return YES;
}

+ (BOOL) isValidDictionary:(id)input
{
    if (!input) {
        return NO;
    }
    
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    
    if (![input isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    if ([input count] <= 0) {
        return NO;
    }
    
    return YES;
}

+ (BOOL) isValidArray:(id)input
{
    if (!input) {
        return NO;
    }
    
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    
    if (![input isKindOfClass:[NSArray class]]) {
        return NO;
    }
    
    if ([input count] <= 0) {
        return NO;
    }
    
    return YES;
}

@end
