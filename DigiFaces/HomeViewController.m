//
//  HomeViewController.m
//  DigiFaces
//
//  Created by Apple on 09/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking/AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UserManagerShared.h"
#import "File.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize usernameLabel = _usernameLabel;
@synthesize userPicture = _userPicture;
- (void)viewDidLoad {
    [super viewDidLoad];

    NSString * userNameSaved = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]?[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]:@"";
    _usernameLabel.text =  userNameSaved;
    _userPicture.contentMode = UIViewContentModeScaleToFill;
    _userPicture.clipsToBounds = YES;
    _userPicture.frame = CGRectMake(_userPicture.frame.origin.x, _userPicture.frame.origin.y, 70, 70);
   

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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

-(void)fetchUserInfo{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
     
        NSDictionary * currentProjDic = [responseObject objectForKey:@"CurrentProject"];
        NSString * projectId = [currentProjDic objectForKey:@"ProjectId"];
        NSArray * DailyDiaryList = [currentProjDic objectForKey:@"DailyDiaryList"];


        
        __weak typeof(self)weakSelf = self;
        
        NSURLRequest * requestN = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
        [_userPicture setImageWithURLRequest:requestN placeholderImage:[UIImage imageNamed:@"dummy_avatar.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [[UserManagerShared sharedManager] setProfilePic:[weakSelf resizeImage:image imageSize:CGSizeMake(100, 120)]];


        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        
        [[UserManagerShared sharedManager] setFirstName:[responseObject objectForKey:@"FirstName"]];
        [[UserManagerShared sharedManager] setLastName:[responseObject objectForKey:@"LastName"]];
        [[UserManagerShared sharedManager] setAboutMeText:[responseObject objectForKey:@"AboutMeText"]];


        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
            //[self performSegueWithIdentifier: @"ToProject" sender: self];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.imageView.image = [UIImage imageNamed:[_imageNames objectAtIndex:indexPath.row]];
    if (indexPath.row == 0) {
         cell.textLabel.text = NSLocalizedString(@"home cell", @"Home") ;
    }
    else if(indexPath.row ==1){
        cell.textLabel.text = NSLocalizedString(@"diary cell", @"Diary") ;

    }
    else if(indexPath.row ==2){
        cell.textLabel.text =NSLocalizedString(@"woman cell", @"Being a woman online") ;
        
    }
    else if(indexPath.row ==3){
        cell.textLabel.text = NSLocalizedString(@"friend cell", @"Friendship and web") ;
        
    }
    else if(indexPath.row ==4){
        cell.textLabel.text =NSLocalizedString(@"talking cell", @"Talking about brands") ;
        
    }
    else if(indexPath.row ==5){
        cell.textLabel.text = NSLocalizedString(@"brand cell", @"Brands and social media") ;
        
    }
    
    return cell;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
