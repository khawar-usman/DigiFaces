//
//  EmailModeratorController.m
//  DigiFaces
//
//  Created by confiz on 21/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "EmailModeratorController.h"
#import "MBProgressHUD.h"
#import "SDConstants.h"
#import "Utility.h"
#import "AFHTTPRequestOperationManager.h"

#define kSuccessTag 2

@implementation EmailModeratorController


-(void)viewDidLoad
{
    [super viewDidLoad];
    alertView = [[CustomAertView alloc] initWithNibName:@"CustomAertView" bundle:nil];
    alertView.delegate = self;
}

- (IBAction)cancelThis:(id)sender {
    if (![_textview.text isEqualToString:@""] && ![_textview.text isEqualToString:@"Some Text to Post"]) {
        [_textview resignFirstResponder];
        [alertView showAlertWithMessage:@"Your changes will be discarded. Do you want to cancel it?" inView:self.navigationController.view withTag:0];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)resignAllResponder
{
    [_txtSubject resignFirstResponder];
    [_textview resignFirstResponder];
}
- (IBAction)sendEmail:(id)sender {
    if ([_textview.text isEqualToString:@""] || [_textview.text isEqualToString:@"Some Text to Post"]) {
        [self resignAllResponder];
        [alertView showAlertWithMessage:@"Please enter some text to send" inView:self.navigationController.view withTag:0];
        return;
    }
    else if ([_txtSubject.text isEqualToString:@""]){
        [self resignAllResponder];
        [alertView showAlertWithMessage:@"Subject is required." inView:self.navigationController.view withTag:0];
        return;
    }
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kModeratorMessage];
    url = [url stringByReplacingOccurrencesOfString:@"{projectId}" withString:[Utility getStringForKey:kCurrentPorjectID]];
    url = [url stringByReplacingOccurrencesOfString:@"{parentMessageId}" withString:@"0"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:_txtSubject.text, @"Subject", _textview.text, @"Response", nil];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [alertView showAlertWithMessage:@"Your message posted successfully" inView:self.navigationController.view withTag:kSuccessTag];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}

#pragma mark - Popup dlegate
-(void)cacellButtonTappedWithTag:(NSInteger)tag
{
    
}

-(void)okayButtonTappedWithTag:(NSInteger)tag
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
