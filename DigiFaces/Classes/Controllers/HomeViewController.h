//
//  HomeViewController.h
//  DigiFaces
//
//  Created by Apple on 09/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAertView.h"
@protocol MessageToViewMain;

@interface HomeViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic,strong)IBOutlet UILabel * usernameLabel;
//@property (nonatomic,strong)IBOutlet UIImageView * userPicture;
@property (nonatomic,strong)NSArray * imageNames;
@property(nonatomic,retain)CustomAertView * customAlert;

@end
