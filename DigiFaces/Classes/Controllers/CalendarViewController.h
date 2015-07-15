//
//  CalendarViewController.h
//  DigiFaces
//
//  Created by confiz on 07/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarViewControlerDelegate <NSObject>

-(void)calendarController:(id)controller didSelectDate:(NSDate*)date;

@end

@interface CalendarViewController : UIViewController

@property (nonatomic, assign) id<CalendarViewControlerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constContentHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;

- (IBAction)applyDate:(id)sender;
- (IBAction)gotoPreviousMonth:(id)sender;
- (IBAction)gotoNextMonth:(id)sender;

@end
