//
//  DiaryThemeViewController.m
//  DigiFaces
//
//  Created by confiz on 28/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "DiaryThemeViewController.h"
#import "ImageCell.h"
#import "UIImageView+AFNetworking.h"
#import "DefaultCell.h"
#import "ResponseViewCell.h"
#import "Diary.h"

@interface DiaryThemeViewController ()

@end

@implementation DiaryThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)closeThis:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3 + _dailyDiary.userDiaries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        if (_dailyDiary.file && [_dailyDiary.file.fileType isEqualToString:@"Image"]) {
            ImageCell * imgCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            [imgCell.image setImageWithURL:[NSURL URLWithString:_dailyDiary.file.filePath]];
            cell = imgCell;
        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
        }
    }
    else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        
        [cell.textLabel setText:_dailyDiary.diaryQuestion];
    }
    else if (indexPath.row == 2){
        DefaultCell * headerCell = [tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell" forIndexPath:indexPath];
        [headerCell.label setText:[NSString stringWithFormat:@"%lu Entries", (unsigned long)[_dailyDiary.userDiaries count]]];
        cell = headerCell;
    }
    else{
        Diary * diary = [_dailyDiary.userDiaries objectAtIndex:indexPath.row - 3];
        ResponseViewCell * responseCell = [tableView dequeueReusableCellWithIdentifier:@"responseCell"];
        [responseCell.lblName setText:diary.userInfo.appUserName];
        [responseCell.lblResponse setText:diary.response];
        [responseCell.lblTime setText:diary.dateCreatedFormatted];
        [responseCell.userImage setImageWithURL:[NSURL URLWithString:diary.userInfo.avatarFile.filePath]];
        [responseCell.btnComments setTitle:[NSString stringWithFormat:@"%d Comments", diary.comments.count] forState:UIControlStateNormal];
        
        responseCell.responseHeightConst.constant = [self heightForComment:diary.response];
        
        
        [responseCell.scrollView setFilesArray:diary.files];
        [responseCell.scrollView setItemSize:CGSizeMake(58, 58)];
        [responseCell.scrollView setPadding:UIEdgeInsetsMake(2, 2, 2, 0)];
        [responseCell.scrollView reloadData];
        
        cell = responseCell;
    }
    
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 160;
    }
    else if (indexPath.row == 1){
        return 90;
    }
    else if (indexPath.row == 2){
        return 40;
    }
    else{
        
        Diary * diary = [_dailyDiary.userDiaries objectAtIndex:indexPath.row - 3];
        int count = 92;
        count+= [self heightForComment:diary.response];
        
        if (diary.comments.count>0) {
            count+= 58;
        }
        return count;
    }
}

-(CGFloat)heightForComment:(NSString*)comment
{
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:comment attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    CGSize size = rect.size;
    
    return size.height + 10;
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
