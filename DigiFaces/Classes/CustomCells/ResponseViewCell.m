//
//  ResponseViewCell.m
//  DigiFaces
//
//  Created by confiz on 28/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "ResponseViewCell.h"
#import "File.h"

@implementation ResponseViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setFiles:(NSArray *)files
{
    _files = files;
    [self reloadFiles];
}

-(void)setImageCircular
{
    [_userImage.layer setCornerRadius:_userImage.frame.size.height/2];
}

-(void)reloadFiles
{
    NSInteger xOffset= 0;
    for (File * file in _files) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, 0, _scrollView.frame.size.height, _scrollView.frame.size.height)];
        [btn setBackgroundColor:[UIColor redColor]];
        [_scrollView addSubview:btn];
        xOffset += _scrollView.frame.size.height;
    }
    [_scrollView setContentSize:CGSizeMake(xOffset, _scrollView.frame.size.height)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)commentClicked:(id)sender {
}
@end
