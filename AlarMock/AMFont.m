//
//  AMFont.m
//  AlarMock
//
//  Created by Patrick Hogan on 9/8/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AMFont.h"

static NSString * const kFontClanOTBook = @"ClanOT-Book";
static NSString * const kFontClanNarrowMedium = @"ClanOT-NarrMedium";

@implementation AMFont

//TODO:split font properties ie. snoozeLabelFont, barButtonItemFont...., same with colors not a number

#pragma mark - Book

+ (UIFont *)book14
{
    return [self bookWithSize:14.0f];
}

+ (UIFont *)book16
{
    return [self bookWithSize:16.0f];
}

+ (UIFont *)book22
{
    return [self bookWithSize:22.0f];
}

+ (UIFont *)book28
{
    return [self bookWithSize:28.0f];
}

+ (UIFont *)book48
{
    return [self bookWithSize:48.0f];
}

+ (UIFont *)bookWithSize:(CGFloat)size
{
    return [UIFont fontWithName:kFontClanOTBook size:size];
}

#pragma mark - Narrow Medium

+ (UIFont *)narrowMedium14
{
    return [self narrowMediumWithSize:14.0f];
}

+ (UIFont *)narrowMediumWithSize:(CGFloat)size
{
    return [UIFont fontWithName:kFontClanNarrowMedium size:size];
}

@end
