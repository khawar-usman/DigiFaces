//
//  Comment.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface Comment : NSObject

@property (nonatomic, assign) NSInteger commentID;
@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormated;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, assign) NSInteger threadID;
@property (nonatomic, retain) NSString * userID;

@property (nonatomic, retain) UserInfo * userInfo;

-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end
