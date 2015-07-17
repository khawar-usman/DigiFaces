//
//  DisplayFile.h
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface DisplayFile : NSObject

@property (nonatomic, assign) NSInteger displayFileId;
@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, assign) NSInteger fileId;
@property (nonatomic, retain) File * file;

-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end
