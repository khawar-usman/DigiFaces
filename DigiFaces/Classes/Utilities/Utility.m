//
//  Utility.m
//  DigiFaces
//
//  Created by confiz on 20/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(BOOL)saveString:(NSString *)value forKey:(NSString *)key
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    
    return [defaults synchronize];
}

+(NSString *)getStringForKey:(NSString *)key
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    id value = [defaults valueForKey:key];
    if (value != nil && ![value isKindOfClass:[NSString class]]) {
        return [value stringValue];
    }
    return value;
}

+(NSString *)getAuthToken
{
    NSString * onlinekey = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    NSString *finalyToken = [[NSString alloc]initWithFormat:@"Bearer %@",onlinekey ];
    return finalyToken;
}

+(NSString *)getUniqueId
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:@"yyyyMMdd-HHmmssSSS"];
    
    NSString *strFilename = [outputFormatter stringFromDate:[NSDate date]];
    
    return strFilename;
}

@end
