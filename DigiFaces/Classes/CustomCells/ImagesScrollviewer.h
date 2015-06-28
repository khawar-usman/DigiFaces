//
//  ImagesScrollviewer.h
//  DigiFaces
//
//  Created by confiz on 28/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesScrollviewer : UIScrollView

@property (nonatomic, retain) NSArray * filesArray;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) UIEdgeInsets padding;

-(void)reloadData;

@end
