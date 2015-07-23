//
//  DFMediaUploadManager.h
//  DigiFaces
//
//  Created by James on 7/21/15.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DFMediaUploadManagerDelegate.h"
#import "DFMediaUploadView.h"

@class DFMediaUploadView;

@interface DFMediaUploadManager : NSObject<DFMediaUploadViewDelegate>

@property (nonatomic, weak) IBOutlet id viewController;

@property (nonatomic, assign) IBOutlet id<DFMediaUploadManagerDelegate> delegate;

@property (nonatomic, strong) IBOutletCollection(DFMediaUploadView) NSArray *mediaUploadViews;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) DFMediaUploadView *currentView;

- (void)uploadMediaFiles;
- (BOOL)uploadMediaFileForView:(DFMediaUploadView*)mediaUploadView;
- (BOOL)hasMedia;

@end
