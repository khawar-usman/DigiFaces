//
//  CommentCell.m
//  DigiFaces
//
//  Created by confiz on 06/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (IBAction)addComment:(id)sender {
    
    if ([_txtComment.text isEqualToString:@""]) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(commentCell:didSendText:)]) {
        [_delegate commentCell:self didSendText:_txtComment.text];
    }
    _txtComment.text = @"";
    [_txtComment resignFirstResponder];
}

- (IBAction)exitOnEnd:(id)sender {
    [sender resignFirstResponder];
}
@end
