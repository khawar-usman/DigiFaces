//
//  ImageCollectionCell.h
//  DigiFaces
//
//  Created by confiz on 22/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgPicture;
@property (weak, nonatomic) IBOutlet UIView *selectionView;

@end
