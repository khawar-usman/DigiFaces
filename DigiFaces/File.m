//
//  File.m
//  DigiFaces
//
//  Created by Apple on 17/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "File.h"

@implementation File


-(NSString*)returnFilePathFromFileObject:(NSDictionary*)fileObject{
    NSString * fileKey;
    BOOL fileType = [[fileObject objectForKey:@"IsAmazonFile"] boolValue];
    if (fileType) {
        fileKey = @"AmazonKey";
    }
    fileType = [[fileObject objectForKey:@"IsCameraTagFile"] boolValue];
    
    if (fileType) {
        fileKey = @"CameraTagKey";
    }
    fileType = [[fileObject objectForKey:@"IsViddlerFile"] boolValue];
    
    if (fileType) {
        fileKey = @"ViddlerKey";
    }
    NSString * imageUrl = [fileObject objectForKey:fileKey];
    
    return imageUrl;
}
@end
