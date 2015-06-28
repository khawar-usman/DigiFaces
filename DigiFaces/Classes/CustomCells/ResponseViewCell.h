//
//  ResponseViewCell.h
//  DigiFaces
//
//  Created by confiz on 28/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesScrollviewer.h"

@interface ResponseViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblResponse;
@property (weak, nonatomic) IBOutlet ImagesScrollviewer *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnComments;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *responseHeightConst;
- (IBAction)commentClicked:(id)sender;

@end
