//
//  ResponseViewController.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "ResponseViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "Utility.h"
#import "SDConstants.h"
#import "Response.h"
#import "UserCell.h"
#import "ImagesCell.h"
#import "NotificationCell.h"
#import "Comment.h"
#import "UIImageView+AFNetworking.h"
#import "TextAreaResponse.h"

@interface ResponseViewController ()

@property (nonatomic, retain) NSMutableArray * arrResponses;
@property (nonatomic ,retain) Response * response;

@end

@implementation ResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arrResponses = [[NSMutableArray alloc] init];
    
    [self getResponses];
}
- (IBAction)cancelThis:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API Methods
-(void)getResponses
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetResponses];
    url = [url stringByReplacingOccurrencesOfString:@"{activityId}" withString:[NSString stringWithFormat:@"%d", _currentNotification.activityID]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Response : %@", responseObject);
        
        _response = [[Response alloc] initWithDictionary:[responseObject firstObject]];
        
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 75;
    }
    else if (indexPath.row == 1){
        return 90;
    }
    else if (_response.files.count>0 && indexPath.row == 2){
        return 85;
    }
    else if ((_response.files.count==0 && indexPath.row == 2) || (_response.files.count>0 && indexPath.row == 3)){
        return 44;
    }
    else{
        return 110;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    if (_response) {
        count += 2;
        if (_response.files.count > 0) {
            count++;
        }
        count++;
        count+= _response.comments.count;
    }
    // Return the number of rows in the section.
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UserCell * cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
        [cell.lblTime setText:_response.dateCreatedFormated];
        [cell.userImage setImageWithURL:[NSURL URLWithString:_response.userInfo.avatarFile.filePath]];
        [cell.lblUsername setText:_response.userInfo.appUserName];
        [cell makeImageCircular];
        return cell;
    }
    else if (indexPath.row == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        TextAreaResponse * t = [_response.textAreaResponse objectAtIndex:0];
        [cell.textLabel setText:t.response];
        return cell;
    }
    
    if (_response.files.count>0 && indexPath.row == 2) {
        ImagesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"imagesScrollCell"];
        return cell;
    }
    else if ((_response.files.count==0 && indexPath.row == 2) || (_response.files.count>0 && indexPath.row == 3)){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell" forIndexPath:indexPath];
        [cell.textLabel setText:[NSString stringWithFormat:@"%d Responses", _response.comments.count]];
        return cell;
    }
    
    int count = 3;
    if (_response.files.count>0) {
        count++;
    }
    
    Comment * comment = [_response.comments objectAtIndex:indexPath.row - count];
    
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCommentCell" forIndexPath:indexPath];
    [cell.lblDate setText:comment.dateCreatedFormated];
    [cell.lblUserName setText:comment.userInfo.appUserName];
    [cell.userImage setImageWithURL:[NSURL URLWithString:comment.userInfo.avatarFile.filePath]];
    [cell.lblInfo setText:comment.response];
    [cell makeImageCircular];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
