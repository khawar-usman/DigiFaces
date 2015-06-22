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
#import "Utility.h"
#import "SDConstants.h"
#import "CustomAertView.h"

#define kTagDiscardChanges  100

@interface MyProfileViewController () <PopUpDelegate>
{
    CustomAertView * alertview;
}
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
    
    [self.aboutMe setText:[Utility getStringForKey:kAboutMeText]];
    [self.aboutMe becomeFirstResponder];
    
    alertview = [[CustomAertView alloc]initWithNibName:@"CustomAertView" bundle:nil];
    alertview.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelThis:(id)sender{
    
    if (![_aboutMe.text isEqualToString:@""]) {
        [_aboutMe resignFirstResponder];
        [alertview showAlertWithMessage:@"Your changes will be discarded. Do you want to descard changes?" inView:self.navigationController.view withTag:kTagDiscardChanges];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(IBAction)postpressed:(id)sender{
    NSLog(@"Posted");
    [_aboutMe resignFirstResponder];
    if ([_aboutMe.text isEqualToString:@""]) {
        [alertview showAlertWithMessage:@"Text is required." inView:self.navigationController.view withTag:0];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
     [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];

    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"AboutMeId", [Utility getStringForKey:kCurrentPorjectID], @"ProjectId", @"", @"UserId", _aboutMe.text, @"AboutMeText", nil];
    
    manager.requestSerializer = requestSerializer;
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kAboutMeUpdate];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
        [alertview showAlertWithMessage:@"An error in request, verify that your email is correct" inView:self.view withTag:0];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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

#pragma mark - Popup Delegate
-(void)okayButtonTappedWithTag:(NSInteger)tag
{
    if (tag == kTagDiscardChanges) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)cacellButtonTappedWithTag:(NSInteger)tag
{
    
}

@end
