//
//  DiaryInfoViewController.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "DiaryInfoViewController.h"
#import "ImageCell.h"
#import "UIImageView+AFNetworking.h"
#import "WebViewController.h"
#import "VideoCell.h"
#import "AddResponseViewController.h"
#import "RTCell.h"

@interface DiaryInfoViewController ()
{
    UIButton * btnEdit;
    RTCell * infoCell;
}
@end

@implementation DiaryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_isViewOnly) {
        [self addEditButton];
    }
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
    [self performSegueWithIdentifier:@"addResponseSegue" sender:self];
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
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 160;
    }
    if (indexPath.row == 1) {
//        NSAttributedString *attributedText =
//        [[NSAttributedString alloc] initWithString:_dailyDiary.diaryQuestion attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
//        
//        CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//        
//        CGSize size = rect.size;
        
        return infoCell.titleLabel.optimumSize.height + 20;
    }
    return 0;
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
            VideoCell * vidCell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
            [vidCell.imageView setImageWithURL:[NSURL URLWithString:_dailyDiary.file.getVideoThumbURL]];
            cell = vidCell;
        }
    }
    else if (indexPath.row == 1) {
        infoCell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        
        [infoCell.titleLabel setText:_dailyDiary.diaryQuestion];
        cell = infoCell;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && _dailyDiary.file) {
        [self performSegueWithIdentifier:@"webViewSegue" sender:self];
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
    if ([segue.identifier isEqualToString:@"webViewSegue"]){
        WebViewController * webController = (WebViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        webController.url = [_dailyDiary.file filePath];
    }
    else if ([segue.identifier isEqualToString:@"addResponseSegue"]){
        AddResponseViewController * responseController = (AddResponseViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        responseController.dailyDiary = self.dailyDiary;
    }
}


- (IBAction)closeThis:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
