//
//  Communication.m
//  Bunker Glam
//
//  Created by Wony Shin on 10/19/12.
//  Copyright 2012 Bunker Glam. All rights reserved.
//

#import "Communication.h"
#import "DataKeeper.h"
#import "../JSON/JSON.h"

const NSString *multipartBoundary = @"-------------111";

///
// Implementation for Communication class
///
@implementation Communication

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

///
//  API:    Update List
//  Param:  User ID, Code, deviceID, lastUpdate
///
- (BOOL)UpdateList: (NSString *)userID password: (NSString *)userCode deviceID: (NSString *) deviceID lastUpdate: (NSString *) lastUpdate respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_LIST] autorelease];
    
    NSMutableString *strRequestParams = [[[NSMutableString alloc] initWithFormat:@"id=%@&code=%@&device=%@",userID, userCode, deviceID] autorelease];
    
    if (lastUpdate != nil && [lastUpdate isEqualToString:@""] == NO) {
        [strRequestParams appendFormat:@"&last_update=%@", lastUpdate];
    }
    
    NSLog(@"UpdateList Param: %@", strRequestParams);
    
    return [self sendRequest:strAction data:strRequestParams respData:respData];
}


- (BOOL)SubmitCheckins: (NSString *)userID password: (NSString *)userCode deviceID: (NSString *) deviceID lastUpdate: (NSString *) lastUpdate CSV: (NSString *) strCSV respData: (NSDictionary **)respData {
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_CHECKINS] autorelease];
    
    NSMutableString *strRequestParams = [[[NSMutableString alloc] initWithFormat:@"id=%@&code=%@&device=%@&checkins=%@",userID, userCode, deviceID, strCSV] autorelease];
    
    NSLog(@"UpdateList Param: %@", strRequestParams);
    
    return [self sendRequest:strAction data:strRequestParams respData:respData];
}


// parameter - respData is reatined in this function
- (BOOL)sendRequest:(NSString *)strService data:(NSString *)data respData:(NSDictionary **)respData;
{
    NSMutableString *strURL = [NSMutableString stringWithString:strService];
    NSLog(@"URL: %@", strURL);

    NSURL *url = [NSURL URLWithString:strURL]; 
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    NSHTTPURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (!response) {
        // "Connection Error", "Failed to Connect to the Internet"
        NSLog(@"%@", [error description]);
        return NO;
    }
    
    NSLog(@"status code = %d", [response statusCode]);
    
    if ([response statusCode] != 200) {
        NSLog(@"Error!!!");
        return NO;
    }
    
    NSString *respString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"RECEIVED DATA : %@", respString);

    SBJSON *parser = [[[SBJSON alloc] init] autorelease];
    NSDictionary *dic = (NSDictionary *)[parser objectWithString:respString error:nil];
    if (dic == nil) 
        return NO;  // invalid JSON format

    [dic retain];
    *respData = dic;
    return YES;
}


///////////////////////////////////////////////
///////// File Upload
///////////////////////////////////////////////


- (BOOL)sendMultipartRequest:(NSString *)strService data:(NSData *)data respData:(NSDictionary **)respDic
{
    NSMutableString *strURL = [NSMutableString stringWithString:strService];
    
    NSLog(@"URL: %@", strURL);
    NSLog(@"PARAMS: %@", data);
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", multipartBoundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    NSError *error;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!response) {
        // "Connection Error", "Failed to Connect to the URL"
        NSLog(@"%@", [error description]);
        return NO;
    }
    
    NSString *respString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"RECEIVED DATA : %@", respString);
    
    SBJSON *parser = [[[SBJSON alloc] init] autorelease];
    NSDictionary *dic = (NSDictionary *)[parser objectWithString:respString error:nil];
    if (dic == nil) 
        return NO;  // invalid JSON format
    
    [dic retain];
    *respDic = dic;
    return YES;
}

+ (BOOL)uploadFile:(NSString *)strURL filename:(NSString *)filename fileData:(NSString *)fileData respData:(NSDictionary **)respDic {
    
    NSLog(@"URL: %@", strURL);
    NSLog(@"FileName: %@", filename);
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", multipartBoundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"orderfile\"; filename=\"%@\"\r\n", filename]] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-type: application/octet-stream\r\n\r\n" dataUsingEncoding: NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"%@", fileData]] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody: body];
    
    NSError *error;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!response) {
        // "Connection Error", "Failed to Connect to the URL"
        NSLog(@"%@", [error description]);
        return NO;
    }
    
    NSString *respString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"RECEIVED DATA : %@", respString);
    
    SBJSON *parser = [[[SBJSON alloc] init] autorelease];
    NSDictionary *dic = (NSDictionary *)[parser objectWithString:respString error:nil];
    if (dic == nil) 
        return NO;  // invalid JSON format
    
    [dic retain];
    *respDic = dic;
    return YES;
}


- (NSData *)makeMultipartBody:(NSDictionary*)dic {
	
	NSMutableData *data = [NSMutableData data];
	
    for (NSString *key in dic) {
        NSString *value = [dic objectForKey:key];
        // set boundary
        [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, value] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *logString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   // NSLog(@"%@", logString);
    [logString release];
    
    return data;
}

- (void)appendFileToBody:(NSMutableData *)data filenamekey:(NSString*)filenamekey filenamevalue:(NSString*)filenamevalue filedata:(NSData*)filedata {
	[data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[data appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", filenamekey, filenamevalue]] dataUsingEncoding:NSUTF8StringEncoding]];
	[data appendData:[@"Content-type: application/octet-stream\r\n\r\n" dataUsingEncoding: NSUTF8StringEncoding]];
	[data appendData:filedata];
	[data appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
}


@end

