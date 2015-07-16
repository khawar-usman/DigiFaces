//
//  ImageViewController.h
//  DigiFaces
//
//  Created by confiz on 16/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "File.h"
#import "PageViewLoadedDelegate.h"

@interface ImageViewController : UIViewController

@property (nonatomic, weak) id<PageViewLoadedDelegate> delegate;

@property (nonatomic, retain) File * imageFile;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)doubleClicked:(id)sender;

@end
