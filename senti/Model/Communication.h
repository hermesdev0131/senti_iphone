//
//  Communication.h
//  Bunker Glam
//
//  Created by Wony Shin on 10/19/12.
//  Copyright 2012 Bunker Glam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString *multipartBoundary;



// communication interface
@interface Communication : NSObject 

// Login
- (BOOL)UpdateList: (NSString *)userID password: (NSString *)userCode deviceID: (NSString *) deviceID lastUpdate: (NSString *) lastUpdate respData: (NSDictionary **)respData;

// Submit Checkins
- (BOOL)SubmitCheckins: (NSString *)userID password: (NSString *)userCode deviceID: (NSString *) deviceID lastUpdate: (NSString *) lastUpdate CSV: (NSString *) strCSV respData: (NSDictionary **)respData;

// internal function
- (BOOL)sendRequest:(NSString *)strService data:(NSString *)data respData:(NSDictionary **)respData;

//  Upload File
- (BOOL)sendMultipartRequest:(NSString *)strService data:(NSData *)data respData:(NSDictionary **)respDic;
+ (BOOL)uploadFile:(NSString *)strURL filename:(NSString *)filename fileData:(NSString *)fileData respData:(NSDictionary **)respDic;
- (NSData *)makeMultipartBody:(NSDictionary*)dic;
- (void)appendFileToBody:(NSMutableData *)data filenamekey:(NSString*)filenamekey filenamevalue:(NSString*)filenamevalue filedata:(NSData*)filedata;

@end
