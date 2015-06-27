//
//  UserManagerShared.m
//  DigiFaces
//
//  Created by Apple on 16/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "UserManagerShared.h"

@implementation UserManagerShared
+ (id)sharedManager {
    static UserManagerShared *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.projectsArray = [[NSArray alloc]init];
        self.profilePic = [[UIImage alloc]init];
    }
    return self;
}

-(void)setUserInfoDictionary:(NSDictionary*)dict
{   
    _info = [[UserInfo alloc] initWithDictioanry:dict];
    _avatarFile = [[File alloc] initWithDictionary:[dict valueForKey:@"AvatarFile"]];
    
    _currentProject = [[Project alloc] initWithDictionary:[dict valueForKey:@"CurrentProject"]];
}

@end
