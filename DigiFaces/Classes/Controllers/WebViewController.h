//
//  WebViewController.h
//  DigiFaces
//
//  Created by confiz on 22/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewLoadedDelegate.h"

@interface WebViewController : UIViewController

@property (nonatomic, weak) id<PageViewLoadedDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBack;

@property (nonatomic, retain) NSString * url;
- (IBAction)goBack:(id)sender;

@end
