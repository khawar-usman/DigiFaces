//
//  ResponseViewController.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"
#import "DailyDiary.h"
#import "Diary.h"

typedef enum {
    ResponseControllerTypeNotification,
    ResponseControllerTypeDiaryResponse
}ResponseControllerType;

@interface ResponseViewController : UITableViewController

@property (nonatomic ,retain) Notification * currentNotification;
@property (nonatomic, assign) ResponseControllerType responseType;
@property (nonatomic, retain) Diary * diary;

@end
