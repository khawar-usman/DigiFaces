//
//  CustomAertView.m
//  DigiFaces
//
//  Created by Apple on 16/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "CustomAertView.h"

@interface CustomAertView ()

@end

@implementation CustomAertView
@synthesize textstrg = _textstrg;
@synthesize fromW = _fromW;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    
    if([_fromW isEqualToString:@"login"])
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];


    self.textLabel.numberOfLines = 0;
    
    self.textLabel.text = _textstrg;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.textLabel.text = _textstrg;

}
-(IBAction)cancel:(id)sender{
    [self.view removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(cacellButtonTapped)]) {
        [_delegate cacellButtonTapped];
    }
}

-(IBAction)okay:(id)sender{
    [self.view removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(okayButtonTapped)]) {
        [_delegate okayButtonTapped];
    }
}


-(void)showAlertWithMessage:(NSString *)msg inView:(UIView *)view
{
    _textstrg = msg;
    [self.view setFrame:view.frame];
    [view addSubview:self.view];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
