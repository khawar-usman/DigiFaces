//
//  CommentCell.h
//  DigiFaces
//
//  Created by confiz on 06/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentCellDelegate <NSObject>

-(void)commentCell:(id)cell didSendText:(NSString*)text;

@end

@interface CommentCell : UITableViewCell
@property (nonatomic, assign) id<CommentCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtComment;
- (IBAction)addComment:(id)sender;
- (IBAction)exitOnEnd:(id)sender;

@end
