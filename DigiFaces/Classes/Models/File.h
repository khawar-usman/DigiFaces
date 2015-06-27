//
//  File.h
//  DigiFaces
//
//  Created by Apple on 17/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface File : NSObject

@property (nonatomic, retain) NSString * fileType;
@property (nonatomic) BOOL isAmazonFile;
@property (nonatomic) BOOL isCameraTag;
@property (nonatomic) BOOL isViddlerFile;
@property (nonatomic, retain) NSString * filePath;

-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(NSString*)returnFilePathFromFileObject:(NSDictionary*)fileObject;
@end
