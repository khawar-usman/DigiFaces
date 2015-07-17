//
//  TextArea.h
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextArea : NSObject

@property (nonatomic, assign) NSInteger textareaId;
@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, assign) NSInteger maxCharacters;
@property (nonatomic, retain) NSString * questionText;
@property (nonatomic, retain) NSString * placeHolder;

-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end
