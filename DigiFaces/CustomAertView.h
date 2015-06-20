//
//  CustomAertView.h
//  DigiFaces
//
//  Created by Apple on 16/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUpDelegate

-(void)cacellButtonTapped;
-(void)okayButtonTapped;

@end

@interface CustomAertView : UIViewController{
    
}
@property(nonatomic,retain) NSString * textstrg;
@property(nonatomic,retain) NSString * fromW;
@property(nonatomic,retain)IBOutlet UILabel *textLabel;
@property(nonatomic,retain)id<PopUpDelegate>delegate;

-(void)showAlertWithMessage:(NSString*)msg inView:(UIView*)view;

@end
