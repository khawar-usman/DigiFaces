//
//  UserInfo.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface UserInfo : NSObject

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, assign) BOOL isUserNameSet;
@property (nonatomic, retain) NSString * appUserName;
@property (nonatomic, assign) BOOL isModerator;
@property (nonatomic, assign) NSInteger defaultLanguageID;
@property (nonatomic, assign) NSInteger avatarFileID;
@property (nonatomic, assign) NSInteger currentProjectID;
@property (nonatomic, retain) NSString * aboutMeText;
@property (nonatomic, assign) BOOL hasRegistered;

@property (nonatomic, retain) File * avatarFile;

-(instancetype) initWithDictioanry:(NSDictionary*)dict;

@end
