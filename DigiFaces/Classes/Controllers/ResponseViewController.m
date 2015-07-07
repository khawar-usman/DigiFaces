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
#import "CommentCell.h"
#import "Utility.h"
#import "CustomAertView.h"

@interface ResponseViewController () <CommentCellDelegate>
{
    NSInteger contentHeight;
}

@property (nonatomic, retain) CustomAertView * customAlert;
@property (nonatomic, retain) NSMutableArray * arrResponses;
@property (nonatomic ,retain) Response * response;

@end

@implementation ResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.customAlert = [[CustomAertView alloc]initWithNibName:@"CustomAertView" bundle:nil];
    [self.customAlert setSingleButton:YES];
    
    _arrResponses = [[NSMutableArray alloc] init];
    if (_responseType == ResponseControllerTypeNotification) {
        [self getResponses];
    }
    [Utility addPadding:5 toTextField:_txtResposne];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    contentHeight = self.contentView.frame.size.height;
}
- (IBAction)cancelThis:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

-(void)addComment:(NSString*)comment
{
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kUpdateComments];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    NSDictionary * params = @{@"CommentId" : @"0",
                              @"ThreadId" : _diary.threadId,
                              @"UserId" : _diary.useID,
                              @"UserInfo" : _diary.userInfo,
                              @"DateCreated" : [NSDate date],
                              @"Response" : comment,
                              @"IsActive" : @"1",
                              @"IsRead" : @"0"};
    
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        [self.customAlert showAlertWithMessage:@"Comment Added Successfully" inView:self.navigationController.view withTag:0];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}


-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [keyboardFrameBegin CGRectValue].size;
    
    float duration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.constBottomSpace.constant = 0;
    self.constBottomSpace.constant = keyboardSize.height;
    [UIView animateWithDuration:duration
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    
    float duration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    
    self.constBottomSpace.constant = 0;
    [UIView animateWithDuration:duration
                     animations:^{
                         [self.view layoutIfNeeded];
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
        
        NSString * response = nil;
        if (_responseType == ResponseControllerTypeNotification) {
            TextAreaResponse * t = [_response.textAreaResponse objectAtIndex:0];
            response = t.response;
        }
        else{
            response = _diary.response;
        }
        NSAttributedString *attributedText =
        [[NSAttributedString alloc] initWithString:response attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
        
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        CGSize size = rect.size;
        
        return size.height + 20;
        
        return MIN(90, size.height);
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
    else if (_diary){
        count+=2;
        if (_diary.files.count>0) {
            count++;
        }
        count+= _diary.comments.count;
    }
    // Return the number of rows in the section.
    return count;
}

-(void)configureUserCell:(UserCell*)cell
{
    if (_responseType == ResponseControllerTypeNotification) {
        [cell.lblTime setText:_response.dateCreatedFormated];
        [cell.userImage setImageWithURL:[NSURL URLWithString:_response.userInfo.avatarFile.filePath]];
        [cell.lblUsername setText:_response.userInfo.appUserName];
        [cell makeImageCircular];
    }
    else{
        [cell.lblTime setText:_diary.dateCreatedFormatted];
        [cell.userImage setImageWithURL:[NSURL URLWithString:_diary.userInfo.avatarFile.filePath]];
        [cell.lblUsername setText:_diary.userInfo.appUserName];
        [cell makeImageCircular];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UserCell * cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
        [self configureUserCell:cell];
        return cell;
    }
    else if (indexPath.row == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        if (_responseType == ResponseControllerTypeNotification) {
            TextAreaResponse * t = [_response.textAreaResponse objectAtIndex:0];
            [cell.textLabel setText:t.response];
        }
        else{
            [cell.textLabel setText:_diary.response];
        }
        return cell;
    }
    
    if (_response.files.count>0 && indexPath.row == 2) {
        ImagesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"imagesScrollCell"];
        return cell;
    }
    else if (_responseType == ResponseControllerTypeNotification && ((_response.files.count==0 && indexPath.row == 2) || (_response.files.count>0 && indexPath.row == 3))){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell" forIndexPath:indexPath];
        NSInteger counts = 0;
        if (_responseType == ResponseControllerTypeNotification) {
            counts = _response.comments.count;
        }
        else{
            counts = _diary.comments.count;
        }
        [cell.textLabel setText:[NSString stringWithFormat:@"%d Responses", counts]];
        return cell;
    }
    else if ( indexPath.row == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell" forIndexPath:indexPath];
        NSInteger counts = 0;
        counts = _diary.comments.count;
        [cell.textLabel setText:[NSString stringWithFormat:@"%d Comments", counts]];
        return cell;
    }

    
    int count = 2;
    if (_responseType == ResponseControllerTypeNotification && _response.files.count>0) {
        count++;
    }
    else if(_responseType == ResponseControllerTypeDiaryResponse && _diary.files.count>0){
        count++;
    }
    
    Comment * comment = nil;
    if (_responseType == ResponseControllerTypeNotification) {
        comment = [_response.comments objectAtIndex:indexPath.row - count];
    }
    else{
        comment = [_diary.comments objectAtIndex:indexPath.row - count];
    }
    
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCommentCell" forIndexPath:indexPath];
    [cell.lblDate setText:comment.dateCreatedFormated];
    [cell.lblUserName setText:comment.userInfo.appUserName];
    [cell.userImage setImageWithURL:[NSURL URLWithString:comment.userInfo.avatarFile.filePath]];
    [cell.lblInfo setText:comment.response];
    [cell makeImageCircular];
    return cell;
}

#pragma mark - CommentCellDelegate
-(void)commentCell:(id)cell didSendText:(NSString *)text
{
    [self addComment:text];
    
}


- (IBAction)sendComment:(id)sender {
    if ([_txtResposne.text isEqualToString:@""]) {
        return;
    }
    [_txtResposne resignFirstResponder];
    [self addComment:_txtResposne.text];
    _txtResposne.text = @"";
}
- (IBAction)exitOnend:(id)sender {
    [sender resignFirstResponder];
}
@end
