//
//  Utility.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/16/18.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress ;

+ (BOOL) validateEmail:(NSString*) emailAddress ;
+(BOOL)isValidText:(NSString *)text;
@end
