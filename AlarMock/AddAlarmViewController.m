//
//  TimePickerViewController.m
//  AlarMock
//
//  Created by Rick Wolchuk on 8/22/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AddAlarmViewController.h"

#import "AddAlarmView.h"
#import "AlarmJoke.h"
#import "AlarmEngine.h"
#import "AlarMockTableViewCell.h"
#import "AMColor.h"
#import "AMFont.h"
#import "SoundViewController.h"

@interface AddAlarmViewController () <UITableViewDataSource, UITableViewDelegate, SoundViewControllerDelegate>

@property (nonatomic) Alarm *alarm;
@property (nonatomic) CGFloat sliderVal;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *snoozeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *snoozeMockLabel;
@property (nonatomic) NSArray *settings;
@property (strong, nonatomic) NSArray *daysChecked;
@property (strong, nonatomic) MPMediaItem *alarmSong;

@end

@implementation AddAlarmViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.settings = @[@"Sound", @"Snooze"];
    
    self.snoozeMockLabel.font = [AMFont book14];
    self.snoozeTimeLabel.font = [AMFont book14];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.datePicker.date = [NSDate date];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self.datePicker.date];
    self.datePicker.date = [self.datePicker.date dateByAddingTimeInterval:-dateComponents.second];

    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];

    self.slider.hidden = YES;    
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return NO;
    } else {
        return YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarMockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
    cell.textLabel.text = [self.settings objectAtIndex:indexPath.row];
    cell.textLabel.font = [AMFont book22];
    if (indexPath.row == 0) {
        cell.cellSwitch.hidden = YES;
    }
    [cell.cellSwitch setOn:NO];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"soundVC" sender:self];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[SoundViewController class]]) {
        ((SoundViewController *)[segue destinationViewController]).delegate = self;
    }
}

#pragma mark - Action handlers

- (void)changeSnoozeSwitch:(id)sender
{
    if([sender isOn]) {
        self.slider.hidden = NO;
        self.snoozeTimeLabel.hidden = NO;
        self.snoozeMockLabel.hidden = NO;
    } else {
        self.slider.hidden = YES;
        self.snoozeTimeLabel.hidden = YES;
        self.snoozeMockLabel.hidden = YES;
    }
}

- (IBAction)onMoveSlider:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float val = 1 + slider.value * 58.0f;
    self.sliderVal = val;
    
    if (val == 1) {
        self.snoozeTimeLabel.text =[NSString stringWithFormat:@"Snooze for %ld minute", (long)val];
    } else {
        self.snoozeTimeLabel.text = [NSString stringWithFormat:@"Snooze for %ld minutes", (long)val];
    }
    
    if (val >=1 && val < 21) {
        self.snoozeMockLabel.text = @"I suppose this is a reasonable snooze interval";
    } else if (val >= 21 && val <= 58) {
        self.snoozeMockLabel.text = @"Seriously, who snoozes for more than 20 minutes?";
    } else if (val == 59) {
        self.snoozeMockLabel.text = @"If you think you will need to snooze this long just call in sick";
    }
}

- (IBAction)leftButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightButtonClicked:(id)sender
{
    self.alarm = [[Alarm alloc] initWithJokeCollection:self.alarmEngine.jokeCollection];
    self.alarm.fireDate = self.datePicker.date;
    self.alarm.snoozeInterval = self.sliderVal * 60;
    self.alarm.alarmSong = self.alarmSong;
    self.alarm.notificationSoundText = self.notificationSoundText;
    self.alarm.on = YES;
    
    [self.alarmEngine addAlarm:self.alarm];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchDidChangeValue:(UISwitch *)aSwitch
{
    if([aSwitch isOn]) {
        self.slider.hidden = NO;
        self.snoozeTimeLabel.hidden = NO;
        self.snoozeMockLabel.hidden = NO;
    } else {
        self.slider.hidden = YES;
        self.snoozeTimeLabel.hidden = YES;
        self.snoozeMockLabel.hidden = YES;
    }
}

#pragma mark - SoundViewControllerDelegate

- (void)soundViewController:(SoundViewController*)viewController didChooseNotificationSoundText:(NSString *)soundText didChooseSong:(MPMediaItem *)alarmSong
{
    self.alarmSong = alarmSong;
    self.notificationSoundText = soundText;
}

@end

#import <objc/runtime.h>

@implementation UILabel (WhiteUIDatePickerLabels)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(setTextColor:)
                      withNewSelector:@selector(swizzledSetTextColor:)];
        [self swizzleInstanceSelector:@selector(setFont:)
                      withNewSelector:@selector(swizzledSetFont:)];
        [self swizzleInstanceSelector:@selector(willMoveToSuperview:)
                      withNewSelector:@selector(swizzledWillMoveToSuperview:)];
    });
}

- (void)swizzledSetTextColor:(UIColor *)textColor
{
    if([self view:self hasSuperviewOfClass:[UIDatePicker class]] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerWeekMonthDayView")] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerContentView")]){
        [self swizzledSetTextColor:[AMColor whiteColor]];
    } else {
        [self swizzledSetTextColor:textColor];
    }
}

- (void)swizzledSetFont:(UIFont *)font
{
    if([self view:self hasSuperviewOfClass:[UIDatePicker class]] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerWeekMonthDayView")] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerContentView")]){
        [self swizzledSetFont:[AMFont book22]];
    } else {
        [self swizzledSetFont:font];
    }
}

- (void)swizzledWillMoveToSuperview:(UIView *)newSuperview
{
    [self swizzledSetTextColor:self.textColor];
    [self swizzledSetFont:self.font];
    [self swizzledWillMoveToSuperview:newSuperview];
}

- (BOOL)view:(UIView *) view hasSuperviewOfClass:(Class) class
{
    if(view.superview){
        if ([view.superview isKindOfClass:class]){
            return true;
        }
        return [self view:view.superview hasSuperviewOfClass:class];
    }
    return false;
}

+ (void)swizzleInstanceSelector:(SEL)originalSelector
                withNewSelector:(SEL)newSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    BOOL methodAdded = class_addMethod([self class],
                                       originalSelector,
                                       method_getImplementation(newMethod),
                                       method_getTypeEncoding(newMethod));
    
    if (methodAdded) {
        class_replaceMethod([self class],
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

@end

