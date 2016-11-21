//
//  TSTimeDateViewController.m
//  Mobi-click
//
//  Created by Mac on 07.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSTimeDateViewController.h"
#import "TSPostingMessagesManager.h"
#import "NSString+TSString.h"
#import "TSPrefixHeader.pch"

@interface TSTimeDateViewController () <MFMessageComposeViewControllerDelegate, CNContactPickerDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *hoursPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *minutesPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *daysPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *monthsPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *yearsPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *zonePickerView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) NSMutableArray *dataSourceHours;
@property (strong, nonatomic) NSMutableArray *dataSourceMinutes;
@property (strong, nonatomic) NSMutableArray *dataSourceDays;
@property (strong, nonatomic) NSMutableArray *dataSourceMonths;
@property (strong, nonatomic) NSMutableArray *dataSourceYears;
@property (strong, nonatomic) NSMutableArray *dataSourceZone;

@property (strong, nonatomic) NSString *valuePickerViewHours;
@property (strong, nonatomic) NSString *valuePickerViewMinutes;
@property (strong, nonatomic) NSString *valuePickerViewDays;
@property (strong, nonatomic) NSString *valuePickerViewMonths;
@property (strong, nonatomic) NSString *valuePickerViewYears;
@property (strong, nonatomic) NSString *valuePickerViewZone;

@end

@implementation TSTimeDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self configureController];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLauguage];
    [self loadSettingsPickerView];
}


- (void)configureController
{
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [titleImageView setFrame:CGRectMake(0, 0, 250, 44)];
    self.navigationItem.titleView = titleImageView;
    
    self.hoursPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.minutesPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.daysPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.monthsPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.yearsPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.zonePickerView.layer.borderColor = [BLUE_COLOR CGColor];
    
    
    self.dataSourceHours = [NSMutableArray array];
    self.dataSourceMinutes = [NSMutableArray array];
    self.dataSourceDays = [NSMutableArray array];
    self.dataSourceMonths = [NSMutableArray array];
    self.dataSourceYears = [NSMutableArray array];
    self.dataSourceZone = [NSMutableArray array];
    
    for (int i = 0; i < 24; i++) {
        NSString *hourString = [NSString stringWithFormat:@"%d", i];
        if ([hourString length] == 1) {
            hourString = [NSString stringWithFormat:@"0%d", i];
        }
        [self.dataSourceHours addObject:hourString];
    }
    
    for (int i = 0; i < 60; i++) {
        NSString *minString = [NSString stringWithFormat:@"%d", i];
        if ([minString length] == 1) {
            minString = [NSString stringWithFormat:@"0%d", i];
        }
        [self.dataSourceMinutes addObject:minString];
    }
    
    for (int i = 0; i < 31; i++) {
        NSString *dayString = [NSString stringWithFormat:@"%d", i + 1];
        if ([dayString length] == 1) {
            dayString = [NSString stringWithFormat:@"0%d", i + 1];
        }
        [self.dataSourceDays addObject:dayString];
    }
    
    for (int i = 0; i < 12; i++) {
        NSString *monthString = [NSString stringWithFormat:@"%d", i +1];
        if ([monthString length] == 1) {
            monthString = [NSString stringWithFormat:@"0%d", i + 1];
        }
        [self.dataSourceMonths addObject:monthString];
    }
    
    NSInteger year = 2016;
    NSInteger counter = 1;
    
    for (int i = 0; i < 11; i++) {
        
        NSString *hourString = [NSString stringWithFormat:@"%ld", (long)year];
        year = year + counter;
        [self.dataSourceYears addObject:hourString];
    }
    
    
    for (int i = -12; i < 13; i++) {
        NSString *zone = [NSString stringWithFormat:@"%d", i];
        [self.dataSourceZone addObject:zone];
    }
    
    [self.zonePickerView selectRow:12 inComponent:0 animated:NO];
}


#pragma mark - load picker view position


- (void)loadSettingsPickerView
{
    
    NSInteger valueHoursPC = [self.userDefaults integerForKey:@"valueHours"];
    NSInteger valueMinutesPC = [self.userDefaults integerForKey:@"valueMinutes"];
    NSInteger valueDaysPC = [self.userDefaults integerForKey:@"valueDays"] - 1;
    NSInteger valueMonthsPC = [self.userDefaults integerForKey:@"valueMonths"] - 1;
    NSInteger valuePickerPC = [self.userDefaults integerForKey:@"valueYears"] - 1;
    
    [self.hoursPickerView selectRow:valueHoursPC inComponent:0 animated:NO];
    [self.minutesPickerView selectRow:valueMinutesPC inComponent:0 animated:NO];
    [self.daysPickerView selectRow:valueDaysPC inComponent:0 animated:NO];
    [self.monthsPickerView selectRow:valueMonthsPC inComponent:0 animated:NO];
    [self.yearsPickerView selectRow:valuePickerPC inComponent:0 animated:NO];
    
}


#pragma mark - save picker view position


- (void)saveSettingsPickerView
{
    
    NSInteger hours = [self.valuePickerViewHours integerValue];
    NSInteger minutes = [self.valuePickerViewMinutes integerValue];
    NSInteger days = [self.valuePickerViewDays integerValue];
    NSInteger months = [self.valuePickerViewMonths integerValue];
    NSInteger years = [self.valuePickerViewYears integerValue];
    
    
    [self.userDefaults setInteger:hours forKey:@"valueHours"];
    [self.userDefaults setInteger:minutes forKey:@"valueMinutes"];
    [self.userDefaults setInteger:days forKey:@"valueDays"];
    [self.userDefaults setInteger:months forKey:@"valueMonths"];
    [self.userDefaults setInteger:years forKey:@"valueYears"];
    [self.userDefaults synchronize];
    
}



#pragma mark - Actions


- (IBAction)actionSendButton:(id)sender
{
    
    self.contactPicker = [[CNContactPickerViewController alloc] init];
    self.contactPicker.delegate = self;

    [self presentViewController:self.contactPicker animated:YES completion:nil];

}


#pragma mark - CNContactPickerDelegate


- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    
    NSArray *phoneNumbers = [contact phoneNumbers];
    CNLabeledValue *number = [phoneNumbers objectAtIndex:0];
    NSString *numberPhone = [[number value] stringValue];
    self.recipient = @[numberPhone];
    
    [self sendMessage:self.recipient];
}


#pragma mark - MFMessageComposeViewController


- (void)sendMessage:(NSArray *)recipients
{
    
    self.valuePickerViewHours = [self pickerView:self.hoursPickerView
                                         titleForRow:[self.hoursPickerView selectedRowInComponent:0] forComponent:0];
    
    self.valuePickerViewMinutes = [self pickerView:self.minutesPickerView
                                          titleForRow:[self.minutesPickerView selectedRowInComponent:0] forComponent:0];
    
    self.valuePickerViewDays = [self pickerView:self.daysPickerView
                                          titleForRow:[self.daysPickerView selectedRowInComponent:0] forComponent:0];
    
    self.valuePickerViewMonths = [self pickerView:self.monthsPickerView
                                         titleForRow:[self.monthsPickerView selectedRowInComponent:0] forComponent:0];
    
    self.valuePickerViewYears = [self pickerView:self.yearsPickerView
                                          titleForRow:[self.yearsPickerView selectedRowInComponent:0] forComponent:0];
    
    self.valuePickerViewZone = [self pickerView:self.zonePickerView
                                     titleForRow:[self.zonePickerView selectedRowInComponent:0] forComponent:0];

    
    NSDictionary *comandDictionary = @{@"hours":self.valuePickerViewHours,
                                       @"minutes":self.valuePickerViewMinutes,
                                       @"days":self.valuePickerViewDays,
                                       @"months":self.valuePickerViewMonths,
                                       @"years":self.valuePickerViewYears,
                                       @"zoneTD":self.valuePickerViewZone};
    
    
    MFMessageComposeViewController *messageComposeViewController = [[TSPostingMessagesManager sharedManager] messageComposeViewController:recipients bodyMessage:[NSString setTimeComand:comandDictionary]];
    messageComposeViewController.messageComposeDelegate = self;
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self presentViewController:messageComposeViewController animated:YES completion:nil];
    
}


#pragma mark - MFMessageComposeViewControllerDelegate


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultCancelled) {
        NSLog(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent) {
        NSLog(@"Message sent");
        [self saveSettingsPickerView];
    }
    else {
        NSLog(@"Message failed");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIPickerViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (thePickerView.tag) {
        case 1:
            return self.dataSourceHours.count;
            break;
        case 2:
            return self.dataSourceMinutes.count;
            break;
        case 3:
            return self.dataSourceDays.count;
            break;
        case 4:
            return self.dataSourceMonths.count;
            break;
        case 5:
            return self.dataSourceYears.count;
            break;
        case 6:
            return self.dataSourceZone.count;
            break;
        default:
            return 0;
            break;
    }
    
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (thePickerView.tag) {
        case 1:
            return [self.dataSourceHours objectAtIndex:row];
            break;
        case 2:
            return [self.dataSourceMinutes objectAtIndex:row];
            break;
        case 3:
            return [self.dataSourceDays objectAtIndex:row];
            break;
        case 4:
            return [self.dataSourceMonths objectAtIndex:row];
            break;
        case 5:
            return [self.dataSourceYears objectAtIndex:row];
            break;
        case 6:
            return [self.dataSourceZone objectAtIndex:row];
            break;
        default:
            return 0;
            break;
    }
}


#pragma mark - UIPickerViewDelegate



- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}


#pragma mark - methods set launguage


- (void)setLauguage
{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    
    if ([language isEqualToString:@"English"]) {
        
        [self setEngleshLaunguage];
        
    } else if ([language isEqualToString:@"German"]) {
        
        [self setGermanLaunguage];
    }
}


- (void)setEngleshLaunguage
{
    [self.titleLabel setText:@"Setting Time and Date"];
    [self.timeLabel setText:@"Time"];
    [self.dataLabel setText:@"Date"];
    [self.sendButton setTitle:@"SEND" forState:UIControlStateNormal];
}


- (void)setGermanLaunguage
{
    [self.titleLabel setText:@"Einstellung der Uhrzeit und des Datums"];
    [self.timeLabel setText:@"Uhrzeit"];
    [self.dataLabel setText:@"Datum"];
    [self.sendButton setTitle:@"SENDEN" forState:UIControlStateNormal];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
