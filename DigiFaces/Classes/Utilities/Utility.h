//
//  Utility.h
//  DigiFaces
//
//  Created by confiz on 20/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

+(BOOL)saveString:(NSString*)value forKey:(NSString*)key;

+(void)addPadding:(NSInteger)padding toTextField:(UITextField*)textfield;

+(NSString*)getStringForKey:(NSString*)key;
+(NSString*)getAuthToken;
+(NSString *)getUniqueId;
+(NSString*)stringFromDate:(NSDate*)date;

+(NSString*)getMonDayYearDateFromString:(NSString*)date;
+(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size;

@end
