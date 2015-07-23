//
//  AddResponseViewController.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "AddResponseViewController.h"
#import "TextFieldCell.h"
#import "TextViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Utility.h"
#import "DiaryInfoViewController.h"
#import "CalendarViewController.h"
#import "UserManagerShared.h"
#import "MBProgressHUD.h"
#import "SDConstants.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "CustomAertView.h"
#import "ProfilePicutreCollectionViewController.h"

@interface AddResponseViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CalendarViewControlerDelegate, UITextViewDelegate, UIActionSheetDelegate, ProfilePictureViewControllerDelegate>
{
    NSInteger selectedTag;
    UIImagePickerController * imagePicker;
    CalendarViewController * calendarView;
    NSInteger threadID;
    NSDate * selectedDate;
}

@property (nonatomic, retain) NSMutableArray * dataArray;
@property (nonatomic, retain) CustomAertView * alertView;

@end

@implementation AddResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [_txtResponse becomeFirstResponder];
    _dataArray = [[NSMutableArray alloc] initWithCapacity:4];
    [_btnDate setTitle:[Utility stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    selectedDate = [NSDate date];
    
    _alertView = [[CustomAertView alloc] initWithNibName:@"CustomAertView" bundle:[NSBundle mainBundle]];
    
    if (_diaryTheme) {
        _constDateHeight.constant = 0;
        _constTitleHeight.constant = 0;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"diaryInfoSegue"]) {
        DiaryInfoViewController * diaryInfoController = (DiaryInfoViewController*)[(UINavigationController*)segue.destinationViewController topViewController];
        diaryInfoController.isViewOnly = YES;
        diaryInfoController.dailyDiary = self.dailyDiary;
        diaryInfoController.diaryTheme = self.diaryTheme;
    }
    else if ([segue.identifier isEqualToString:@"gallerySegue"]){
        ProfilePicutreCollectionViewController * profileController = (ProfilePicutreCollectionViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        profileController.type = ProfilePicutreTypeGallery;
        profileController.delegate = self;
        Module * module = [_diaryTheme getModuleWithThemeType:ThemeTypeImageGallery];
        
        profileController.files = [module.imageGallary files];
    }
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.constBottomViewHeight.constant = kbSize.height;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createThreadWithActivityID:(NSInteger)activityId
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kUpdateThread];
    
    NSDictionary * params = @{@"ActivityId" : @(activityId),
                              @"ThreadId" : @0,
                              @"IsDraft" : @YES,
                              @"IsActive" : @YES};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Response : %@", responseObject);
        threadID = [[responseObject objectForKey:@"ThreadId"] integerValue];
        if (_dailyDiary) {
            [self addEntryWithActivityId:activityId];
        }
        else if(_diaryTheme){
            if ([_diaryTheme getModuleWithThemeType:ThemeTypeImageGallery]) {
                [self addImageGalleryResponse];
            }
            else
            {
                [self addTextAreaResponseWithActivityId:activityId];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

-(NSString*)getSelectedGalleryIds
{
    NSString * galleryIds = @"";
    for (NSDictionary * m in _dataArray) {
        File * file = [m objectForKey:@"path"];
        galleryIds = [galleryIds stringByAppendingFormat:@"%d,", file.fileId];
    }
    if (_dataArray.count>0) {
        galleryIds = [galleryIds substringToIndex:galleryIds.length-2];
    }
    return galleryIds;
}

-(void)addImageGalleryResponse
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kUpdateGalleryResponse];
    
    Module * imageGalleryModule = [_diaryTheme getModuleWithThemeType:ThemeTypeImageGallery];
    NSDictionary * params = @{@"ImageGalleryResponseId" : @0,
                              @"ThreadId" : @(threadID),
                              @"ImageGalleryId" : @(imageGalleryModule.imageGallary.imageGalleryId),
                              @"GalleryIds" : [self getSelectedGalleryIds],
                              @"UserId" : [[UserManagerShared sharedManager] ID],
                              @"IsActive" : @YES,
                              @"Response" : _txtResponse.text};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Response : %@", responseObject);
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

-(void)addTextAreaResponseWithActivityId:(NSInteger)activityId
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kUpdateTextAreaResponse];
    
    Module * textAreaModule = [_diaryTheme getModuleWithThemeType:ThemeTypeTextArea];
    
    NSDictionary * params = @{@"TextareaResponseId" : @(0),
                              @"ThreadId" : @(threadID),
                              @"TextareaId" : @(textAreaModule.textArea.textareaId),
                              @"IsActive" : @YES,
                              @"Response" : _txtResponse.text};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Response : %@", responseObject);
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

-(void)addEntryWithActivityId:(NSInteger)activityId
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kUpdateDailyDiary];
    url = [url stringByReplacingOccurrencesOfString:@"{projectId}" withString:[NSString stringWithFormat:@"%d", [[UserManagerShared sharedManager] currentProjectID]]];
    
    NSDictionary * params = @{@"ActivityId" : @(activityId),
                              @"DailyDiaryResponseId" : @0,
                              @"DailyDiaryId" : @(_dailyDiary.diaryID),
                              @"ThreadId" : @(threadID),
                              @"Title" : _txtTitle.text,
                              @"Response" : _txtResponse.text,
                              @"DiaryDate" : [Utility stringDateFromDMYDate:selectedDate]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Response : %@", responseObject);
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

-(void)openCameraWithType:(UIImagePickerControllerSourceType)sourceType
{
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        imagePicker.sourceType = sourceType;
    }
    else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.allowsEditing = YES;
    
    imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage, (NSString*)kUTTypeMovie, nil];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)resignAllResponders
{
    [_txtTitle resignFirstResponder];
    [_txtResponse resignFirstResponder];
}

- (IBAction)postData:(id)sender {
    if (_dailyDiary && [_txtTitle.text isEqualToString:@""]) {
        // Error
        [self resignAllResponders];
        [_alertView showAlertWithMessage:@"Title is required" inView:self.navigationController.view withTag:0];
    }
    else if ([_txtResponse.text isEqualToString:@""]){
        [self resignAllResponders];
        [_alertView showAlertWithMessage:@"Respose is required." inView:self.navigationController.view withTag:0];
    }
    else
    {
        [self resignAllResponders];
        [self createThreadWithActivityID:_diaryTheme.activityId];
    }
    
}

- (IBAction)closeThis:(id)sender {
    [self resignAllResponders];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)exitOnEnd:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)viewQuestion:(id)sender {
    
    [self performSegueWithIdentifier:@"diaryInfoSegue" sender:self];
}

- (IBAction)cameraSwitched:(id)sender {
    [_txtResponse resignFirstResponder];
    [_txtTitle resignFirstResponder];
    
}

- (IBAction)selectDate:(id)sender {
    
    [_txtResponse resignFirstResponder];
    [_txtTitle resignFirstResponder];
    
    calendarView = [self.storyboard instantiateViewControllerWithIdentifier:@"calendarController"];
    calendarView.delegate = self;
    calendarView.endDate = [NSDate date];
    calendarView.startDate = [Utility dateFromString:[[UserManagerShared sharedManager] currentProject].projectStartDate];
    [self.navigationController.view addSubview:calendarView.view];
    
}



- (IBAction)addPicture:(UIButton*)sender {
    selectedTag = sender.tag;
    if (_diaryTheme && [_diaryTheme getModuleWithThemeType:ThemeTypeImageGallery])   {
        [self performSegueWithIdentifier:@"gallerySegue" sender:self];
    }
    else{
        
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"Select an Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
        [sheet showInView:self.view];
    }
}

-(void)setImageToCameraButton:(UIImage*)image
{
    UIButton * btn;
    switch (selectedTag) {
        case 1:
            btn = _btnCamera1;
            break;
        case 2:
            btn = _btnCamera2;
            break;
        case 3:
            btn = _btnCamera3;
            break;
        case 4:
            btn = _btnCamera4;
            break;
        default:
            break;
    }
    
    [btn setImage:image forState:UIControlStateNormal];
}

-(void)setImageURL:(NSString*)url
{
    UIButton * btn = nil;
    switch (selectedTag) {
        case 1:
            btn = _btnCamera1;
            break;
        case 2:
            btn = _btnCamera2;
            break;
        case 3:
            btn = _btnCamera3;
            break;
        case 4:
            btn = _btnCamera4;
            break;
        default:
            break;
    }
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url
                                                           ]];
    [btn.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [btn setImage:image forState:UIControlStateNormal];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Image Loading Error");
    }];
}


#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if ([[info valueForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        // Image
        UIImage * image = [info valueForKey:UIImagePickerControllerEditedImage];
        
        NSData * data = UIImagePNGRepresentation(image);
        NSString * filePath = [self getTempPath];
        filePath = [filePath stringByAppendingPathComponent:[Utility getUniqueId]];
        filePath = [filePath stringByAppendingPathExtension:@"png"];
        if ([data writeToFile:filePath atomically:YES]) {
            [self removeItemForTag:selectedTag];
            [_dataArray addObject:@{@"path" : filePath, @"tag" : @(selectedTag)}];
        }
        [self setImageToCameraButton:image];
    }
    
}

-(void)removeItemForTag:(NSInteger)tag
{
    for (NSDictionary * dict in _dataArray) {
        if ([[dict valueForKey:@"tag"] integerValue] == selectedTag) {
            [_dataArray removeObject:dict];
            break;
        }
    }
}

-(NSString*)getTempPath
{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return docPath;
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        [_lblPlaceholder setHidden:NO];
    }
    else{
        [_lblPlaceholder setHidden:YES];
    }
}

#pragma mark - CalendarViewDelegate
-(void)calendarController:(id)controller didSelectDate:(NSDate *)date
{
    selectedDate = date;
    NSString * strDate = [Utility stringFromDate:date];
    [_btnDate setTitle:strDate forState:UIControlStateNormal];
    [calendarView.view removeFromSuperview];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerControllerSourceType type;
        if (buttonIndex == 0) {
            type = UIImagePickerControllerSourceTypeCamera;
        }
        else if (buttonIndex == 1){
            type = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [self openCameraWithType:type];
    }
    
}

#pragma mark - ProfilePictureDelegate
-(void)profilePicutreDidSelect:(File *)selectedProfile
{
    [self removeItemForTag:selectedTag];
    [_dataArray addObject:@{@"path" : selectedProfile, @"tag" : @(selectedTag)}];
    [self setImageURL:[selectedProfile filePath]];
}

@end
