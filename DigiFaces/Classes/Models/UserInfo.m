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
        self.Id = [[dict valueForKey:@"Id"] integerValue];
        self.userId = [dict valueForKey:@"UserId"];
        self.firstName = [dict valueForKey:@"FirstName"];
        self.lastName = [dict valueForKey:@"LastName"];
        self.isUserNameSet = [[dict valueForKey:@"IsUserNameSet"] boolValue];
        self.appUserName = [dict valueForKey:@"AppUserName"];
        self.isModerator = [[dict valueForKey:@"IsModerator"] boolValue];
        self.defaultLanguageID = [[dict valueForKey:@"DefaultLanguageId"] integerValue];
        self.avatarFileID = [[dict valueForKey:@"AvatarFileId"] integerValue];
        self.currentProjectID = [[dict valueForKey:@"CurrentProjectId"] integerValue];
        self.aboutMeText = [dict valueForKey:@"AboutMeText"];
        self.hasRegistered = [[dict valueForKey:@"HasRegistered"] boolValue];
        
        if ([dict valueForKey:@"AvatarFile"]) {
            _avatarFile = [[File alloc] initWithDictionary:[dict valueForKey:@"AvatarFile"]];
        }
        
    }
    return self;
}

-(NSDictionary *)getUserInfoDictionary
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:_userId forKey:@"UserId"];
    [dict setObject:_appUserName forKey:@"AppUserName"];
    [dict setObject:_aboutMeText forKey:@"AboutMeText"];
    [dict setObject:@(_avatarFileID) forKey:@"AvatarFileId"];
    [dict setObject:[_avatarFile fileDictionary] forKey:@"AvatarFile"];
    return dict;
}

@end
