//
//  DataKeeper.h
//  Bunker Glam
//
//  Created by Wony Shin on 10/19/12.
//  Copyright 2012 Bunker Glam. All rights reserved.
//  

#import "SingletonClass.h"
#import "Communication.h"
#import "CUserInfo.h"

@interface DataKeeper : SingletonClass {
    
    // communicator
    Communication *communication;
    
    // Guest Array
    NSMutableArray *m_arrayGuests;
    
    // Checkin Array
    NSMutableArray *m_arrayCheckins;

    NSString    *m_strLastErrorMessage;
    
    NSMutableDictionary *m_dictLocalImageCaches;
    
}

@property (nonatomic, retain) NSString *m_strUserID;
@property (nonatomic, retain) NSString *m_strUserCode;

@property (nonatomic, retain) NSMutableArray *m_arrayGuests;
@property (nonatomic, retain) NSMutableArray *m_arrayCheckins;

@property (nonatomic, retain) NSString *m_strAlreadyCheckinMsg;

@property (nonatomic, retain) Communication *communication;

@property (nonatomic, retain) NSString    *m_strLastErrorMessage;
@property (nonatomic, retain) NSMutableDictionary *m_dictLocalImageCaches;

@property (nonatomic) BOOL m_bQuizStart;
@property (nonatomic) BOOL m_bLogin;
@property (nonatomic) BOOL m_bShouldRefresh;

@property (nonatomic)  BOOL m_bPossibleClear;

// communication APIs

- (BOOL)UpdateList: (NSString *)userID code: (NSString *)userCode deviceID: (NSString *) deviceID updatedDate: (NSString *) updatedDate;

- (BOOL) SubmitCheckins;
- (NSString *) md5:(NSString *) input;

- (UIImage *)getImage: (NSString *) strURL;
- (UIImage *)getLocalImage: (NSString *) strURL;

- (BOOL)saveDataToFile;
- (BOOL)loadDataFromFile;
- (NSString*)dataFilePath;

- (void)CreateThreadDownloadImages;
- (void) DownloadImages;

@end
