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

@interface ProfilePicutreCollectionViewController()
{
    CustomAertView * alertView;
}
@property (nonatomic, retain) NSDictionary * selectedImage;
@property (nonatomic, retain) NSMutableArray *avatarsArray;

@end

@implementation ProfilePicutreCollectionViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    _avatarsArray = [[NSMutableArray alloc] init];
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

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
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
    self.selectedImage = [_avatarsArray objectAtIndex:indexPath.row];
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


@end
