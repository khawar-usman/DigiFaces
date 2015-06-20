//
//  SettingsViewController.m
//  DigiFaces
//
//  Created by Apple on 17/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "SettingsViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking/AFNetworking.h"
#import "UIImageView+AFNetworking.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [self performSegueWithIdentifier: @"ToProfile" sender: self];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"MY cell", @"MY PROFILE") ;
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = NSLocalizedString(@"EmailTech cell", @"EMAIL TECH SUPPORT") ;
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = NSLocalizedString(@"Email cell", @"EMAIL THE MODERATOR");
    }
    else if(indexPath.row ==3){
        cell.textLabel.text = NSLocalizedString(@"ABOUT cell", @"ABOUT DIGIFACES") ;
        
    }
    
    else if(indexPath.row ==4){
        cell.textLabel.text = NSLocalizedString(@"VERSION cell", @"VERSION 1.0") ;
        
    }
 
    
    return cell;
}

-(IBAction)gotoback:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(IBAction)logout:(id)sender{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString * onlinekey = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    NSString *finalyToken = [[NSString alloc]initWithFormat:@"Bearer %@",onlinekey ];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:finalyToken forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    [manager POST:@"http://digifacesservices.focusforums.com/api/Account/Logout" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"logoutSegue" sender:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    
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
