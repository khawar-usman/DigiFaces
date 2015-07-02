 //
//  HomeViewController.m
//  DigiFaces
//
//  Created by Apple on 09/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UserManagerShared.h"
#import "File.h"
#import "ProfilePicCell.h"
#import "SDConstants.h"
#import "Utility.h"
#import "ProfilePicutreCollectionViewController.h"

@interface HomeViewController ()<ProfilePicCellDelegate, ProfilePictureViewControllerDelegate>
{
    ProfilePicCell * picCell;
}
@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:38/255.0f green:218/255.0f blue:1 alpha:1]}];
   

    _imageNames = [[NSArray alloc]initWithObjects:@"home.png",@"diary.png",@"chat.png",@"friedship.png",@"talking.png",@"chat.png", nil];
    [self fetchUserInfo];
    // Do any additional setup after loading the view.
}

-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    return newImage;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cacellButtonTapped{
    
}

-(void)okayButtonTapped{
    
}

-(void)fetchUserHomeAnnouncements{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString * onlinekey = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    NSString *finalyToken = [[NSString alloc]initWithFormat:@"Bearer %@",onlinekey ];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:finalyToken forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    
    manager.requestSerializer = requestSerializer;
    
    
    [manager GET:@"http://digifacesservices.focusforums.com/api/Project/GetHomeAnnouncement/{projectId}" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"User JSON: %@", responseObject);
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }];
}

-(void)fetchUserInfo{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString * onlinekey = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    NSString *finalyToken = [[NSString alloc]initWithFormat:@"Bearer %@",onlinekey ];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:finalyToken forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    
    manager.requestSerializer = requestSerializer;
    
    [manager GET:@"http://digifacesservices.focusforums.com/api/Account/UserInfo" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"User JSON: %@", responseObject);
        
        NSDictionary * avatarDic = [responseObject objectForKey:@"AvatarFile"];
        File * avatarFileObj = [[File alloc]init];
        NSString * imageUrl = [avatarFileObj returnFilePathFromFileObject:avatarDic];
        [Utility saveString:imageUrl forKey:kImageURL];
        NSString * currentProjectID = [responseObject valueForKey:kCurrentPorjectID];
        NSString * email = [responseObject valueForKey:kEmail];
        [Utility saveString:currentProjectID forKey:kCurrentPorjectID];
        [Utility saveString:[responseObject valueForKey:kAboutMeText] forKey:kAboutMeText];
        [Utility saveString:email forKey:kEmail];
        
        [[UserManagerShared sharedManager] setUserInfoDictionary:responseObject];
        
//        NSDictionary * currentProjDic = [responseObject objectForKey:@"CurrentProject"];
//        NSString * projectId = [currentProjDic objectForKey:@"ProjectId"];
//        NSArray * DailyDiaryList = [currentProjDic objectForKey:@"DailyDiaryList"];

        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        __weak typeof(self)weakSelf = self;
        
        NSURLRequest * requestN = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
        [picCell.profileImage setImageWithURLRequest:requestN placeholderImage:[UIImage imageNamed:@"dummy_avatar.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            [[UserManagerShared sharedManager] setProfilePic:[weakSelf resizeImage:image imageSize:CGSizeMake(100, 120)]];

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        }];
        
        [[UserManagerShared sharedManager] setFirstName:[responseObject objectForKey:@"FirstName"]];
        [[UserManagerShared sharedManager] setLastName:[responseObject objectForKey:@"LastName"]];
        [[UserManagerShared sharedManager] setAboutMeText:[responseObject objectForKey:@"AboutMeText"]];


        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }];
}

-(void)updateProfilePicture:(NSDictionary*)profilePicture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"AboutMeId", [Utility getStringForKey:kCurrentPorjectID], @"ProjectId", @"", @"UserId", _aboutMe.text, @"AboutMeText", nil];
    
    manager.requestSerializer = requestSerializer;
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kUpdateAvagar];
    
    [manager POST:url parameters:profilePicture success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            File * file = [[File alloc] init];
            NSString * url = [file returnFilePathFromFileObject:profilePicture];
            [picCell.profileImage setImageWithURL:[NSURL URLWithString:url]];
        });
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

-(void)configurePicCell
{
    NSString * userNameSaved = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]?[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]:@"";
    
    picCell.delegate = self;
    picCell.lblUserName.text =  userNameSaved;
    picCell.profileImage.contentMode = UIViewContentModeScaleToFill;
    picCell.profileImage.clipsToBounds = YES;
    picCell.profileImage.layer.cornerRadius = 47.0;
//    _userPicture.frame = CGRectMake(_userPicture.frame.origin.x, _userPicture.frame.origin.y, 70, 70);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 7;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        // Project Introduction
        [self performSegueWithIdentifier:@"projectIntroSegue" sender:self];
    }
    else if (indexPath.row == 2){
        [self performSegueWithIdentifier:@"dailyDiarySegue" sender:self];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 166;
    }
    else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        picCell = [tableView dequeueReusableCellWithIdentifier:@"picCell"];
        [self configurePicCell];
        return picCell;
    }
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.imageView.image = [UIImage imageNamed:[_imageNames objectAtIndex:indexPath.row-1]];
    if (indexPath.row == 1) {
         cell.textLabel.text = NSLocalizedString(@"home cell", @"Home") ;
    }
    else if(indexPath.row ==2){
        cell.textLabel.text = NSLocalizedString(@"diary cell", @"Diary") ;

    }
    else if(indexPath.row ==3){
        cell.textLabel.text =NSLocalizedString(@"woman cell", @"Being a woman online") ;
        
    }
    else if(indexPath.row ==4){
        cell.textLabel.text = NSLocalizedString(@"friend cell", @"Friendship and web") ;
        
    }
    else if(indexPath.row ==5){
        cell.textLabel.text =NSLocalizedString(@"talking cell", @"Talking about brands") ;
        
    }
    else if(indexPath.row ==6){
        cell.textLabel.text = NSLocalizedString(@"brand cell", @"Brands and social media") ;
        
    }
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"profilePicSegue"]) {
        UINavigationController * navController = [segue destinationViewController];
        ProfilePicutreCollectionViewController * profileController = (ProfilePicutreCollectionViewController*)[navController topViewController];
        profileController.delegate = self;
    }
}

#pragma mark - ProfilePictureCellDelegate
-(void)cameraClicked
{
    [self performSegueWithIdentifier:@"profilePicSegue" sender:self];
}

#pragma mark - ProfilePictureCollectionViewControllerDelegate
-(void)profilePicutreDidSelect:(NSDictionary *)selectedProfile
{
    [self updateProfilePicture:selectedProfile];
    
}

@end
