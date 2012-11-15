//
//  DataKeeper.m
//  Bunker Glam
//
//  Created by Wony Shin on 10/19/12.
//  Copyright 2012 Bunker Glam. All rights reserved.
//

#import "DataKeeper.h"

#import <CommonCrypto/CommonDigest.h>

@implementation DataKeeper

@synthesize communication;

@synthesize m_arrayGuests;
@synthesize m_arrayCheckins;

@synthesize m_strAlreadyCheckinMsg;
@synthesize m_strLastErrorMessage;

@synthesize m_dictLocalImageCaches;

@synthesize m_strUserID;
@synthesize m_strUserCode;

@synthesize m_bQuizStart;
@synthesize m_bLogin;
@synthesize m_bShouldRefresh;
@synthesize m_bPossibleClear;


- (id)init
{
    self = [super init];
    if (self) {
        
        ////////////////////////////////////////////
        //// Initialize
        ////////////////////////////////////////////
        
        communication = [[Communication alloc] init];
                
        m_arrayGuests = [[NSMutableArray alloc] init];
        
        m_arrayCheckins = [[NSMutableArray alloc] init];
            
        m_dictLocalImageCaches = [[NSMutableDictionary alloc] init];
        
        m_bShouldRefresh = NO;
        
        ////////////////////////////////////////////
    }
    
    return self;
}

- (void)dealloc
{
    [communication release];
    
    if (m_strLastErrorMessage != nil) {
        [m_strLastErrorMessage release];
    }
    
    if (m_strAlreadyCheckinMsg != nil) {
        [m_strAlreadyCheckinMsg release];
    }

    if (m_arrayGuests != nil) {
        [m_arrayGuests release];
    }
    
    if (m_arrayCheckins != nil) {
        [m_arrayCheckins release];
    }
    
    if (m_strUserID != nil) {
        [m_strUserID release];
    }
    
    if (m_strUserCode != nil) {
        [m_strUserCode release];
    }
    
    if (m_dictLocalImageCaches != nil) {
        [m_dictLocalImageCaches release];
    }
    
    [super dealloc];
}

- (BOOL)UpdateList: (NSString *)userID code: (NSString *)userCode deviceID: (NSString *) deviceID updatedDate: (NSString *) updatedDate {
    
    // Initial Checking...
    if (!userID || !userCode || !communication) {
        return NO;
    }

    // Read Datas...
    NSDictionary *respData;
    BOOL bResult = [communication UpdateList:userID password:userCode deviceID:deviceID lastUpdate:updatedDate respData:&respData];
    
    // Login Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    [self setM_strUserID: userID];
    [self setM_strUserCode: userCode];
    
    NSArray *arrayGuests = [respData objectForKey:@"Lists"];
    
    if (arrayGuests != nil) {
        [m_arrayGuests removeAllObjects];
        
        for (NSInteger nIndex = 0; nIndex < [arrayGuests count]; nIndex++) {
            NSDictionary *dictItem = [arrayGuests objectAtIndex: nIndex];
            CUserInfo *info = [[CUserInfo alloc] initWithDictionary:dictItem];
            [m_arrayGuests addObject: info];
            [info release];
        }
    
        [self CreateThreadDownloadImages];
    }
    
    [respData release];
    return YES;
}

- (void)CreateThreadDownloadImages {
    [NSThread detachNewThreadSelector:@selector(DownloadImages) toTarget:self withObject:nil];
}

- (void) DownloadImages {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    NSLog(@"Start Downloading....");
    for (NSInteger nIndex = 0; nIndex < [m_arrayGuests count]; nIndex++) {
        CUserInfo *info = [m_arrayGuests objectAtIndex: nIndex];
        [self getImage: info.picture];
        NSLog(@"Downloaded %@...", info.picture);
        
        if (nIndex % 10 == 0) {
            [self saveDataToFile];
       //     [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION object:nil];
        }
    }
    
    [self saveDataToFile];
    [autoreleasePool release];
}


- (BOOL) SubmitCheckins {
    // Initial Checking...
    if (!communication) {
        return NO;
    }
    
    NSMutableString *strCheckinCSV = [[NSMutableString alloc] init];
    
    for (NSInteger nIndex = 0; nIndex < [m_arrayCheckins count]; nIndex++) {
        
        NSDictionary *dictItem = [m_arrayCheckins objectAtIndex: nIndex];
        
        if (nIndex > 0) {
            [strCheckinCSV appendFormat:@"\n"];
        }
        NSString *strUserID = [dictItem objectForKey:@"userid"];
//        NSString *strUserGender = [dictItem objectForKey:@"gender"];
//        NSString *strUserBirthday = [dictItem objectForKey:@"birthday"];
//        NSString *strUserName = [dictItem objectForKey:@"fullname"];
//        NSString *strUserPicture = [dictItem objectForKey:@"picture"];
        NSString *strUserNote = [dictItem objectForKey:@"note"];
        NSString *strUserDate = [dictItem objectForKey:@"date"];
                
        [strCheckinCSV appendFormat:@"%@,%@,%@", strUserID, strUserNote, strUserDate];
    }
    
    NSLog(@"Checkin CSV Start ----------------------");
    NSLog(@"%@", strCheckinCSV);
    NSLog(@"Checkin CSV End ----------------------");
    
    // Read Datas...
    NSDictionary *respData;
    BOOL bResult = [communication SubmitCheckins:m_strUserID password:m_strUserCode deviceID:[CUtils getDeviceID] lastUpdate:@"" CSV:strCheckinCSV respData:&respData];
    
    [strCheckinCSV release];
    
    // Login Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    [respData release];
    return YES;
 
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  [output uppercaseString];
    
}


// This functions is to get Image from URL
// If the image isnt in local, download and save to local
// If the image is already in local, use it.

- (UIImage *)getImage: (NSString *) strURL {
    /*
    for (NSInteger nIndex = 0; nIndex < [[m_dictLocalImageCaches allKeys] count]; nIndex++) {
        NSString *strKey = [[m_dictLocalImageCaches allKeys] objectAtIndex: nIndex];
        
        NSString *strVal = [m_dictLocalImageCaches objectForKey: strKey];
        
        NSLog(@"Image (%@) : %@", strKey, strVal);
    }
     */
    
    // Get Local URL of image
    NSString *strLocalURL = [m_dictLocalImageCaches objectForKey:strURL];
    
    UIImage *image;
    
    // If image isnt in local, download and save it to local.
    if (strLocalURL == nil || [strLocalURL isEqualToString:@""]) {
        
        // Get image data from URL.
        NSData* imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: 
                                                                 strURL]];
        
        // Generate local file name
        NSString *strFileName = [CUtils generateFileName: NO];
        
        NSString *tempPath = [NSString stringWithFormat:@"%@/%@",[CUtils getDocumentDirectory], strFileName];
        
        // Write Image data as a local file.
        if ([imgData length] != 0) {
            if ([imgData writeToFile:tempPath atomically:YES] == YES) {
                [m_dictLocalImageCaches setObject:tempPath forKey:strURL];
            }
            
            image = [UIImage imageWithData:imgData];
            
            if (!image)
                image = nil;
        } else {
            image = nil;
        }
        
        [imgData release];        
    } else {
    // If image is already in local, use it.
       image = [UIImage imageWithContentsOfFile: strLocalURL];
    }
    
    return image;
}

- (UIImage *)getLocalImage: (NSString *) strURL {
    /*
     for (NSInteger nIndex = 0; nIndex < [[m_dictLocalImageCaches allKeys] count]; nIndex++) {
     NSString *strKey = [[m_dictLocalImageCaches allKeys] objectAtIndex: nIndex];
     
     NSString *strVal = [m_dictLocalImageCaches objectForKey: strKey];
     
     NSLog(@"Image (%@) : %@", strKey, strVal);
     }
     */
    
    // Get Local URL of image
    NSString *strLocalURL = [m_dictLocalImageCaches objectForKey:strURL];
    
    UIImage *image;
    
    // If image isnt in local, download and save it to local.
    if (strLocalURL == nil || [strLocalURL isEqualToString:@""]) {
        return nil;
    } else {
        // If image is already in local, use it.
        image = [UIImage imageWithContentsOfFile: strLocalURL];
    }
    
    return image;
}


#pragma mark - Local Management

// All datas will be written in local file
// Guest List, Checkin List, Image List, User ID, Code

- (BOOL)saveDataToFile
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:m_dictLocalImageCaches forKey:@"images"];
    NSMutableArray *arrayTmp = [[NSMutableArray alloc] init];
    
    for (NSInteger nIndex = 0; nIndex < [m_arrayGuests count]; nIndex++) {
        CUserInfo *userInfo = [m_arrayGuests objectAtIndex: nIndex];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:userInfo._id, @"UserID", userInfo.code, @"Code", userInfo.fullname, @"FullName", userInfo.gender, @"Gender", userInfo.birthday, @"Birthday", userInfo.picture, @"Picture", userInfo.note, @"Note", userInfo.access, @"Access", userInfo.updated, @"Updated", nil];
        
       // NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:userInfo._id, @"id", userInfo.dispname, @"dispname", nil];
        
        
        [arrayTmp addObject: dict];
        
        [dict release];
    }
    [dic setValue:arrayTmp forKey:@"lists"];
    [dic setValue:m_arrayCheckins forKey:@"checkins"];
    [dic setValue:m_strUserID forKey:@"userid"];
    [dic setValue:m_strUserCode forKey:@"code"];
    [dic setValue:[NSString stringWithFormat:@"%d", m_bPossibleClear] forKey:@"possible_clear"];
        
    BOOL bSuccess = [dic writeToFile:[self dataFilePath] atomically:YES];
    
    [dic release];
    if (bSuccess) {
        NSLog(@"Write to file successfully");
    } else {
        NSLog(@"Write to file failed");
    }
    
    return bSuccess;
}

- (BOOL)loadDataFromFile
{
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        [self setM_strUserID:[dic objectForKey:@"userid"]];
        [self setM_strUserCode:[dic objectForKey:@"code"]];
        NSString *strPossibleClear = [dic objectForKey:@"possible_clear"];
        [self setM_bPossibleClear: [strPossibleClear boolValue]];
        
        NSMutableArray *arrayCheckins = [dic objectForKey:@"checkins"];
        
        if (arrayCheckins != nil && [arrayCheckins count] > 0) {
            [self setM_arrayCheckins: arrayCheckins];
        }
        
        
        NSDictionary *dict = [dic objectForKey:@"images"];
        if (dict != nil && [dict count] > 0) {
            [self setM_dictLocalImageCaches: [dic objectForKey:@"images"]];
        }
        
        NSArray *array = [dic objectForKey:@"lists"];
        
        if (array != nil && [array count] > 0) {
            [m_arrayGuests removeAllObjects];
            for (NSInteger nIndex = 0; nIndex < [array count]; nIndex++) {
                NSDictionary *dictItem = [array objectAtIndex: nIndex];
                CUserInfo *userInfo = [[CUserInfo alloc] initWithDictionary: dictItem];
                [m_arrayGuests addObject: userInfo];
                [userInfo release];
            }
        }
        [dic release];
        return YES;
    }
    
    // if file is not exist, set default value
    //[self setServerAddress:[NSString stringWithString:@"http://develop.sweneno.com/index.php/"]];
    
    return NO;
}

- (NSString*)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"bunkerglam.plist"];
}
@end