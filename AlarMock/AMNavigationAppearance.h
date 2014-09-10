//
//  AMNavigation.h
//  AlarMock
//
//  Created by Patrick Hogan on 9/8/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

typedef NS_ENUM(NSUInteger, AMNavigationAppearanceStyle) {
    AMNavigationAppearanceStyleDark,
    AMNavigationAppearanceStyleLight
};

@interface AMNavigationAppearance : NSObject

@property (nonatomic) AMNavigationAppearanceStyle style;

+ (instancetype)sharedInstance;

- (void)setStyle:(AMNavigationAppearanceStyle)style animated:(BOOL)animated;

@end
