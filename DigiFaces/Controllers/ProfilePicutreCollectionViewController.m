//
//  ProfilePicutreCollectionViewController.m
//  DigiFaces
//
//  Created by confiz on 22/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "ProfilePicutreCollectionViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "File.h"
#import "UIImageView+AFNetworking.h"
#import "ImageCollectionCell.h"
#import "CustomAertView.h"
#import <AWSRuntime/AWSRuntime.h>
#import <AWSS3/AWSS3.h>
#import "SDConstants.h"
#import "Utility.h"

@interface ProfilePicutreCollectionViewController() <UIImagePickerControllerDelegate,  UINavigationControllerDelegate, UIActionSheetDelegate, AmazonServiceRequestDelegate>
{
    CustomAertView * alertView;
    UIImagePickerController * imagePicker;
    BOOL requestFailed;
}
@property (nonatomic, retain) NSString * amazonFileURL;
@property (nonatomic, retain) NSDictionary * selectedImage;
@property (nonatomic, retain) NSMutableArray *avatarsArray;

@end

@implementation ProfilePicutreCollectionViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    _avatarsArray = [[NSMutableArray alloc] init];
    [_avatarsArray addObject:@""];
    alertView = [[CustomAertView alloc] init];
    [self fetchAvatarFiles];
}

- (void)fetchAvatarFiles{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString * onlinekey = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    NSString *finalyToken = [[NSString alloc]initWithFormat:@"Bearer %@",onlinekey ];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:finalyToken forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    [manager GET:@"http://digifacesservices.focusforums.com/api/System/GetAvatarFiles" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        NSArray * avatars = (NSArray*)responseObject;
        for(NSDictionary * temp in avatars){
            [_avatarsArray addObject:temp];
        }
        
        [self.collectionView reloadData];
        //[self CreateImageGallery];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }];
    
}

-(void)uploadImage:(UIImage*)image
{
    NSString * imageKey = [NSString stringWithFormat:@"Avatars/%@-%@.png", [Utility getStringForKey:kEmail], [Utility getUniqueId]];
    NSData * imageData = UIImagePNGRepresentation(image);
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:kS3AccessKey
                                                     withSecretKey:kS3AccessSecret];
    
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:imageKey inBucket:kS3Bucket];
    por.contentType = @"image/png";
    por.cannedACL   = [S3CannedACL publicRead];
    por.data        = imageData;
    
    self.amazonFileURL = [NSString stringWithFormat:@"http://s3.amazonaws.com/media.digifaces.com/%@", imageKey];
    
    S3TransferManager *transferManager = [S3TransferManager new];
    transferManager.s3 = s3;
    transferManager.delegate = self;
    
    [transferManager upload:por];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

-(void)initializeImagePickerWithSourceType:(UIImagePickerControllerSourceType)type
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cameraCell" forIndexPath:indexPath];
        return cell;
    }

    ImageCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    NSDictionary * file = [_avatarsArray objectAtIndex:indexPath.row];
    
    File * f = [[File alloc] init];
    
    [cell.imgPicture setImageWithURL:[NSURL URLWithString:[f returnFilePathFromFileObject:file]]];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _avatarsArray.count;
}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedImage = nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Library", nil];
        [actionSheet showInView:self.view];
    }
    else{
        self.selectedImage = [_avatarsArray objectAtIndex:indexPath.row];
    }
}

- (IBAction)cancelThis:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)doneClicked:(id)sender {
    if (self.selectedImage == nil) {
        [alertView showAlertWithMessage:@"Please select an image to set as profile picture" inView:self.navigationController.view withTag:0];
    }
    else{
        if ([_delegate respondsToSelector:@selector(profilePicutreDidSelect:)]) {
            [_delegate profilePicutreDidSelect:self.selectedImage];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * image = [info valueForKey:UIImagePickerControllerEditedImage];
    [self uploadImage:image];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType type;
    if (buttonIndex == 0) {
        // Camera
        type = UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex == 1){
        // Library
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else{
        return;
    }
    [self initializeImagePickerWithSourceType:type];
}

#pragma mark - S3Delegate
-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    if (requestFailed) {
        [alertView showAlertWithMessage:@"Error uploading image. Please try again." inView:self.navigationController.view withTag:0];
    }
    else{
        NSDictionary * parameters = @{@"FileId" : @"",
                                      @"FileName" : @"",
                                      @"FileTypeId" : @"",
                                      @"FileType" : @"Image",
                                      @"Extension" : @"png",
                                      @"IsAmazonFile" : @"1",
                                      @"AmazonKey" : self.amazonFileURL,
                                      @"IsViddlerFile" : @"0",
                                      @"ViddlerKey" : @"",
                                      @"IsCameraTagFile" : @"0",
                                      @"CameraTagKey" : @"",
                                      @"PositionId" : @"0",
                                      @"Position" : @"",
                                      @"PublicFileUrl" : @""
                                      };
        
        if ([_delegate respondsToSelector:@selector(profilePicutreDidSelect:)]) {
            [_delegate profilePicutreDidSelect:parameters];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    requestFailed = YES;
}

@end
