//
//  TextAreaResponse.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextAreaResponse : NSObject

@property (nonatomic, retain) NSString * response;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) NSInteger textAreaID;
@property (nonatomic, assign) NSInteger textAreaResponseID;
@property (nonatomic, assign) NSInteger threadID;

-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end
