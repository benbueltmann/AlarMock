//
//  AlarmJokes.m
//  AlarMock
//
//  Created by Ben Bueltmann on 8/25/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AlarmJokes.h"

@implementation AlarmJokes

@dynamic joke;

+(void)load
{
    [self registerSubclass];
}

+(NSString *)parseClassName
{
    return @"AlarmJokes";
}

@end
