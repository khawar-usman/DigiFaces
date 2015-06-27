//
//  Project.h
//  DigiFaces
//
//  Created by Apple on 16/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"

@interface Project : NSObject

@property (nonatomic, assign) NSInteger projectID;
@property (nonatomic, assign) NSInteger companyID;
@property (nonatomic, assign) NSInteger regionID;
@property (nonatomic, retain) NSString * projectInternalName;
@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) NSString * projectStartDate;
@property (nonatomic, retain) NSString * projectEndDate;
@property (nonatomic, assign) BOOL hasDailyDiary;
@property (nonatomic, retain) NSMutableArray * dailyDiaryList;
@property (nonatomic, assign) BOOL isTrial;
@property (nonatomic, assign) BOOL isActive;

@property (nonatomic, retain) Company * company;

-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end
