//
//  EmailModeratorController.h
//  DigiFaces
//
//  Created by confiz on 21/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAertView.h"

@interface EmailModeratorController : UITableViewController<PopUpDelegate, UITextViewDelegate>
{
    CustomAertView * alertView;
}
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UITextField *txtSubject;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceholder;

@end
