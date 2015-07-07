//
//  CalendarViewController.m
//  DigiFaces
//
//  Created by confiz on 07/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "CalendarViewController.h"

#define kDayWidth   38
#define kDayHeight  38
#define kCalendarWidth  230
#define kCalendarHeightWithoutContent 115

@interface CalendarViewController()
{
    NSInteger month, year, day;
    UIButton * selectedDay;
}

@property (nonatomic, retain) NSArray * weekNames;
@property (nonatomic, retain) NSArray * monthDays;
@property (nonatomic, retain) NSCalendar *calendar;


@end

@implementation CalendarViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    _weekNames = [[NSArray alloc] initWithObjects:@"Monday", @"Tuesday", @"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday", nil];
    _monthDays = [[NSArray alloc] initWithObjects:@31, @28, @31, @30, @31, @30, @31, @31, @30, @31, @30, @31, nil];
    
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [self getMonthYear];
    [self loadCalendar];
}

-(NSInteger)dayOfWeek:(NSString*)day
{
    NSInteger dayNumber = 0;
    for (NSString * s in _weekNames) {
        if ([s isEqualToString:day]) {
            break;
        }
        dayNumber++;
    }
    return dayNumber;
}

-(void)getMonthYear
{
    NSDateComponents * component = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    year = component.year;
    month = component.month;
    day = component.day;
}

-(NSDate*)dateFromComponents:(NSInteger)d month:(NSInteger)m year:(NSInteger)y
{
    NSDateComponents * component = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:[NSDate date]];
    [component setDay:d];
    [component setYear:y];
    [component setMonth:m];
    NSDate * firstDayDate = [_calendar dateFromComponents:component];
    
    return firstDayDate;
}

-(NSInteger)firstDayOfCurrentMonth
{
    NSDateComponents * component = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:[NSDate date]];
    [component setDay:1];
    [component setYear:year];
    [component setMonth:month];
    
    NSDate * firstDayDate = [_calendar dateFromComponents:component];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSString * strDay = [dateFormatter stringFromDate:firstDayDate];
    NSInteger dayOfWeek = [self dayOfWeek:strDay];
    
    return dayOfWeek;
}

-(void)clearCalendar
{
    for (UIView * vu in self.contentView.subviews) {
        [vu removeFromSuperview];
    }
}

-(NSString*)getMonthName:(NSInteger)mon
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(mon-1)];
    return monthName;
}

-(void)updateTitle
{
    NSString * monthName = [self getMonthName:month];
    [_lblDate setText:[NSString stringWithFormat:@"%@ %d", monthName, year]];
}

-(void)updateCalendarHeightWithWeeks:(NSInteger)weeks
{
    int calendarHeight = kCalendarHeightWithoutContent + weeks * kDayHeight;
    self.constContentHeight.constant = calendarHeight;
}

-(void)loadCalendar
{
    [self clearCalendar];
    NSInteger firstDay = [self firstDayOfCurrentMonth];
    NSInteger totalDays = [[_monthDays objectAtIndex:month-1] integerValue];
    int xOffset = firstDay * kDayWidth;
    int yOffset = 1;
    int weeks = 1;
    for (int i=0; i<totalDays; i++) {
        
        UIButton * btn = [self getButtonForDay:i];
        CGRect rect = btn.frame;
        rect.origin.x = xOffset;
        rect.origin.y = yOffset;
        [btn setFrame:rect];
        
        [self.contentView addSubview:btn];
        xOffset += kDayWidth;
        if (xOffset>kCalendarWidth) {
            xOffset = 0;
            yOffset += kDayHeight;
            weeks++;
        }
    }
    if (xOffset == 0) {
        weeks--;
    }
    [self updateCalendarHeightWithWeeks:weeks];
    
    [self updateTitle];
}

-(void)dayClicked:(UIButton*)sender
{
    if (selectedDay) {
//        [selectedDay setBackgroundColor:[UIColor clearColor]];
        [selectedDay setSelected:NO];
    }
    selectedDay = sender;
    [sender setSelected:YES];
//    [sender setBackgroundColor:[UIColor blueColor]];
}

-(UIButton*)getButtonForDay:(NSInteger)day
{
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kDayWidth, kDayHeight)];
    [btn setTitle:[NSString stringWithFormat:@"%d", day+1] forState:UIControlStateNormal];
    btn.tag = day;
    [btn setBackgroundImage:[UIImage imageNamed:@"btnCalendar"] forState:UIControlStateSelected];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dayClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (IBAction)applyDate:(id)sender {
    
    if (selectedDay) {
        NSDate * date = [self dateFromComponents:selectedDay.tag+1 month:month year:year];
        if ([_delegate respondsToSelector:@selector(calendarController:didSelectDate:)]) {
            [_delegate calendarController:self didSelectDate:date];
        }
    }
    
}

- (IBAction)gotoPreviousMonth:(id)sender {
    selectedDay = nil;
    month--;
    if (month<1) {
        month = 12;
        year--;
    }
    [self loadCalendar];
}
- (IBAction)gotoNextMonth:(id)sender {
    selectedDay = nil;
    month++;
    if (month>12) {
        month = 1;
        year++;
    }
    [self loadCalendar];
}
@end
