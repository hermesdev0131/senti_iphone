//
//  CUtils.m
//  Senti
//
//  Created by Wony Shin on 11/14/12.
//  Copyright 2012 Senti. All rights reserved.
//

#import "CUtils.h"


@implementation CUtils

+ (NSString *)getDeviceID
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFUUIDCreateString(NULL,uuidRef);
    
    CFRelease(uuidRef);
    
    return uuidString;

}

+ (NSString *)getDocumentDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

+ (NSString *)generateFileName: (BOOL) bMovie {
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"MMddyyyy_HH_mm_ss"];
    NSString *date_str = [dateFormatter stringFromDate:currDate];
    NSString *strFileName;
    
    NSInteger randomNumber = arc4random() % 10000;
    
    if (bMovie == YES) {
        strFileName = [NSString stringWithFormat:@"senti%@.mp4", date_str];
    } else {
        strFileName = [NSString stringWithFormat:@"senti%@_%d", date_str, randomNumber];
    }
    
    [strFileName retain];
    
    return strFileName;
}
	
+ (NSString *)getFilePath:(NSString *)fileName
{
	NSArray *fileComponents = [NSArray arrayWithArray:[fileName componentsSeparatedByString:@"."]];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileComponents objectAtIndex:0] ofType:[fileComponents objectAtIndex:1]];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
	BOOL isAtPath = [fileManager fileExistsAtPath:path];
	
	if(isAtPath)
	{
		return path;
	}
	else
	{
		return filePath;
	}
	
}

+ (BOOL)isFileInDocumentDirectory:(NSString *)fileName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isFileAtPath = [fileManager fileExistsAtPath:path];
	return isFileAtPath;
}

+ (void)copyFileToDocumentDirectory:(NSString *)fileName
{
	NSString *pathOfFile = [self getFilePath:fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *docDir = [self getDocumentDirectory];
	NSString *desFilePath = [docDir stringByAppendingPathComponent:fileName];
	if([self isFileInDocumentDirectory:fileName])
	{
		
	}
	else
	{
		[fileManager copyItemAtPath:pathOfFile toPath:desFilePath error:nil];
	}
}


+ (NSString *)convertToLocalTime:(NSString *)GMTtime
{
    NSString *serverDateString = GMTtime;
    NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];
    [serverDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromServer = [serverDateFormatter dateFromString:serverDateString];
    [serverDateFormatter release];
    
    NSDateFormatter *dateFormatConverter = [[NSDateFormatter alloc] init];
    [dateFormatConverter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    /////////// GMT Logic ////
    NSDate* sourceDate = dateFromServer;
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
    /////// End GMT Logic /////
    
    NSString *localDate = [dateFormatConverter stringFromDate:destinationDate]; 
    
    return localDate;
    
}



+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

+ (NSString *)getCurrentTime {
    NSDate* date = [NSDate date];
    
  //  NSDate* newDate = [date addTimeInterval:3600*12];
    
    //Create the dateformatter object
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    //Set the required date format
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //Get the string date
    
    NSString* str = [formatter stringFromDate:date];
    
    
    
    //Display on the console
  //  NSLog(@"%@", [formatter stringFromDate: newDate]);
    
    return str;
    
}


+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    float width = size.width;
    float height = size.height;
    
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height; 
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor; 
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    if(height < width)
        rect.origin.y = height / 3;
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();   
    
    return smallImage;
}

+ (NSInteger)getAge:(NSString *)dateOfBirth {
    
    if (dateOfBirth == nil || [dateOfBirth length] < 9) {
        return 0;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *convertedDate = [df dateFromString:[dateOfBirth substringToIndex:[dateOfBirth length] - 9]];
    [df release];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:convertedDate];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
        return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
    } else {
        return [dateComponentsNow year] - [dateComponentsBirth year];
    }
}

// Check if current device is iPhone 5
// LOL, if height of screen is 568, yeah it's just iPhone 5!!!!!
+ (BOOL) isIphone5 {
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        return YES;
    }
    
    return NO;
}
@end
