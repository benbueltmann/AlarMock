//
//  AMNavigation.m
//  AlarMock
//
//  Created by Patrick Hogan on 9/8/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AMNavigationAppearance.h"

#import "AMColor.h"
#import "AMFont.h"

@implementation AMNavigationAppearance

#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static AMNavigationAppearance *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark -

- (void)setStyle:(AMNavigationAppearanceStyle)style
{
    [self setStyle:style animated:NO];
}

- (void)setStyle:(AMNavigationAppearanceStyle)style animated:(BOOL)animated
{
    _style = style;
    
    UIColor *textColor;
    UIStatusBarStyle statusBarStyle;
    switch (style) {
        case AMNavigationAppearanceStyleDark:
            textColor = [AMColor whiteColor];
            statusBarStyle = UIStatusBarStyleLightContent;
            break;
        case AMNavigationAppearanceStyleLight:
        default:
            textColor = [AMColor blackColor];
            statusBarStyle = UIStatusBarStyleDefault;
            break;
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{ NSFontAttributeName : [AMFont narrowMedium14], NSForegroundColorAttributeName: textColor }];
    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle animated:animated];
}

@end
