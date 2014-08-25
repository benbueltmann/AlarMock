//
//  TimePickerViewController.h
//  AlarMock
//
//  Created by Rick Wolchuk on 8/22/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

UIKIT_EXTERN NSString * const kLocalNotificationsPersistenceKey;
UIKIT_EXTERN NSString * const kLocalNotificationsArrayPersistenceKey;

@interface AddAlarmViewController : UIViewController
@property NSMutableArray *localNotifications;

@end
