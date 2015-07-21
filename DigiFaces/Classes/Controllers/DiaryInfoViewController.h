//
//  DiaryInfoViewController.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyDiary.h"
#import "DiaryTheme.h"

@interface DiaryInfoViewController : UITableViewController

@property (nonatomic, retain) DailyDiary * dailyDiary;
@property (nonatomic, assign) BOOL isViewOnly;
@property (nonatomic, retain) DiaryTheme * diaryTheme;

- (IBAction)closeThis:(id)sender;

@end
