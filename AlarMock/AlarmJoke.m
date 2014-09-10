//
//  AlarmJokes.m
//  AlarMock
//
//  Created by Ben Bueltmann on 8/25/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AlarmJoke.h"

@implementation AlarmJoke

@dynamic joke;

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];

    if (self) {
        self.joke = [decoder decodeObjectForKey:@"joke"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.joke forKey:@"joke"];
}

#pragma mark - PFSubclass

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"AlarmJoke";
}

@end
