//
//  ProjectViewController.h
//  DigiFaces
//
//  Created by Apple on 15/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking/AFNetworking.h"
#import "MBProgressHUD.h"
#import "CustomAertView.h"

@protocol MessageToViewMain;


@interface ProjectViewController : UIViewController
@property(nonatomic,retain)CustomAertView * customAlert;

@end
