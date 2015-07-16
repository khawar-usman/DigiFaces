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
#import "RTCell.h"
#import "CarouselViewController.h"

typedef enum {
    CellTypeUser,
    CellTypeTitle,
    CellTypeIntro,
    CellTypeImages,
    CellTypeHeader,
    CellTypeComment
}CellType;

@interface ResponseViewController () <CommentCellDelegate, ImageCellDelegate>
{
    NSInteger contentHeight;
    RTCell *infoCell;
    NSInteger selectedIndex;
}

@property (nonatomic, retain) NSMutableArray * cellsArray;

@property (nonatomic, retain) CustomAertView * customAlert;
@property (nonatomic, retain) NSMutableArray * arrResponses;
@property (nonatomic ,retain) Response * response;
@property (nonatomic, retain) NSMutableArray * heightArray;

@end

@implementation ResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _heightArray = [[NSMutableArray alloc] init];
    
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
    
    _cellsArray = [[NSMutableArray alloc] init];
    [_cellsArray addObject:@(CellTypeUser)];
    [_cellsArray addObject:@(CellTypeTitle)];
    [_cellsArray addObject:@(CellTypeIntro)];
    if (_diary.files.count>0) {
        [_cellsArray addObject:@(CellTypeImages)];
    }
    [_cellsArray addObject:@(CellTypeHeader)];
    
    for (int i=0;i<_diary.comments.count;i++) {
        [_cellsArray addObject:@(CellTypeComment)];
    }
    
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
    url = [url stringByReplacingOccurrencesOfString:@"{activityId}" withString:[NSString stringWithFormat:@"%ld", (long)_currentNotification.activityID]];
    
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
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.requestSerializer = requestSerializer;
    
    NSDictionary * params = @{@"CommentId" : @0,
                              @"ThreadId" : @([_diary.threadId integerValue]),
                              @"Response" : comment,
                              @"IsActive" : @YES};
    
    
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
    NSInteger height;
    CellType type = [[_cellsArray objectAtIndex:indexPath.row] integerValue];
    switch (type) {
        case CellTypeUser:
            height = 75;
            break;
        case CellTypeTitle:
            height = 44;
            break;
        case CellTypeIntro:
            height = MIN(90, infoCell.titleLabel.optimumSize.height + 20);;
            break;
        case CellTypeImages:
            height = 85;
            break;
        case CellTypeHeader:
            height = 44;
            break;
        case CellTypeComment:
            height = 110;
            break;
            
        default:
            break;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellsArray.count;
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

-(UITableViewCell*)getCellForType:(CellType)type forIndexPath:(NSIndexPath*)indexPath
{
    if (type == CellTypeUser) {
        UserCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
        [self configureUserCell:cell];
        return cell;
    }
    else if (type == CellTypeIntro){
        infoCell = [self.tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        
        [infoCell.titleLabel setText:_diary.response];
        return infoCell;
    }
    else if (type == CellTypeImages){
        ImagesCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"imagesScrollCell"];
        cell.delegate = self;
        NSArray * files = _diary.files;
        [cell setImagesFiles:files];
        
        return cell;
    }
    else if (type == CellTypeHeader){
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell" forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        NSInteger counts = 0;
        if (_responseType == ResponseControllerTypeNotification) {
            counts = _response.comments.count;
        }
        else{
            counts = _diary.comments.count;
        }
        [cell.textLabel setText:[NSString stringWithFormat:@"%ld Responses", (long)counts]];
        return cell;
    }
    else if (type == CellTypeTitle){
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell" forIndexPath:indexPath];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.textLabel setText:_diary.title];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14 weight:1]];
        return cell;
    }

    else if (type == CellTypeComment){
        int count = 4;
        if(_responseType == ResponseControllerTypeDiaryResponse && _diary.files.count>0){
            count++;
        }
        
        Comment * comment = [_diary.comments objectAtIndex:indexPath.row - count];
        
        NotificationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"userCommentCell" forIndexPath:indexPath];
        [cell.lblDate setText:comment.dateCreatedFormated];
        [cell.lblUserName setText:comment.userInfo.appUserName];
        [cell.userImage setImageWithURL:[NSURL URLWithString:comment.userInfo.avatarFile.filePath]];
        [cell.infoLabel setText:comment.response];
        
        [cell makeImageCircular];
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CellType type = [[_cellsArray objectAtIndex:indexPath.row] integerValue];
    return [self getCellForType:type forIndexPath:indexPath];
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

#pragma mark - ImagesCellDelegate
-(void)imageCell:(id)cell didClickOnButton:(id)button atIndex:(NSInteger)index atFile:(File *)file
{
    selectedIndex = index;
    [self performSegueWithIdentifier:@"carosulSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"carosulSegue"]){
        CarouselViewController * carouselController = [segue destinationViewController];
        carouselController.selectedIndex = selectedIndex;
        carouselController.files = _diary.files;
    }
}

@end
