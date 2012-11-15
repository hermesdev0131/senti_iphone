//
//  CUserInfo.m
//  Bunker Glam
//
//  Created by Wony Shin on 10/19/12.
//  Copyright (c) 2012 Bunker Glam. All rights reserved.
//

#import "CUserInfo.h"

@implementation CUserInfo

@synthesize _id, code, fullname;
@synthesize gender, birthday, picture;
@synthesize note, access, updated;

#pragma mark - init/dealloc functions

- (void)dealloc
{
    [_id release];
    [code release];
    [fullname release];
    [gender release];
    [birthday release];
    [picture release];
    [note release];
    [access release];
    [updated release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self._id = @"";
        self.code = @"";
        self.fullname = @"";
        self.gender = @"";
        self.birthday = @"";
        self.picture = @"";
        self.note = @"";
        self.access = @"";
        self.updated = @"";
    }
    return self;
}

- (id) initWithDictionary: (NSDictionary *)dict
{
    self = [super init];
    if (self)
    {        
        self._id            =   [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"UserID"]];
        self.code           =   [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"Code"]];
        self.fullname       =   [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"FullName"]];
        self.gender         =   [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"Gender"]];
        self.birthday       =   [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"Birthday"]];
        self.picture        =   [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"Picture"]];
        self.note           =   [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"Note"]];
        self.access         =   [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"Access"]];
        self.updated        =   [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"Updated"]];
        
        
        if (self._id == nil || [self._id length] <= 0) {
            self._id = @"";
        }
        
        if (self.code == nil || [self.code length] <= 0) {
            self.code = @"";
        }
        
        if (self.fullname == nil || [self.fullname length] <= 0) {
            self.fullname = @"";
        }
        
        if (self.gender == nil || [self.gender length] <= 0) {
            self.gender = @"";
        }
        
        if (self.birthday == nil || [self.birthday length] <= 0) {
            self.birthday = @"";
        }
        
        if (self.picture == nil || [self.picture length] <= 0) {
            self.picture = @"";
        }
        
        if (self.note == nil || [self.note length] <= 0) {
            self.note = @"";
        }
        
        if (self.access == nil || [self.access length] <= 0) {
            self.access = @"";
        }
        
        if (self.updated == nil || [self.updated length] <= 0) {
            self.updated = @"";
        }
    }
    return self;
}

@end
