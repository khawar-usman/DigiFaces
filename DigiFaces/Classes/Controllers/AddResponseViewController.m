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

@interface AddResponseViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CalendarViewControlerDelegate, UITextViewDelegate>
{
    NSInteger selectedTag;
    UIImagePickerController * imagePicker;
    CalendarViewController * calendarView;
}

@property (nonatomic, retain) NSMutableArray * dataArray;

@end

@implementation AddResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [_txtResponse becomeFirstResponder];
    _dataArray = [[NSMutableArray alloc] initWithCapacity:4];
    [_btnDate setTitle:[Utility stringFromDate:[NSDate date]] forState:UIControlStateNormal];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"diaryInfoSegue"]) {
        DiaryInfoViewController * diaryInfoController = (DiaryInfoViewController*)[(UINavigationController*)segue.destinationViewController topViewController];
        diaryInfoController.isViewOnly = YES;
        diaryInfoController.dailyDiary = self.dailyDiary;
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

-(void)openCamera
{
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.allowsEditing = YES;
    
    imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage, (NSString*)kUTTypeMovie, nil];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)postData:(id)sender {
    
}

- (IBAction)closeThis:(id)sender {
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
    
    [self openCamera];
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
    NSString * strDate = [Utility stringFromDate:date];
    [_btnDate setTitle:strDate forState:UIControlStateNormal];
    [calendarView.view removeFromSuperview];
}

@end
