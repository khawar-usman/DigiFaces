//
//  TechSupportController.h
//  DigiFaces
//
//  Created by confiz on 21/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAertView.h"

@interface TechSupportController : UITableViewController<PopUpDelegate>
{
    CustomAertView * alertView;
}
@property (weak, nonatomic) IBOutlet UITextField *txtSubject;

@property (weak, nonatomic) IBOutlet UITextView *textArea;

@end
