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
#import "SDConstants.h"
#import "Utility.h"
#import "DFMediaUploadManager.h"

@interface ProfilePicutreCollectionViewController() <DFMediaUploadManagerDelegate>
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
    alertView = [[CustomAertView alloc] init];
    if (_type == ProfilePicutreTypeDefault) {
        [_avatarsArray addObject:@""];
        [self fetchAvatarFiles];
    }
    else if(_type == ProfilePicutreTypeGallery){
        self.title = @"GALLERY";
        [_avatarsArray addObjectsFromArray:_files];
    }
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

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == ProfilePicutreTypeDefault && indexPath.row == 0) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cameraCell" forIndexPath:indexPath];
        return cell;
    }
    
    ImageCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    File * file = nil;
    if (_type == ProfilePicutreTypeDefault) {
        NSDictionary * f = [_avatarsArray objectAtIndex:indexPath.row];
        file = [[File alloc] initWithDictionary:f];
    }
    else if(_type == ProfilePicutreTypeGallery){
        file = [_avatarsArray objectAtIndex:indexPath.row];
    }
    
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[file filePath]]];
    [cell.imgPicture setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [cell.imgPicture setImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    
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
    if (_type == ProfilePicutreTypeDefault && indexPath.row == 0) {
        // Let DFMediaUploadManager deal with the Tap gesture on the DFMediaUploadView
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

#pragma mark - DFMediaUploadManagerDelegate

-(NSString*)resourceKeyForMediaUploadView:(DFMediaUploadView *)mediaUploadView inMediaUploadManager:(DFMediaUploadManager *)mediaUploadManager {
    NSString * imageKey = [NSString stringWithFormat:@"Avatars/%@-%@.png", [Utility getStringForKey:kEmail], [Utility getUniqueId]];
    return imageKey;
}

-(void)mediaUploadManager:(DFMediaUploadManager *)mediaUploadManager didFailToUploadForView:(DFMediaUploadView *)mediaUploadView {
    
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
}

-(void)mediaUploadManager:(DFMediaUploadManager *)mediaUploadManager didSelectMediaForView:(DFMediaUploadView *)mediaUploadView {
    [self.mediaUploadManager uploadMediaFileForView:mediaUploadView];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

-(void)mediaUploadManager:(DFMediaUploadManager *)mediaUploadManager didFinishUploadingForView:(DFMediaUploadView *)mediaUploadView {
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
                                      @"IsAmazonFile" : @YES,
                                      @"AmazonKey" : mediaUploadView.publicURLString,
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


@end