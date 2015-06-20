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
    Boolean fileType = (Boolean) [fileObject objectForKey:@"IsAmazonFile"];
    if (fileType) {
        fileKey = @"AmazonKey";
    }
    fileType = (Boolean)[fileObject objectForKey:@"IsCameraTagFile"];
    
    if (fileType) {
        fileKey = @"CameraTagKey";
    }
    fileType = (Boolean)[fileObject objectForKey:@"IsViddlerFile"];
    
    if (fileType) {
        fileKey = @"ViddlerKey";
    }
    NSString * imageUrl = [fileObject objectForKey:fileKey];
    
    return imageUrl;
}
@end
