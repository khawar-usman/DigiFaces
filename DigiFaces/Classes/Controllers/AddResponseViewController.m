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
#import "DFMediaUploadManager.h"

@interface AddResponseViewController () < CalendarViewControlerDelegate, UITextViewDelegate, ProfilePictureViewControllerDelegate, DFMediaUploadManagerDelegate>
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
    
    NSLog(@"POSTing to %@ with params:\n %@", url, params);
    
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
        galleryIds = [galleryIds stringByAppendingFormat:@"%d,", (int)file.fileId];
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
    url = [url stringByReplacingOccurrencesOfString:@"{projectId}" withString:[NSString stringWithFormat:@"%d", (int)[[UserManagerShared sharedManager] currentProjectID]]];
    
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
    
    __weak __typeof(self) wself = self;
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"Response : %@", responseObject);
        
        NSLog(@"Uploading images (if any)");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __typeof(wself) sself = wself;
            [sself.mediaUploadManager uploadMediaFiles];
        });

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        __typeof(wself) sself = wself;
        [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
    }];
}

-(void)insertThreadFileWithMediaView:(DFMediaUploadView*)mediaUploadView {
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kInsertThreadFile];
    url = [url stringByReplacingOccurrencesOfString:@"{projectId}" withString:[NSString stringWithFormat:@"%ld", (long)threadID]];
    NSLog(@"POSTing to %@", url);
    
    
    NSURL *publicFileURL = [NSURL URLWithString:mediaUploadView.mediaFilePath];
    NSString *fileName = [publicFileURL lastPathComponent];
    NSString *fileExtension = [fileName pathExtension];
    // adapted from http://stackoverflow.com/a/5998683/892990
    // Borrowed from http://stackoverflow.com/questions/5996797/determine-mime-type-of-nsdata-loaded-from-a-file
    // itself, derived from  http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
    /*CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtension, NULL);
     CFStringRef mimeType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
     CFRelease(UTI);
     */
    NSMutableDictionary * params = @{@"FileName" : fileName,//fileType: (__bridge NSString*)mimeType,
                                     @"Extension" : fileExtension
                                     }.mutableCopy;
    
    if (mediaUploadView.uploadType == DFMediaUploadTypeVideo) {
        params[@"IsViddlerFile"] = @YES;
        params[@"ViddlerKey"] = mediaUploadView.publicURLString;
        params[@"FileTypeId"] = @2;
        params[@"FileType"] = @"Video";
    } else if (mediaUploadView.uploadType == DFMediaUploadTypeImage) {
        params[@"IsAmazonFile"] = @YES;
        params[@"AmazonKey"] = mediaUploadView.publicURLString;
        params[@"FileTypeId"] = @1;
        params[@"FileType"] = @"Image";
    }
    
    /*
     {
     >"FileId": 1,
     "FileName": "sample string 2",
     >"FileTypeId": 3,
     "FileType": "sample string 4",
     "Extension": "sample string 5",
     "IsAmazonFile": true,
     "AmazonKey": "sample string 7",
     "IsViddlerFile": true,
     "ViddlerKey": "sample string 9",
     >"IsCameraTagFile": true,
     >"CameraTagKey": "sample string 11",
     >"PositionId": 12,
     >"Position": "sample string 13",
     "PublicFileUrl": "sample string 14"
     }
     */
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    __weak __typeof(self) wself = self;
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Response : %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
    
    
    // CFRelease(mimeType);
    
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
        [self createThreadWithActivityID:_dailyDiary.activityId];
    }
    
}

- (IBAction)closeThis:(id)sender {
    [self resignAllResponders];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
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


-(void)setImageURL:(NSString*)url
{
    DFMediaUploadView *view = self.mediaUploadManager.currentView;
    view.uploadType = DFMediaUploadTypeImage;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url
                                                           ]];
    [view.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        view.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Image Loading Error");
    }];
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

#pragma mark - ProfilePictureDelegate
-(void)profilePicutreDidSelect:(File *)selectedProfile
{
    [self setImageURL:[selectedProfile filePath]];
}


#pragma DFMediaUploadManagerDelegate


-(void)mediaUploadManager:(DFMediaUploadManager *)mediaUploadManager didFinishUploadingForView:(DFMediaUploadView *)mediaUploadView {
    [self insertThreadFileWithMediaView:mediaUploadView];
}

-(void)mediaUploadManager:(DFMediaUploadManager *)mediaUploadManager didFailToUploadForView:(DFMediaUploadView *)mediaUploadView {
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
}

-(void)mediaUploadManagerDidFinishAllUploads:(DFMediaUploadManager *)mediaUploadManager {
    [self closeThis:self];
}


- (BOOL)mediaUploadManager:(DFMediaUploadManager*)mediaUploadManager shouldHandleTapForMediaUploadView:(DFMediaUploadView*)mediaUploadView {
    if (_diaryTheme && [_diaryTheme getModuleWithThemeType:ThemeTypeImageGallery])   {
        [self performSegueWithIdentifier:@"gallerySegue" sender:self];
        return false;
    }
    else{
        return true;
    }
}


@end
