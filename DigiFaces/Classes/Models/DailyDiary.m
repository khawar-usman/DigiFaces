//
//  DailyDiary.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "DailyDiary.h"

@implementation DailyDiary

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.diaryID = [[dict valueForKey:@"DiaryId"] integerValue];
        self.activityId = [[dict valueForKey:@"ActivityId"] integerValue];
        self.diaryQuestion = [dict valueForKey:@"DiaryQuestion"];
        
        _userDiaries = [[NSMutableArray alloc] init];
        if ([[dict valueForKey:@"UserDiaries"] count]>0) {
            for (NSDictionary * dict in [dict valueForKey:@"UserDiaries"]) {
                // Add user diaries here
            }
        }
    }
    return self;
}

@end
