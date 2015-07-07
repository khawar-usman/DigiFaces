//
//  AddResponseViewController.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyDiary.h"

@interface AddResponseViewController : UIViewController

@property (nonatomic, retain) DailyDiary * dailyDiary;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera1;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera2;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera3;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera4;

@property (weak, nonatomic) IBOutlet UITextView *txtResponse;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constDateHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constTitleHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constBottomViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnViewQuestion;
- (IBAction)exitOnEnd:(id)sender;
- (IBAction)viewQuestion:(id)sender;
- (IBAction)cameraSwitched:(id)sender;
- (IBAction)selectDate:(id)sender;
- (IBAction)addPicture:(id)sender;
@end
