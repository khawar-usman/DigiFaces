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
#import "DiaryInfoViewController.h"
#import "VideoCell.h"
#import "WebViewController.h"
#import "ResponseViewController.h"
#import "Module.h"
#import "RTCell.h"
#import "GalleryCell.h"
#import "MBProgressHUD.h"
#import "SDConstants.h"
#import "AFNetworking.h"
#import "Response.h"
#import "Utility.h"
#import "ResponseViewCell.h"
#import "TextAreaResponse.h"

@interface DiaryThemeViewController ()

@property (nonatomic, retain) NSMutableArray * cellsArray;
@property (nonatomic, retain) NSMutableArray * heightArray;
@end

@implementation DiaryThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellsArray = [[NSMutableArray alloc] init];
    _heightArray = [[NSMutableArray alloc] init];
    
    Module * markup = [self getModuleWithThemeType:ThemeTypeMarkup];
    if (markup) {
        [_cellsArray addObject:markup];
        [_heightArray addObject:@44];
    }
    else{
        Module * image = [self getModuleWithThemeType:ThemeTypeDisplayImage];
        if (image) {
            [_cellsArray addObject:image];
            [_heightArray addObject:@160];
        }
        else{
            Module * gallary = [self getModuleWithThemeType:ThemeTypeImageGallery];
            if (gallary) {
                [_cellsArray addObject:gallary];
                [_heightArray addObject:@160];
            }
        }
        
        Module * text = [self getModuleWithThemeType:ThemeTypeDisplayText];
        if (text) {
            [_cellsArray addObject:text];
            [_heightArray addObject:@44];
        }
        [self getResponses];
    }
}

-(Module*)getModuleWithThemeType:(ThemeType)type
{
    for (Module * m in _diaryTheme.modules) {
        if ([m themeType] == type){
            return m;
        }
    }
    return nil;
}

-(void)getResponses
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetResponses];
    url = [url stringByReplacingOccurrencesOfString:@"{activityId}" withString:[NSString stringWithFormat:@"%ld", (long)_diaryTheme.activityId]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Response : %@", responseObject);
        if ([responseObject count]>0) {
            [_cellsArray addObject:[NSString stringWithFormat:@"%d Responses", [responseObject count]]];
            [_heightArray addObject:@40];
        }
        for (NSDictionary * dict in responseObject) {
            Response * response = [[Response alloc] initWithDictionary:dict];
            [_cellsArray addObject:response];
            [_heightArray addObject:@160];
        }
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
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
    
    return _cellsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if ([[_cellsArray objectAtIndex:indexPath.row] isKindOfClass:[Module class]]) {
        Module * module = [_cellsArray objectAtIndex:indexPath.row];
        if ([module themeType] == ThemeTypeDisplayImage) {
            if (module.displayFile.file && [module.displayFile.file.fileType isEqualToString:@"Image"]) {
                ImageCell * imgCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
                NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:module.displayFile.file.filePath]];
                [imgCell.image setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    [imgCell.image setImage:image];
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    NSLog(@"Error");
                }];
                //[imgCell.image setImageWithURL:[NSURL URLWithString:module.displayFile.file.filePath]];
                cell = imgCell;
            }
            else{
                VideoCell * vidCell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
                [vidCell.imageView setImageWithURL:[NSURL URLWithString:module.displayFile.file.getVideoThumbURL]];
                cell = vidCell;
            }
        }
        else if ([module themeType] == ThemeTypeDisplayText){
        
            RTCell * textCell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
            
            [textCell.titleLabel setText:module.displayText.text];
            if (_heightArray.count>2) {
                [_heightArray replaceObjectAtIndex:indexPath.row withObject:@(MIN(textCell.titleLabel.optimumSize.height, 90))];
            }
            else{
                [_heightArray replaceObjectAtIndex:indexPath.row withObject:@(textCell.titleLabel.optimumSize.height + 20)];
            }
            cell = textCell;
        }
        else if ([module themeType] == ThemeTypeImageGallery){
            GalleryCell * galleryCell =  [tableView dequeueReusableCellWithIdentifier:@"galleryCell" forIndexPath:indexPath];
            galleryCell.files = module.imageGallary.files;
            [galleryCell reloadGallery];
            cell = galleryCell;
        }
        else if ([module themeType] == ThemeTypeMarkup){
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
            
            [cell.textLabel setText:@"You must use your computer to complete this theme"];
        }
    }
    else if ([[_cellsArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
        DefaultCell * defaultCell = [tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell"];
        [defaultCell.label setText:[_cellsArray objectAtIndex:indexPath.row]];
        cell = defaultCell;
    }
    else{
        Response * response = [_cellsArray objectAtIndex:indexPath.row];
        
        ResponseViewCell * responseCell = [tableView dequeueReusableCellWithIdentifier:@"responseCell" forIndexPath:indexPath];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:response.userInfo.avatarFile.filePath]];
        [responseCell.userImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [responseCell.userImage setImage:image];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Image download error");
        }];
        [responseCell.lblName setText:response.userInfo.appUserName];
        [responseCell.lblTime setText:response.dateCreatedFormated];
        CGSize size;
        if (response.textAreaResponse.count>0) {
            TextAreaResponse * textResponse = [response.textAreaResponse objectAtIndex:0];
            [responseCell.lblResponse setText:textResponse.response];
            size = [textResponse.response sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
            
        }
        
        NSInteger height = 105 + MIN(size.height, 50);
        
        if (response.files.count>0) {
            height += 55;
        }
        
        cell = responseCell;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[_heightArray objectAtIndex:indexPath.row] integerValue];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"webViewSegue" sender:self];
    }
    else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"diaryInfoSegue" sender:self];
    }
    else if (indexPath.row > 2){
        [self performSegueWithIdentifier:@"responseSegue" sender:self];
    }
}

-(CGFloat)heightForComment:(NSString*)comment
{
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:comment attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    CGSize size = rect.size;
    
    return size.height + 20;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"diaryInfoSegue"]) {
        DiaryInfoViewController * diaryInfoController = (DiaryInfoViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        
        diaryInfoController.diaryTheme = _diaryTheme;
    }
    else if ([segue.identifier isEqualToString:@"webViewSegue"]){
        WebViewController * webController = (WebViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        webController.url = [_dailyDiary.file filePath];

    }
    else if ([segue.identifier isEqualToString:@"responseSegue"]){
        NSInteger index = [self.tableView indexPathForSelectedRow].row;
        Diary * diary = [_dailyDiary.userDiaries objectAtIndex:index - 3];
        ResponseViewController * responseController = [segue destinationViewController];
        responseController.responseType = ResponseControllerTypeDiaryResponse;
        responseController.diary = diary;
    }
}

@end
