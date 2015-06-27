//
//  Notification.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface Notification : NSObject

@property (nonatomic, retain) UserInfo * commenterUserInfo;
@property (nonatomic, assign) NSInteger activityID;
@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormated;
@property (nonatomic, assign) BOOL isDailyNotification;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) NSInteger notificationID;
@property (nonatomic, retain) NSString * notificationType;
@property (nonatomic, assign) NSInteger notificationTypeID;
@property (nonatomic, assign) NSInteger projectID;
@property (nonatomic, retain) NSString * userID;

-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end
