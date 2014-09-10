//
//  SnoozeJokes.m
//  AlarMock
//
//  Created by Ben Bueltmann on 8/25/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "SnoozeJoke.h"

@implementation SnoozeJoke

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

+ (NSString *)parseClassName
{
    return @"SnoozeJoke";
}

+ (void)load
{
    [self registerSubclass];
}

@end
