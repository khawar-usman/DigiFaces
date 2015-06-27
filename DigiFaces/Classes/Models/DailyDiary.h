//
//  DailyDiary.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyDiary : NSObject

@property (nonatomic, assign) NSInteger diaryID;
@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, retain) NSString * diaryQuestion;

@property (nonatomic, retain) NSMutableArray * userDiaries;

-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end
