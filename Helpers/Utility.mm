//
//  Utility.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/16/18.
//

#import <Foundation/Foundation.h>
#import "Utility.h"
@interface Utility ()
{
}
@end
@implementation Utility
// Using NSPredicate

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress {
    
    //Create a regex string
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    
    //Create predicate with format matching your regex string
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:
                              @"SELF MATCHES %@", stricterFilterString];
    
    //return true if email address is valid
    return [emailTest evaluateWithObject:emailAddress];
}


+(BOOL)isValidText:(NSString *)text {
    
    //Create a regex string
    NSString *stricterFilterString = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSUInteger characterCount = [stricterFilterString length];
    if (characterCount == 0 || characterCount < 5) {
        return false;
    }else{
        return true;
    }
    
    return characterCount;
}
// Using NSRegularExpression

+ (BOOL) validateEmail:(NSString*) emailAddress {
    
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc]
                                  initWithPattern:regExPattern
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailAddress
                                                     options:0
                                                       range:NSMakeRange(0, [emailAddress length])];
    return (regExMatches == 0) ? NO : YES ;
    
}


@end
