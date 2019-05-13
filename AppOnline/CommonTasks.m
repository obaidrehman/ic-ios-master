//
//  CommonTasks.m
//  AppOnline
//
//  Created by user on 1/6/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "CommonTasks.h"
#import "AppZipper.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation CommonTasks

+ (NSString *) ApplicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (void)FileCreateWithContent:(NSString *)content fileName:(NSString*)fileName
{
    NSString *filePath;
    
    if (fileName != nil && !fileName.isEmptyOrWhiteSpaces)
        filePath = [[CommonTasks ApplicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
    
    if ([filePath length] > 0)
    {
        NSString *fileContent = (content != nil && !content.isEmptyOrWhiteSpaces) ? content : @"";
        
        NSFileManager *filemgr;
        filemgr = [NSFileManager defaultManager];
        [filemgr removeItemAtPath:filePath error:nil];
        [filemgr createFileAtPath:filePath contents:[fileContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        filemgr = nil;
    }
}

+ (void)FileCreateWithContent:(NSString *)content filePath:(NSString *)filePath
{
    if (filePath != nil && !filePath.isEmptyOrWhiteSpaces)
    {
        NSString *fileContent = (content != nil && !content.isEmptyOrWhiteSpaces) ? content : @"";
        
        NSFileManager *filemgr;
        filemgr = [NSFileManager defaultManager];
        [filemgr removeItemAtPath:filePath error:nil];
        [filemgr createFileAtPath:filePath contents:[fileContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        filemgr = nil;
    }
}

+ (void)FileCreateWithData:(NSData *)content fileName:(NSString *)fileName
{
    NSString *filePath;
    
    if (fileName != nil && !fileName.isEmptyOrWhiteSpaces)
        filePath = [[CommonTasks ApplicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
    
    if ([filePath length] > 0)
    {
        NSData *fileContent = (content != nil && [content length] > 0) ? [[NSData alloc] initWithData:content] : [@"" dataUsingEncoding:NSUTF8StringEncoding];
        
        NSFileManager *filemgr;
        filemgr = [NSFileManager defaultManager];
        [filemgr removeItemAtPath:filePath error:nil];
        [filemgr createFileAtPath:filePath contents:fileContent attributes:nil];
        filemgr = nil;
    }
}

+ (void)FileCreateWithData:(NSData *)content filePath:(NSString *)filePath
{
    if (filePath != nil && !filePath.isEmptyOrWhiteSpaces)
    {
        NSData *fileContent = (content != nil && [content length] > 0) ? [[NSData alloc] initWithData:content] : [@"" dataUsingEncoding:NSUTF8StringEncoding];
        
        NSFileManager *filemgr;
        filemgr = [NSFileManager defaultManager];
        [filemgr removeItemAtPath:filePath error:nil];
        [filemgr createFileAtPath:filePath contents:fileContent attributes:nil];
        filemgr = nil;
    }
}

+ (void)FileDeleteWithName:(NSString *)fileName
{
    NSString *filePath;
    
    if (fileName != nil && !fileName.isEmptyOrWhiteSpaces)
        filePath = [[CommonTasks ApplicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
    
    if ([filePath length] > 0)
    {
        NSFileManager *filemgr;
        filemgr = [NSFileManager defaultManager];
        [filemgr removeItemAtPath:filePath error:nil];
        filemgr = nil;
    }
}

+ (void)FileDeleteAtPath:(NSString *)filePath
{
    if (filePath != nil && !filePath.isEmptyOrWhiteSpaces)
    {
        NSFileManager *filemgr;
        filemgr = [NSFileManager defaultManager];
        [filemgr removeItemAtPath:filePath error:nil];
        filemgr = nil;
    }
}

+ (NSData *)FileReadWithName:(NSString *)fileName
{
    NSString *filePath;
    
    if (fileName != nil && !fileName.isEmptyOrWhiteSpaces)
        filePath = [[CommonTasks ApplicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
    
    if ([filePath length] > 0)
    {
        NSFileManager *filemgr;
        filemgr = [NSFileManager defaultManager];
        NSData* data = [filemgr contentsAtPath:filePath];
        filemgr = nil;
        
        if (data != nil && [data length] > 0)
            return data;
    }
    return nil;
}

+ (NSData *)FileReadAtPath:(NSString *)filePath
{
    if (filePath != nil && !filePath.isEmptyOrWhiteSpaces)
    {
        NSFileManager *filemgr;
        filemgr = [NSFileManager defaultManager];
        NSData* data = [filemgr contentsAtPath:filePath];
        filemgr = nil;
        
        if (data != nil && [data length] > 0)
            return data;
    }
    return nil;
}

+ (NSString *)MachineCode
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)SystemInfo
{
    return [NSString stringWithFormat:@"%@, %@ %@", [[UIDevice currentDevice] name], [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
}

+ (BOOL)DeviceTypeiPhone
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return true;
    return false;
}

+ (BOOL)DeviceOrientationPotrait
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown)
        return true;
    return false;
}


+ (NSString *)GetIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)GetIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [CommonTasks getIPAddresses];
    [CommonTasks LogMessage:[NSString stringWithFormat:@"addresses: %@", addresses] MessageFlagType:logMessageFlagTypeInfo];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


+ (NSString *)Good
{
    return @"✔";
}

+ (NSString *)Bad
{
    return @"✘";
}

+ (NSString *)Ugly
{
    return @"(ಠ_ಠ)_%    WTF?";
}


+ (NSString *)iOS
{
    return [NSString stringWithFormat: @"%@ %@", @"iOS", [CommonTasks Version]];
}

+ (NSString *)Version
{
    return [NSString stringWithFormat: @"%@", [[[NSBundle mainBundle] infoDictionary] valueForKey: @"CFBundleVersion"]];
}

+ (NSString *)GetEngineName
{
    return @"McLaren F1 MP4-30 Engine xD";
}

+ (NSString *)TrueLies
{
    return @"True";
}

+ (NSString *)Falsehood
{
    return @"False";
}

+ (NSString *)InfinityChessWebsite
{
    return @"http://www.infinitychess.com";
}

+ (NSString *)LeftArrowString
{
    return @"◀";
}

+ (NSString *)RightArrowString
{
    return @"▶";
}

+ (NSString *)TopArrowString
{
    return @"▲";
}

+ (NSString *)BottomArrowString
{
    return @"▼";
}

+(NSString *)ReturnArrowString
{
    return @"⏎";
}

+ (NSString*)RefreshClockWiseArrowString
{
    return @"↻";
}

+ (NSString*)RefreshAntiClockWiseArrowString
{
    return @"↺";
}

+ (NSString*)EnterArrowString
{
    return @"↵";
}

+ (NSString*)GoArrowString
{
    return @"➟";
}

+ (NSString *)Zero
{
    return @"0";
}

+ (NSString*)SquareString
{
    return @"■";
}

+ (NSData *)DoCipher:(NSData *)plainText ToEncrypt:(BOOL)encryptORdecrypt
{
    CCCryptorStatus ccStatus = kCCSuccess;
    // Symmetric crypto reference.
    CCCryptorRef thisEncipher = NULL;
    // Cipher Text container.
    NSData * cipherOrPlainText = nil;
    // Pointer to output buffer.
    uint8_t * bufferPtr = NULL;
    // Total size of the buffer.
    size_t bufferPtrSize = 0;
    // Remaining bytes to be performed on.
    size_t remainingBytes = 0;
    // Number of bytes moved to buffer.
    size_t movedBytes = 0;
    // Length of plainText buffer.
    size_t plainTextBufferSize = 0;
    // Placeholder for total written.
    size_t totalBytesWritten = 0;
    // A friendly helper pointer.
    uint8_t * ptr;
	
    
    // encrypt or decrypt?
    CCOperation encryptOrDecrypt = encryptORdecrypt ? kCCEncrypt : kCCDecrypt;
    // padding
    CCOptions pkcs7 = kCCOptionPKCS7Padding;
    // initialization vector, in this case this is in reference to the .net code
    uint8_t iv[kCCBlockSizeAES128] = { 210, 152, 152, 141, 6, 84, 161, 212, 77, 71, 46, 38, 68, 110, 128, 159 };
    // initialization key, in this case this is in reference to the .net code
    Byte _key[kCCKeySizeAES256] = { 186, 176, 251, 49, 154, 190, 169, 253, 33, 120, 181, 202, 38, 102, 8, 104, 38, 59, 243, 44, 174, 14, 63, 152, 29, 74, 225, 121, 229, 238, 11, 33 };
    NSData *aSymmetricKey = [NSData dataWithBytes:_key length:strlen((char*)_key)];
	
    [CommonTasks LogMessage:[NSString stringWithFormat:@"doCipher: plaintext: %@", plainText] MessageFlagType:logMessageFlagTypeInfo];
    [CommonTasks LogMessage:[NSString stringWithFormat:@"doCipher: key length: %d", [aSymmetricKey length]] MessageFlagType:logMessageFlagTypeInfo];
	
    //LOGGING_FACILITY(plainText != nil, @"PlainText object cannot be nil." );
    //LOGGING_FACILITY(aSymmetricKey != nil, @"Symmetric key object cannot be nil." );
    //LOGGING_FACILITY(pkcs7 != NULL, @"CCOptions * pkcs7 cannot be NULL." );
    //LOGGING_FACILITY([aSymmetricKey length] == kChosenCipherKeySize, @"Disjoint choices for key size." );
	
    plainTextBufferSize = [plainText length];
	
    //LOGGING_FACILITY(plainTextBufferSize > 0, @"Empty plaintext passed in." );
	
    [CommonTasks LogMessage:[NSString stringWithFormat:@"pkcs7: %d", pkcs7] MessageFlagType:logMessageFlagTypeInfo];
    // We don't want to toss padding on if we don't need to
    if(encryptOrDecrypt == kCCEncrypt) {
        if(pkcs7 != kCCOptionECBMode) {
            if((plainTextBufferSize % kCCBlockSizeAES128) == 0) {
                pkcs7 = 0x0000;
            } else {
                pkcs7 = kCCOptionPKCS7Padding;
            }
        }
    } else if(encryptOrDecrypt != kCCDecrypt) {
        [CommonTasks LogMessage:[NSString stringWithFormat:@"Invalid CCOperation parameter [%d] for cipher context.", pkcs7] MessageFlagType:logMessageFlagTypeWarning];
    }
	
    // Create and Initialize the crypto reference.
    ccStatus = CCCryptorCreate(encryptOrDecrypt,
                               kCCAlgorithmAES128,
                               pkcs7,
                               (const void *)[aSymmetricKey bytes],
                               kCCKeySizeAES256,
                               (const void *)iv,
                               &thisEncipher
                               );
	
    //LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem creating the context, ccStatus == %d.", ccStatus );
	
    // Calculate byte block alignment for all calls through to and including final.
    bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
	
    // Allocate buffer.
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );
	
    // Zero out buffer.
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
	
    // Initialize some necessary book keeping.
	
    ptr = bufferPtr;
	
    // Set up initial size.
    remainingBytes = bufferPtrSize;
	
    // Actually perform the encryption or decryption.
    ccStatus = CCCryptorUpdate(thisEncipher,
                               (const void *) [plainText bytes],
                               plainTextBufferSize,
                               ptr,
                               remainingBytes,
                               &movedBytes
                               );
	
    //LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem with CCCryptorUpdate, ccStatus == %d.", ccStatus );
	
    // Handle book keeping.
    ptr += movedBytes;
    remainingBytes -= movedBytes;
    totalBytesWritten += movedBytes;
	
	
    // Finalize everything to the output buffer.
    ccStatus = CCCryptorFinal(thisEncipher,
                              ptr,
                              remainingBytes,
                              &movedBytes
                              );
	
    totalBytesWritten += movedBytes;
	
    if(thisEncipher) {
        (void) CCCryptorRelease(thisEncipher);
        thisEncipher = NULL;
    }
	
    //LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem with encipherment ccStatus == %d", ccStatus );
	
    if (ccStatus == kCCSuccess)
        cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
    else
        cipherOrPlainText = nil;
	
    if(bufferPtr) free(bufferPtr);
	
    return cipherOrPlainText;
}


+ (void)DoAsyncTaskOnGlobalQueue:(void (^)(void))asyncTask
{
    void (^task) (void);
    task = ^void (void)
    {
        @try {
            asyncTask();
        }
        @catch (NSException *exception)
        {
            [CommonTasks LogMessage:[exception description] MessageFlagType:logMessageFlagTypeError];
        }
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), task);
}

+ (void)DoAsyncTaskOnMainQueue:(void (^)(void))asyncTask
{
    void (^task) (void);
    task = ^void (void)
    {
        @try {
            asyncTask();
        }
        @catch (NSException *exception)
        {
            [CommonTasks LogMessage:[exception description] MessageFlagType:logMessageFlagTypeError];
        }
    };
    
    dispatch_async(dispatch_get_main_queue(), task);
}

static dispatch_queue_t networkQueue;
+ (void)DoAsyncTaskOnNetworkingQueue:(void (^)(void))asyncTask
{
    void (^task)(void);
    task = ^void (void)
    {
        @try {
            asyncTask();
        }
        @catch (NSException *exception) {
            [CommonTasks LogMessage:[exception description] MessageFlagType:logMessageFlagTypeError];
        }
    };
    
    if (!networkQueue)
        networkQueue = dispatch_queue_create("networking", NULL);
    dispatch_async(networkQueue, task);
}




+ (NSDate*)FormatServerDateTime:(NSString *)serverDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    //[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *serverTime = [dateFormatter dateFromString:serverDateTime];
    //serverTime = [serverTime dateByAddingTimeInterval:[[NSDate date] timeIntervalSinceDate:serverTime]];
    return  serverTime;
    
    //return [[dateFormatter dateFromString:serverDateTime] dateByAddingTimeInterval:18000.0];
}

+ (NSDate *)FormatUserBanDateTime:(NSString *)banDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    return [dateFormatter dateFromString:banDateTime];
}

+ (NSString *)FormatDateToStringForSending:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    //[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString *dateString = [dateFormatter stringFromDate:date];
    if (dateString != nil)
        return dateString;
    
    return @"";
}




static int logtype = logTypeDebug;

+ (int)LogType
{
    return logtype;
}

+ (void)SetLogType:(int)logType
{
    logtype = logType;
}

+ (void)LogMessage:(NSString *)message MessageFlagType:(int)flagType
{
    switch (logtype)
    {
        case logTypeDebug:
            switch (flagType)
            {
                case logMessageFlagTypeError:
                    NSLog(@"[ERROR] = [%@]", message);
                    break;
                case logMessageFlagTypeSystem:
                    NSLog(@"[SYSTEM] = [%@]", message);
                    break;
                case logMessageFlagTypeWarning:
                    NSLog(@"[WARNING] = [%@]", message);
                    break;
                case logMessageFlagTypeInfo:
                    NSLog(@"[INFO] = [%@]", message);
                    break;
            }
            break;
            
        case logTypeRelease:
            switch (flagType)
            {
                case logMessageFlagTypeError:
                    NSLog(@"[ERROR] = [%@]", message);
                    break;
                case logMessageFlagTypeSystem:
                    NSLog(@"[SYSTEM] = [%@]", message);
                    break;
            }
            break;
        
        case logTypeNone:
        case logTypeErrorOnly:
        case logTypeInfoOnly:
        case logTypeSystemOnly:
        case logTypeWarningOnly:
        default:
            if (logtype == logTypeErrorOnly && flagType == logMessageFlagTypeError)
                NSLog(@"[ERROR] = [%@]", message);
            if (logtype == logTypeInfoOnly && flagType == logMessageFlagTypeInfo)
                NSLog(@"[INFO] = [%@]", message);
            if (logtype == logTypeWarningOnly && flagType == logMessageFlagTypeWarning)
                NSLog(@"[WARNING] = [%@]", message);
            if (logtype == logTypeSystemOnly && flagType == logMessageFlagTypeSystem)
                NSLog(@"[SYSTEM] = [%@]", message);
            break;
    }
}


+ (void)AppSetValue:(NSObject *)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}
+ (NSObject *)AppGetValueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end







@implementation NSString (CommonTasks)

- (BOOL)isEmptyOrWhiteSpaces
{
    if ([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0)
        return NO;
    return YES;
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSString *)Empty
{
    return @"";
}

@end
