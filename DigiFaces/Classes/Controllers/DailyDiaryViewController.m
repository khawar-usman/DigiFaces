//
//  DailyDiaryViewController.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "DailyDiaryViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "SDConstants.h"
#import "Utility.h"
#import "UserManagerShared.h"
#import "DailyDiary.h"
#import "DiaryInfoViewController.h"

@interface DailyDiaryViewController ()
{
    UIButton * btnEdit;
}
@property (nonatomic, retain) DailyDiary * dailyDiary;

@end

@implementation DailyDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger diaryID = [[[[[UserManagerShared sharedManager] currentProject] dailyDiaryList] objectAtIndex:0] integerValue];
    [self fetchDailyDiaryWithDiaryID:diaryID];
    [self addEditButton];
}

-(void)addEditButton
{
    btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, 50, 50)];
    [btnEdit setBackgroundImage:[UIImage imageNamed:@"pencil"] forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnEdit];
}

-(void)editClicked:(id)sender
{
    NSLog(@"Edit clicked");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API Methods
-(void)fetchDailyDiaryWithDiaryID:(NSInteger)diaryID
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kDailyDiaryInfo];
    url = [url stringByReplacingOccurrencesOfString:@"{diaryId}" withString:[NSString stringWithFormat:@"%d", diaryID]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _dailyDiary = [[DailyDiary alloc] initWithDictionary:responseObject];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (!_dailyDiary) {
        return 0;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (indexPath.row == 0) {
        return 90;
    }
    else if (indexPath.row == 1){
        return 40;
    }
    return 90;//size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        
        [cell.textLabel setText:_dailyDiary.diaryQuestion];
    }
    else if (indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell" forIndexPath:indexPath];
        [cell.textLabel setText:[NSString stringWithFormat:@"%lu Responses", (unsigned long)[_dailyDiary.userDiaries count]]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"diaryInfoSegue" sender:self];
    }
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"diaryInfoSegue"]) {
        DiaryInfoViewController * diaryInfoController = (DiaryInfoViewController*)[(UINavigationController*)segue.destinationViewController topViewController];
        diaryInfoController.dailyDiary = self.dailyDiary;
    }
}

- (IBAction)closeThis:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = btnEdit.frame;
    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - btnEdit.frame.size.height - 10;
    frame.origin.x = self.view.frame.size.width - frame.size.width - 10;
    btnEdit.frame = frame;
    
    [self.view bringSubviewToFront:btnEdit];
}

@end