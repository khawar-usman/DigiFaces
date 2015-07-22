//
//  DiaryTheme.h
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Module.h"
#import "SDConstants.h"

@interface DiaryTheme : NSObject

@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, assign) NSInteger activityTypeId;
@property (nonatomic, assign) NSInteger parentActivityId;
@property (nonatomic, retain) NSString * activityTitle;
@property (nonatomic, retain) NSString * activityDesc;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) NSInteger unreadResponses;

@property (nonatomic, retain) NSMutableArray * modules;

-(instancetype) initWithDictionary:(NSDictionary*)dict;
-(Module*)getModuleWithThemeType:(ThemeType)type;

@end
