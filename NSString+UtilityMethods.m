//
//  NSString+_UtilityMethods.m
//  BioCaching
//
//  Created by Andy Jeffrey on 10/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "NSString+UtilityMethods.h"

@implementation NSString (UtilityMethods)

- (long)indexOf:(NSString *)subString
{
    NSRange firstInstance = [self rangeOfString:subString];
    if (firstInstance.length == 0) {
        return NSNotFound;
    }
    return firstInstance.location;
}

- (long)secondIndexOf:(NSString *)subString
{
    long firstInstance = [self indexOf:subString];
    if (firstInstance == NSNotFound) {
        return NSNotFound;
    }
    NSRange secondInstance = [[self substringFromIndex:firstInstance + subString.length] rangeOfString:subString];
    if (secondInstance.length == 0) {
        return NSNotFound;
    }
    return firstInstance + subString.length + secondInstance.location;
}

- (NSString *)getSubstringBetweenString:(NSString *)separator
{
    NSRange firstInstance = [self rangeOfString:separator];
    NSRange secondInstance = [[self substringFromIndex:firstInstance.location + firstInstance.length] rangeOfString:separator];
    NSRange finalRange = NSMakeRange(firstInstance.location + separator.length, secondInstance.location);
    
    return [self substringWithRange:finalRange];
}

@end
