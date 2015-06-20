//
//  MyProfileViewController.m
//  DigiFaces
//
//  Created by Apple on 17/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "MyProfileViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking/AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UserManagerShared.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profilePicView.image = [[UserManagerShared sharedManager]profilePic];
    self.aboutMe.text = [[UserManagerShared sharedManager]aboutMeText];
    self.titleName.text = [NSString stringWithFormat:@"%@ %@",[[UserManagerShared sharedManager]FirstName],[[UserManagerShared sharedManager]LastName]];
    
    self.profilePicView.layer.cornerRadius = self.profilePicView.frame.size.height /2;
    self.profilePicView.layer.masksToBounds = YES;
    self.profilePicView.layer.borderWidth = 0;
    
    [self.aboutMe becomeFirstResponder];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelThis:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)postpressed:(id)sender{
    
}

-(IBAction)changePicture:(id)sender{
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
 
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
