//
//  Utility.h
//  DigiFaces
//
//  Created by confiz on 20/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(BOOL)saveString:(NSString*)value forKey:(NSString*)key;

+(NSString*)getStringForKey:(NSString*)key;
+(NSString*)getAuthToken;
+(NSString *)getUniqueId;

+(NSString*)getMonDayYearDateFromString:(NSString*)date;

@end
