//
//  TextAreaResponse.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "TextAreaResponse.h"
#import "NSString+HTML.h"

@implementation TextAreaResponse

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.isActive = [[dict valueForKey:@"IsActive"] boolValue];
        self.response = [[dict valueForKey:@"Response"] stringByConvertingHTMLToPlainText];
        self.textAreaID = [[dict valueForKey:@"TextareaId"] integerValue];
        self.threadID = [[dict valueForKey:@"ThreadId"] integerValue];
    }
    
    return self;
}

@end
