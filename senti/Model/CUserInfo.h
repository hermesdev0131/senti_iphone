//
//  CUserInfo.h
//  Bunker Glam
//
//  Created by Wony Shin on 10/19/12.
//  Copyright (c) 2012 Bunker Glam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CUserInfo : NSObject {
    
}

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *fullname;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *birthday;
@property (nonatomic, retain) NSString *picture;
@property (nonatomic, retain) NSString *note;
@property (nonatomic, retain) NSString *access;
@property (nonatomic, retain) NSString *updated;

- (id) initWithDictionary: (NSDictionary *)dict;

@end
