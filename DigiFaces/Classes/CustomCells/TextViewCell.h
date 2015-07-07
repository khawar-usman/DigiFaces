//
//  TextViewCell.h
//  DigiFaces
//
//  Created by confiz on 07/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *txtResponse;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
- (IBAction)dateClicked:(id)sender;

@end
