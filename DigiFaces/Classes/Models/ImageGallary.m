//
//  ImageGallary.m
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "ImageGallary.h"
#import "File.h"

@implementation ImageGallary

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.imageGalleryId = [[dict valueForKey:@"ImageGalleryId"] integerValue];
        self.activityId = [[dict valueForKey:@"ActivityId"] integerValue];
        
        _files = [[NSMutableArray alloc] init];
        if ([dict valueForKey:@"Files"]) {
            for (NSDictionary * file in [dict valueForKey:@"Files"]) {
                File * f = [[File alloc] initWithDictionary:file];
                [_files addObject:f];
            }
        }
        
    }
    return self;
}

@end
