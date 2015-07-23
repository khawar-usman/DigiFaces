//
//  DFMediaUploadViewDelegate.h
//  DigiFaces
//
//  Created by James on 7/21/15.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFMediaUploadView;

@protocol DFMediaUploadViewDelegate <NSObject>

- (IBAction)didTapMediaUploadView:(DFMediaUploadView*)view;

@end
