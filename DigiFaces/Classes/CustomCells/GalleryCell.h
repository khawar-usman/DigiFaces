//
//  GalleryCell.h
//  DigiFaces
//
//  Created by confiz on 21/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray * files;

-(void)reloadGallery;

@end
