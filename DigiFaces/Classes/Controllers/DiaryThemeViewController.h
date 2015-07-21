//
//  DiaryThemeViewController.h
//  DigiFaces
//
//  Created by confiz on 28/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyDiary.h"
#import "DiaryTheme.h"

@interface DiaryThemeViewController : UITableViewController

@property (nonatomic, retain) DailyDiary * dailyDiary;
@property (nonatomic, retain) DiaryTheme * diaryTheme;

@end
