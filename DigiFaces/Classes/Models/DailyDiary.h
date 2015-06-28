//
//  DailyDiary.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface DailyDiary : NSObject

@property (nonatomic, assign) NSInteger diaryID;
@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, retain) NSString * diaryQuestion;

@property (nonatomic, retain) File * file;

@property (nonatomic, retain) NSMutableArray * userDiaries;

@property (nonatomic, retain) NSMutableDictionary * diariesDict;
@property (nonatomic, retain) NSMutableArray * diariesDate;

-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end
