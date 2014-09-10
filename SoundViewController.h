//
//  SoundViewController.h
//  AlarMock
//
//  Created by Patrick Hogan on 9/3/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AMViewController.h"

@protocol SoundViewControllerDelegate;

@interface SoundViewController : UIViewController

@property (nonatomic, weak) id<SoundViewControllerDelegate> delegate;

@end

@protocol SoundViewControllerDelegate <NSObject>

- (void)soundViewController:(SoundViewController*)viewController
 didChooseNotificationSoundText:(NSString *)sound
              didChooseSong:(MPMediaItem *)alarmSong;

@end

