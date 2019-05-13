//
//  AppZipper.m
//  AppOnline
//
//  Created by user on 1/6/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "AppZipper.h"


@implementation AppZipper

+ (NSData *)ZipCompress:(NSData *)content tempFileName:(NSString*)fileName
{
    NSString *compressedFilePath;
    
    if (fileName != nil || fileName.isEmptyOrWhiteSpaces)
        compressedFilePath= [[CommonTasks ApplicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
    else
        compressedFilePath= [[CommonTasks ApplicationDocumentsDirectory] stringByAppendingPathComponent:@"compress"];
    
    if ([compressedFilePath length] > 0)
    {
        [CommonTasks FileDeleteAtPath:compressedFilePath];

        
        ZipFile *zFile = [[ZipFile alloc] initWithFileName:compressedFilePath mode:ZipFileModeCreate];
        ZipWriteStream *zWriteStream = [zFile writeFileInZipWithName:@"a" compressionLevel:ZipCompressionLevelDefault];
        [zWriteStream writeData:content];
        [zWriteStream finishedWriting];
        [zFile close];
        
        
        return [CommonTasks FileReadAtPath:compressedFilePath];
    }
    return nil;
}

+ (NSData *)ZipDecompress:(NSString*)fileName
{
    NSString *compressedFilePath;
    
    if (fileName != nil || fileName.isEmptyOrWhiteSpaces)
        compressedFilePath= [[CommonTasks ApplicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
    else
        compressedFilePath= [[CommonTasks ApplicationDocumentsDirectory] stringByAppendingPathComponent:@"compress"];
    
    
    if ([compressedFilePath length] > 0)
    {
        ZipFile *zFile = [[ZipFile alloc] initWithFileName:compressedFilePath mode:ZipFileModeUnzip];
        ZipReadStream *zReadStream = [zFile readCurrentFileInZip];
        
        NSMutableData *data = [[NSMutableData alloc] initWithLength:1];
        NSMutableData *result = [[NSMutableData alloc] init];
        int i = 0;
        while ((i = (int)[zReadStream readDataWithBuffer:data]) > 0)
            [result appendData:data];
        
        [zReadStream finishedReading];
        [zFile close];
        if ([result length] > 0)
        {
            [CommonTasks FileDeleteAtPath:compressedFilePath];
            return [NSData dataWithData:result];
        }
    }
    return nil;
}

@end
