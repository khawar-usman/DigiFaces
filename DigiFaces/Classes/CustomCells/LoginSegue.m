//
//  LoginSegue.m
//  DigiFaces
//
//  Created by confiz on 20/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "LoginSegue.h"
#import "AppDelegate.h"

@implementation LoginSegue

-(void)perform
{
    UIViewController * source = self.sourceViewController;
    UIViewController * destination = self.destinationViewController;
    
    CGRect destRect = destination.view.frame;
    destRect.origin.x = destRect.size.width;
    [destination.view setFrame:destRect];
    
    [source.view addSubview:destination.view];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect destRect = destination.view.frame;
        destRect.origin.x = 0;
        [destination.view setFrame:destRect];
        
    } completion:^(BOOL finished) {
        [destination.view removeFromSuperview];
        AppDelegate * app = [UIApplication sharedApplication].delegate;
        app.window.rootViewController = destination;
        
    }];
}

@end
