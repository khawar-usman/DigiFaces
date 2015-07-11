//
//  AboutDigifacesController.m
//  DigiFaces
//
//  Created by confiz on 21/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "AboutDigifacesController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "SDConstants.h"
#import "NSString+HTML.h"

@implementation AboutDigifacesController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchAboutDigifacesText];
}


-(void)fetchAboutDigifacesText
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kAboutDigifaces];
    url = [url stringByReplacingOccurrencesOfString:@"{languageCode}" withString:@"en"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [_aboutLabel setText:[responseObject valueForKey:@"AboutText"]];
        
        [_scrollView setContentSize:_aboutLabel.optimumSize];
        //_textView.text = [[[responseObject valueForKey:@"AboutText"] stringByDecodingHTMLEntities] stringByConvertingHTMLToPlainText];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }];

}


- (IBAction)closeThis:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
