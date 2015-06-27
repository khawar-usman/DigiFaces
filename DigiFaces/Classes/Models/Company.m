//
//  Company.m
//  DigiFaces
//
//  Created by Apple on 16/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)initWithDictioanry:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.companyID = [[dict valueForKey:@"CompanyId"] integerValue];
        self.companyName = [dict valueForKey:@"CompanyName"];
        self.logoURL = [dict valueForKey:@"LogoUrl"];
        self.baseColor = [dict valueForKey:@"BaseColor"];
    }
    return self;
}

@end
