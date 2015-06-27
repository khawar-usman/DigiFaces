//
//  UserInfo.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

-(instancetype) initWithDictioanry:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.userID = [[dict valueForKey:@"Id"] integerValue];
        self.firstName = [dict valueForKey:@"FirstName"];
        self.lastName = [dict valueForKey:@"LastName"];
        self.isUserNameSet = [[dict valueForKey:@"IsUserNameSet"] boolValue];
        self.appUserName = [dict valueForKey:@"AppUserName"];
        self.isModerator = [[dict valueForKey:@"IsModerator"] boolValue];
        self.defaultLanguageID = [[dict valueForKey:@"DefaultLanguageId"] integerValue];
        self.avatarFileID = [[dict valueForKey:@"AvatarFileId"] integerValue];
        self.currentProjectID = [[dict valueForKey:@"CurrentProjectId"] integerValue];
        self.lastName = [dict valueForKey:@"AboutMeText"];
        self.hasRegistered = [[dict valueForKey:@"HasRegistered"] boolValue];
        
    }
    return self;
}

@end
