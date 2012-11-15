//
//  CUtils.h
//  Senti
//
//  Created by Wony Shin on 11/14/12.
//  Copyright 2011 Senti. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CUtils : NSObject {

}

+ (NSString *)getDeviceID;
+ (NSString *)getFilePath:(NSString *)fileName;
+ (BOOL)isFileInDocumentDirectory:(NSString *)fileName;
+ (void)copyFileToDocumentDirectory:(NSString *)fileName;
+ (NSString *)getDocumentDirectory;
+ (NSString *)generateFileName: (BOOL) bMovie;
+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (NSString *)convertToLocalTime:(NSString *)GMTtime;
+ (NSString *)getCurrentTime;
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;
+ (NSInteger)getAge:(NSString *)dateOfBirth;
+ (BOOL) isIphone5;

@end
