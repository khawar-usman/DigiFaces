//
//  DFMediaUploadManagerDelegate.h
//  DigiFaces
//
//  Created by James on 7/22/15.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFMediaUploadView, DFMediaUploadManager;

@protocol DFMediaUploadManagerDelegate <NSObject>

- (NSString*)resourceKeyForMediaUploadView:(DFMediaUploadView*)mediaUploadView inMediaUploadManager:(DFMediaUploadManager*)mediaUploadManager;

- (void)mediaUploadManager:(DFMediaUploadManager*)mediaUploadManager didFinishUploadingForView:(DFMediaUploadView*)mediaUploadView;

- (void)mediaUploadManager:(DFMediaUploadManager *)mediaUploadManager didFailToUploadForView:(DFMediaUploadView *)mediaUploadView;

- (void)mediaUploadManagerDidFinishAllUploads:(DFMediaUploadManager*)mediaUploadManager;

- (BOOL)mediaUploadManager:(DFMediaUploadManager*)mediaUploadManager shouldHandleTapForMediaUploadView:(DFMediaUploadView*)mediaUploadView;

- (void)mediaUploadManager:(DFMediaUploadManager *)mediaUploadManager didSelectMediaForView:(DFMediaUploadView *)mediaUploadView;

@end
