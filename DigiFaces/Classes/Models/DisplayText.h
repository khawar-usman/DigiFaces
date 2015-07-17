//
//  DisplayText.h
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisplayText : NSObject

@property (nonatomic, assign) NSInteger displayTextId;
@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, retain) NSString * text;

-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end
