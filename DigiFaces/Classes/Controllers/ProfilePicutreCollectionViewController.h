//
//  ProfilePicutreCollectionViewController.h
//  DigiFaces
//
//  Created by confiz on 22/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "File.h"

@protocol ProfilePictureViewControllerDelegate <NSObject>

-(void)profilePicutreDidSelect:(NSDictionary*)selectedProfile;

@end

@interface ProfilePicutreCollectionViewController : UICollectionViewController

@property (nonatomic, assign) id<ProfilePictureViewControllerDelegate> delegate;

@end
