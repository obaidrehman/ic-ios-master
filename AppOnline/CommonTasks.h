//
//  CommonTasks.h
//  AppOnline
//
//  Created by user on 1/6/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <Foundation/Foundation.h>

enum LogTypes
{
    logTypeNone,
    logTypeDebug,
    logTypeRelease,
    logTypeErrorOnly,
    logTypeWarningOnly,
    logTypeInfoOnly,
    logTypeSystemOnly,
};

enum LogMessageFlagType
{
    logMessageFlagTypeError,
    logMessageFlagTypeInfo,
    logMessageFlagTypeWarning,
    logMessageFlagTypeSystem,
};

@interface CommonTasks : NSObject

/// @description this method returns the Document folder in the application isolated storage
/// @returns path to the documents directory
+ (NSString *) ApplicationDocumentsDirectory;

/// @description creates a new file with provided string content in the application isolated storage document's directory, if the file already exists it is deleted and recreated with the new content
/// @param content the content to fill in the file, this is in NSString format
/// @param fileName the name of the file to create, this is in NSString format
+ (void)FileCreateWithContent:(NSString*)content fileName:(NSString*)fileName;

/// @description creates a new file with provided string content at the file path, if the file already exists it is deleted and recreated with the new content
/// @param content the content to fill in the file, this is in NSString format
/// @param filePath the path + name of the file to create, this is in NSString format
+ (void)FileCreateWithContent:(NSString *)content filePath:(NSString *)filePath;

/// @description creates a new file with provided bytes content in the application isolated storage document's directory, if the file already exists it is deleted and recreated with the new content
/// @param content the content to fill in the file, this is in NSData format
/// @param fileName the name of the file to create, this is in NSString format
+ (void)FileCreateWithData:(NSData *)content fileName:(NSString *)fileName;

/// @description creates a new file with provided bytes content at the file path, if the file already exists it is deleted and recreated with the new content
/// @param content the content to fill in the file, this is in NSData format
/// @param filePath the path + name of the file to create, this is in NSString format
+ (void)FileCreateWithData:(NSData *)content filePath:(NSString *)filePath;

/// @description delete the file from the applications isolated storage document's directory
/// @param fileName the name of the file to delete
+ (void)FileDeleteWithName:(NSString*)fileName;

/// @description delete the file from the path provided
/// @param filePath this is the path + name of the file to delete
+ (void)FileDeleteAtPath:(NSString *)filePath;

/// @description reads the content of the file
/// @param fileName the name of the file
/// @returns the file content as NSData or nil if file is empty or does not exists
+ (NSData*)FileReadWithName:(NSString*)fileName;

/// @description reads the content of the file at path
/// @param filePath the path + name of the file
/// @returns the file content as NSData or nil if file is empty or does not exists
+ (NSData*)FileReadAtPath:(NSString *)filePath;



/// @description provides the device unique identifier code
/// @returns the identity code as a string
+ (NSString*)MachineCode;

/// @description provides the device related information
/// @returns the device info as a string
+ (NSString*)SystemInfo;

/// @description check and tells if user using iPhone or iPad
/// @returns return YES if user using iPhone, return NO if user using iPad;
+ (BOOL)DeviceTypeiPhone;

/// @description this returns device orientation
/// @returns YES if device in potrait else NO for landscape
+ (BOOL)DeviceOrientationPotrait;

/// @description this gets the user device IP address
/// @returns IP address as a string
+ (NSString *)GetIPAddress;

/// @description this gets the user device IP address
/// @param preferIPv4 just keep this YES
/// @returns IP address as a string
+ (NSString *)GetIPAddress:(BOOL)preferIPv4;



// strings _______________________________________________________________________________________

/// @description use it where you need it... (www.imdb.com = The Good, the Bad and the Ugly (1966))
/// @returns the good string
+ (NSString*)Good;
/// @description use it where you need it... (www.imdb.com = The Good, the Bad and the Ugly (1966))
/// @returns the bad string
+ (NSString*)Bad;
/// @description use it where you need it... (www.imdb.com = The Good, the Bad and the Ugly (1966))
/// @returns the ugly string
+ (NSString*)Ugly;

/// @description very useful identifier for online communication, this is the app platform name + version > e.g. "iOS 1.0"
/// @returns "ios"
+ (NSString*)iOS;

/// @description this returns just the current version of app
+ (NSString*)Version;

/// @description returns an engine name
/// @returns "McLaren F1 MP4-30 Engine xD"
+ (NSString*)GetEngineName;

/// @description this is just a True
+ (NSString*)TrueLies;
/// @description this is just a False
+ (NSString*)Falsehood;

/// @description web address for Infinity Chess website
+ (NSString*)InfinityChessWebsite;

/// @description this returns a left arrow
+ (NSString*)LeftArrowString;
/// @description this returns a left arrow
+ (NSString*)RightArrowString;
/// @description this returns a left arrow
+ (NSString*)TopArrowString;
/// @description this returns a left arrow
+ (NSString*)BottomArrowString;
/// @description this returns a return arrow
+ (NSString*)ReturnArrowString;
/// @description this returns a refresh arrow
+ (NSString*)RefreshClockWiseArrowString;
/// @description this returns a refresh arrow
+ (NSString*)RefreshAntiClockWiseArrowString;
/// @description this returns a enter arrow
+ (NSString*)EnterArrowString;
/// @description this returns a refresh arrow
+ (NSString*)GoArrowString;
/// @description this returns a zero as string @"0"
+ (NSString*)Zero;
/// @description this returns a square shape
+ (NSString*)SquareString;


// crypto _______________________________________________________________________________________

/// @description this method apply rijndael crytography for encryption or decrypting passwords in .net server
///
/// usage:
///
/// NSString *passwordString = @"isadmin";
///
/// NSData *passwordData = [CommonTasks DoCipher:[passwordString dataUsingEncoding:NSUTF8StringEncoding] ToEncrypt:YES];
///
/// passwordString = [passwordData base64EncodedStringWithOptions:0];
///
/// NSLog(@"pass = [%@]", passwordString);
///
/// passwordData = [CommonTasks DoCipher:[[NSData alloc] initWithBase64EncodedString:passwordString options:0] ToEncrypt:NO];
///
/// passwordString = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
///
/// NSLog(@"pass = [%@]", passwordString);
/// @param plainText this is the data to encrypt or decrypt
/// @param encryptORdecrypt YES to encrypt and NO to decrypt
/// @returns data as either encrypted or decrypted format as specified during method call
+ (NSData *)DoCipher:(NSData *)plainText ToEncrypt:(BOOL)encryptORdecrypt;



/// async calls ___________________________________________________________________

/// @description performs a task asynchronusly by dispatching it on the global queue
///
/// NOTE: use this for any non UI update stuff or tasks
+ (void)DoAsyncTaskOnGlobalQueue:(void (^)(void))asyncTask;

/// @description performs a task asynchronusly by dispatching it on the main queue
///
/// NOTE: use this for any UI update stuff or tasks
+ (void)DoAsyncTaskOnMainQueue:(void (^)(void))asyncTask;

/// @description performs a task asynchronusly by dispatching it on a custom thread
///
/// NOTE: use this for any online communication stuff only!
+ (void)DoAsyncTaskOnNetworkingQueue:(void (^)(void))asyncTask;



// datetime _______________________________________________________________________

/// @description use this to set the ServerDateTime property, it works for "MM/dd/yyyy hh:mm:ss a" formatted date only!
/// @param serverDateTime a datetime string usually form the packet recieved by the server, formatted as "MM/dd/yyyy hh:mm:ss a"
/// @returns the server time in NSDate format
+ (NSDate*)FormatServerDateTime:(NSString *)serverDateTime;

/// @description use this to set the BanDateTime property, it works for "yyyy-MM-dd HH:mm:ss.SSS" formatted date only!
/// @param banDateTime a datetime string usually form the packet recieved by the server, formatted as "yyyy-MM-dd HH:mm:ss.SSS"
/// @returns the datetime as NSDate format
+ (NSDate*)FormatUserBanDateTime:(NSString*)banDateTime;

/// @description use this to format date into string and send within packets where needed
/// @param date this is the NSDate date
/// @returns a string format date that can be send to .Net server
+ (NSString*)FormatDateToStringForSending:(NSDate*)date;





// logs __________________________________________________________________________

/// @description the log type in use
+ (int)LogType;
/// @description set the log type as LogMessages will work using LogType only
+ (void)SetLogType:(int)logType;
/// @description logs a messages, this depends on the LogType and LogMessageFlagType 
+ (void)LogMessage:(NSString*)message MessageFlagType:(int)flagType;





// app storage keys - values _____________________________________________________

/// @description this sets the value for the key in app storage
+ (void) AppSetValue:(NSObject*)value forKey:(NSString*)key;
/// @description this gets the value for the key from app storage
+ (NSObject*) AppGetValueForKey:(NSString*)key;

@end





@interface NSString (CommonTasks)

/// @description a property applied to any NSString to check if the string is empty or white spaces
@property (readonly) BOOL isEmptyOrWhiteSpaces;

/// @description returns a trimmed string, removes leading and ending whitespaces
@property (readonly) NSString* trim;

/// @Description returns an empty string @""
+ (NSString*) Empty;

@end
