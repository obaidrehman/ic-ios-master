//
//  AppZipper.h
//  AppOnline
//
//  Created by user on 1/6/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonTasks.h"
#import "ZipFile.h"
#import "ZipReadStream.h"
#import "ZipWriteStream.h"


@interface AppZipper : NSObject

/// @description compress data to app.net side equivalent stuff
/// @param content its obviously the raw stuff
/// @fileName points to a temp file which will hold this data while its been compress, nil can be pass here
/// @returns the compress data
+ (NSData*)ZipCompress:(NSData*)content tempFileName:(NSString*)fileName;

/// @description decompress data stored in tyhe file
/// @param fileName the file name, nil can be pass here
/// @returns the raw data
+ (NSData*)ZipDecompress:(NSString*)fileName;

@end
