//
//  TSStatusViewController.m
//  Mobi-click
//
//  Created by Mac on 07.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSStatusViewController.h"
#import "TSPostingMessagesManager.h"
#import "TSPrefixHeader.pch"


@interface TSStatusViewController () <MFMessageComposeViewControllerDelegate, CNContactPickerDelegate>

//@property (weak, nonatomic) IBOutlet UIPickerView *intervalPickerView;
//@property (weak, nonatomic) IBOutlet UIPickerView *alarmWiedPickerView;
//@property (weak, nonatomic) IBOutlet UIPickerView *gsmAlarmOnePickerView;
//@property (weak, nonatomic) IBOutlet UIPickerView *gsmAlarmTwoPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *idieAlarmPickerView;

//@property (weak, nonatomic) IBOutlet UISwitch *switchInterval;
//@property (weak, nonatomic) IBOutlet UISwitch *switchLock;
//@property (weak, nonatomic) IBOutlet UISwitch *switchRepeat;
//@property (weak, nonatomic) IBOutlet UISwitch *switchGsmAlarm;
//@property (weak, nonatomic) IBOutlet UISwitch *switchGpsAlarm;
@property (weak, nonatomic) IBOutlet UISwitch *switchidlealarm;

//@property (weak, nonatomic) IBOutlet UILabel *intervalLabel;
//@property (weak, nonatomic) IBOutlet UILabel *lockLabel;
//@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *idleaLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

//@property (strong, nonatomic) NSMutableArray *dataSourceInterval;
//@property (strong, nonatomic) NSMutableArray *dataSourceRepeat;
//@property (strong, nonatomic) NSMutableArray *dataSourceGsmAlarmOne;
//@property (strong, nonatomic) NSMutableArray *dataSourceGsmAlarmTwo;
@property (strong, nonatomic) NSMutableArray *dataSourceIdieAlarm;

//@property (strong, nonatomic) NSString *valuePickerViewInterval;
//@property (strong, nonatomic) NSString *valuePickerViewRepeat;
//@property (strong, nonatomic) NSString *valuePickerViewGsm;
//@property (strong, nonatomic) NSString *valuePickerViewGps;
@property (strong, nonatomic) NSString *valuePickerViewEdleAlarm;

//@property (strong, nonatomic) NSString *intervalCommand;

@property (assign, nonatomic) NSInteger regognizer;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (assign, nonatomic) BOOL lock;
//@property (assign, nonatomic) BOOL repeat;
//@property (assign, nonatomic) BOOL gsm;
//@property (assign, nonatomic) BOOL gps;
@property (assign, nonatomic) BOOL idlealarm;

@end

@implementation TSStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self configureController];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLaunguage];
    [self loadSettingsPickerView];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self savePickerViewAndSwitchPositionCommand];
}



#pragma mark - load picker view and switch position


- (void)loadSettingsPickerView
{
    
//    NSInteger valueIntervalPC = [self.userDefaults integerForKey:@"valueInterval"];
//    NSInteger valueRepeatPC = [self.userDefaults integerForKey:@"valueRepeatAlarm"];
//    NSInteger valueGsmPC = [self.userDefaults integerForKey:@"valueGSM"];
//    NSInteger valueGpsPC = [self.userDefaults integerForKey:@"valueGPS"] - 1;
    NSInteger valueEdlePC = [self.userDefaults integerForKey:@"valueEdleAlarm"];
    
//    NSString *string = [NSString stringWithFormat:@"%ld", (long)valueGsmPC];
//    NSMutableString *conrvertStringGsm = [NSMutableString stringWithString:string];
//    [conrvertStringGsm deleteCharactersInRange:NSMakeRange([conrvertStringGsm length] - 1, 1)];
//    NSInteger convertGsm = [conrvertStringGsm intValue];
    
//    [self.intervalPickerView selectRow:valueIntervalPC inComponent:0 animated:NO];
//    [self.alarmWiedPickerView selectRow:valueRepeatPC inComponent:0 animated:NO];
//    [self.gsmAlarmOnePickerView selectRow:convertGsm - 1 inComponent:0 animated:NO];
//    [self.gsmAlarmTwoPickerView selectRow:valueGpsPC inComponent:0 animated:NO];
    [self.idieAlarmPickerView selectRow:valueEdlePC inComponent:0 animated:NO];
    
//    BOOL interval = [self.userDefaults boolForKey:@"switchInterval"];
//    self.lock = [self.userDefaults boolForKey:@"switchLock"];
//    self.repeat = [self.userDefaults boolForKey:@"switchRepeat"];
//    self.gsm = [self.userDefaults boolForKey:@"switchGsmAlarm"];
//    self.gps = [self.userDefaults boolForKey:@"switchGpsAlarm"];
    self.idlealarm = [self.userDefaults boolForKey:@"switchidlealarm"];
    
//    [self.switchInterval setOn:interval animated:YES];
//    [self.switchLock setOn:self.lock animated:YES];
//    [self.switchRepeat setOn:self.repeat animated:YES];
//    [self.switchGsmAlarm setOn:self.gsm animated:YES];
//    [self.switchGpsAlarm setOn:self.gps animated:YES];
    [self.switchidlealarm setOn:self.idlealarm animated:YES];
 
}



#pragma mark - save picker view and switch position


- (void)savePickerViewAndSwitchPositionCommand
{

//    NSString *valuePickerViewInterval = [self pickerView:self.intervalPickerView titleForRow:[self.intervalPickerView selectedRowInComponent:0] forComponent:0];
//    
//    NSString *valuePickerViewAlarmRepeat = [self pickerView:self.alarmWiedPickerView titleForRow:[self.alarmWiedPickerView selectedRowInComponent:0] forComponent:0];
//    
//    NSString *valuePickerViewGsm = [self pickerView:self.gsmAlarmOnePickerView titleForRow:[self.gsmAlarmOnePickerView selectedRowInComponent:0] forComponent:0];
//    
//    NSString *valuePickerViewGps = [self pickerView:self.gsmAlarmTwoPickerView titleForRow:[self.gsmAlarmTwoPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewEdleAlarm = [self pickerView:self.idieAlarmPickerView titleForRow:[self.idieAlarmPickerView selectedRowInComponent:0] forComponent:0];
    
    
//    NSInteger interval = [valuePickerViewInterval integerValue];
//    NSInteger repeatAlarm = [valuePickerViewAlarmRepeat integerValue];
//    NSInteger gsm = [valuePickerViewGsm integerValue];
//    NSInteger gps = [valuePickerViewGps integerValue];
    NSInteger edleAlarm = [valuePickerViewEdleAlarm integerValue];
    
    
//    [self.userDefaults setInteger:interval forKey:@"valueInterval"];
//    [self.userDefaults setInteger:repeatAlarm forKey:@"valueRepeatAlarm"];
//    [self.userDefaults setInteger:gsm forKey:@"valueGSM"];
//    [self.userDefaults setInteger:gps forKey:@"valueGPS"];
    [self.userDefaults setInteger:edleAlarm forKey:@"valueEdleAlarm"];
    
    
//    [self.userDefaults setBool:self.switchInterval.isOn forKey:@"switchInterval"];
//    [self.userDefaults setBool:self.switchLock.isOn forKey:@"switchLock"];
//    [self.userDefaults setBool:self.switchRepeat.isOn forKey:@"switchRepeat"];
//    [self.userDefaults setBool:self.switchGsmAlarm.isOn forKey:@"switchGsmAlarm"];
//    [self.userDefaults setBool:self.switchGpsAlarm.isOn forKey:@"switchGpsAlarm"];
    [self.userDefaults setBool:self.switchidlealarm.isOn forKey:@"switchidlealarm"];
    
    [self.userDefaults synchronize];
    
}


#pragma mark - Configuration controller


- (void)configureController
{
    
    self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.titleImageView setFrame:CGRectMake(0, 0, 250, 44)];
    self.navigationItem.titleView = self.titleImageView;
    
//    self.intervalPickerView.layer.borderColor = [BLUE_COLOR CGColor];
//    self.alarmWiedPickerView.layer.borderColor = [BLUE_COLOR CGColor];
//    self.gsmAlarmOnePickerView.layer.borderColor = [BLUE_COLOR CGColor];
//    self.gsmAlarmTwoPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.idieAlarmPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    
    
//    self.dataSourceInterval = [NSMutableArray array];
//    self.dataSourceRepeat = [NSMutableArray array];
//    self.dataSourceGsmAlarmOne = [NSMutableArray array];
//    self.dataSourceGsmAlarmTwo = [NSMutableArray array];
    self.dataSourceIdieAlarm = [NSMutableArray array];
    
    
//    for (int i = 0; i < 24; i++) {
//        NSString *intervalString = [NSString stringWithFormat:@"%d", i];
//        if ([intervalString length] == 1) {
//            intervalString = [NSString stringWithFormat:@"0%d", i];
//        }
//        [self.dataSourceInterval addObject:intervalString];
//    }
//    
//    for (int i = 0; i < 61; i++) {
//        NSString *repeatString = [NSString stringWithFormat:@"%d", i];
//        if ([repeatString length] == 1) {
//            repeatString = [NSString stringWithFormat:@"0%d", i];
//        }
//        [self.dataSourceRepeat addObject:repeatString];
//    }
//    
//    for (int i = 1; i < 10; i++) {
//        NSString *gsmOneString = [NSString stringWithFormat:@"%d", i];
//        gsmOneString = [NSString stringWithFormat:@"%d0", i];
//        [self.dataSourceGsmAlarmOne addObject:gsmOneString];
//    }
//    
//    for (int i = 1; i < 61; i++) {
//        NSString *gsmTwoString = [NSString stringWithFormat:@"%d", i];
//        if ([gsmTwoString length] == 1) {
//            gsmTwoString = [NSString stringWithFormat:@"0%d", i];
//        }
//        [self.dataSourceGsmAlarmTwo addObject:gsmTwoString];
//    }
    
    for (int i = 0; i < 241; i++) {
        NSString *idieString = [NSString stringWithFormat:@"%d", i];
        if ([idieString length] == 1) {
            idieString = [NSString stringWithFormat:@"0%d", i];
        }
        [self.dataSourceIdieAlarm addObject:idieString];
    }
    
}


#pragma mark - UIPickerViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (thePickerView.tag) {
//        case 1:
//            return self.dataSourceInterval.count;
//            break;
//        case 2:
//            return self.dataSourceRepeat.count;
//            break;
//        case 3:
//            return self.dataSourceGsmAlarmOne.count;
//            break;
//        case 4:
//            return self.dataSourceGsmAlarmTwo.count;
//            break;
        case 5:
            return self.dataSourceIdieAlarm.count;
            break;
        default:
            return 0;
            break;
    }
    
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (thePickerView.tag) {
//        case 1:
//            return [self.dataSourceInterval objectAtIndex:row];
//            break;
//        case 2:
//            return [self.dataSourceRepeat objectAtIndex:row];
//            break;
//        case 3:
//            return [self.dataSourceGsmAlarmOne objectAtIndex:row];
//            break;
//        case 4:
//            return [self.dataSourceGsmAlarmTwo objectAtIndex:row];
//            break;
        case 5:
            return [self.dataSourceIdieAlarm objectAtIndex:row];
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




#pragma mark - Actions


- (IBAction)ationTestButton:(id)sender
{
    
//    self.intervalCommand = [self configureCommandStatus];
    
    self.contactPicker = [[CNContactPickerViewController alloc] init];
    self.contactPicker.delegate = self;
    
    [self presentViewController:self.contactPicker animated:YES completion:nil];
    
    self.regognizer = 1;
}


- (IBAction)ationSendButton:(id)sender
{
    
//    BOOL switchLock = self.switchLock.isOn;
//    BOOL switchRepeat = self.switchRepeat.isOn;
//    BOOL switchGsm = self.switchGsmAlarm.isOn;
//    BOOL switchGps = self.switchGpsAlarm.isOn;
    BOOL switchIdlealarm = self.switchidlealarm.isOn;
    
//    if (self.lock != switchLock || self.repeat != switchRepeat ||
//        self.gsm != switchGsm || self.gps != switchGps ||
//        self.idlealarm != switchIdlealarm)
//    {
    
    if (self.idlealarm != switchIdlealarm)
    {
    
        self.contactPicker = [[CNContactPickerViewController alloc] init];
        self.contactPicker.delegate = self;
        
        [self presentViewController:self.contactPicker animated:YES completion:nil];
        
        self.counter = 0;
        self.counterComand = 0;
        self.regognizer = 2;
        
    } else {
        
        NSString *title = @"You have not set any of the team on the current screen";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:nil
                                                                          preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                                  
                                                              }];
        
        [alertController addAction:alertActionOk];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}


#pragma mark - Configuration comand


- (NSString *)configureCommand
{
    
    NSString *pin = [self.userDefaults objectForKey:@"pin"];
    
//    NSString *commandLock = nil;
//    NSString *commandRepeatAlarm = nil;
//    NSString *commandGsm = nil;
//    NSString *commandGps = nil;
    NSString *commandEdleAlarm = nil;
    
    
//    self.valuePickerViewRepeat = [self pickerView:self.alarmWiedPickerView
//                                             titleForRow:[self.alarmWiedPickerView selectedRowInComponent:0] forComponent:0];
//    
//    self.valuePickerViewGsm = [self pickerView:self.gsmAlarmOnePickerView
//                                             titleForRow:[self.gsmAlarmOnePickerView selectedRowInComponent:0] forComponent:0];
//    
//    self.valuePickerViewGps = [self pickerView:self.gsmAlarmTwoPickerView
//                                             titleForRow:[self.gsmAlarmTwoPickerView selectedRowInComponent:0] forComponent:0];
    
    self.valuePickerViewEdleAlarm = [self pickerView:self.idieAlarmPickerView
                                             titleForRow:[self.idieAlarmPickerView selectedRowInComponent:0] forComponent:0];
    
    
    
//    if (self.lock != self.switchLock.isOn)
//    {
//        if (self.switchLock.isOn) {
//            commandLock = [NSString stringWithFormat:@"​SET LOCK #%@", pin];
//        } else {
//            commandLock = [NSString stringWithFormat:@"RESET LOCK #%@", pin];
//        }
//    }
//    
//   
//    if (self.repeat != self.switchRepeat.isOn)
//    {
//        if (self.switchRepeat.isOn) {
//            commandRepeatAlarm = [NSString stringWithFormat:@"​SET REPEAT %@ #%@", self.valuePickerViewRepeat, pin];
//        } else {
//            commandRepeatAlarm = [NSString stringWithFormat:@"RESET REPEAT #%@", pin];
//        }
//    }
//    
//    
//    if (self.gsm != self.switchGsmAlarm.isOn)
//    {
//        if (self.switchGsmAlarm.isOn) {
//            commandGsm = [NSString stringWithFormat:@"​SET GSMALARM %@ #%@", self.valuePickerViewGsm, pin];
//        } else {
//            commandGsm = [NSString stringWithFormat:@"RESET GSMALARM #%@", pin];
//        }
//    }
//    
//    
//    if (self.gps != self.switchGpsAlarm.isOn)
//    {
//        if (self.switchGpsAlarm.isOn) {
//            commandGps = [NSString stringWithFormat:@"​SET GPSALARM %@ #%@", self.valuePickerViewGps, pin];
//        } else {
//            commandGps = [NSString stringWithFormat:@"RESET GPSALARM #%@", pin];
//        }
//    }
    
    
    if (self.idlealarm != self.switchidlealarm.isOn)
    {
        if (self.switchidlealarm.isOn) {
            commandEdleAlarm = [NSString stringWithFormat:@"​SET IDLEALARM %@ #%@", self.valuePickerViewEdleAlarm, pin];
        } else {
            commandEdleAlarm = [NSString stringWithFormat:@"RESET IDLEALARM #%@", pin];
        }
    }
    
    
//    NSMutableArray *commands = [NSMutableArray array];
    
//    if (commandLock) {
//        [commands addObject:commandLock];
//    }
//    
//    if (commandRepeatAlarm) {
//        [commands addObject:commandRepeatAlarm];
//    }
//    
//    if (commandGsm) {
//        [commands addObject:commandGsm];
//    }
//    
//    if (commandGps) {
//        [commands addObject:commandGps];
//    }
    
//    if (commandEdleAlarm) {
//        [commands addObject:commandEdleAlarm];
//    }

    
    return commandEdleAlarm;
}



- (NSString *)configureCommandStatus
{
    NSString *pin = [self.userDefaults objectForKey:@"pin"];
    
    
//    self.valuePickerViewInterval = [self pickerView:self.intervalPickerView
//                                             titleForRow:[self.intervalPickerView selectedRowInComponent:0] forComponent:0];
//    
//    if (self.switchInterval.isOn) {
//        status = [NSString stringWithFormat:@"​SET STATUS %@ #%@", self.valuePickerViewInterval, pin];
//    } else {
    NSString *status = [NSString stringWithFormat:@"SET STATUS #%@", pin];
//    }
    
    return status;
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
    
//    if (self.counterComand == 0)
//    {
//        self.commands = [self configureCommand];
//    }
    
//    if ([self.commands count] > 0 || self.intervalCommand) {
    
//    if ([self.commands count] > 0) {
//    
//        NSString *command = nil;
//        
//        if (self.regognizer == 1) {
//            command = [self configureCommandStatus];
//        } else if (self.regognizer == 2) {
//            command = [self.commands objectAtIndex:0];
//        }
    
    
    NSString *command = nil;
    
    if (self.regognizer == 1) {
        command = [self configureCommandStatus];
    } else if (self.regognizer == 2) {
        command = [self configureCommand];
    }
    
        MFMessageComposeViewController *messageComposeViewController = [[TSPostingMessagesManager sharedManager] messageComposeViewController:recipients bodyMessage:command];
        messageComposeViewController.messageComposeDelegate = self;
        
        ++self.counterComand;
        [self dismissViewControllerAnimated:NO completion:nil];
        [self presentViewController:messageComposeViewController animated:YES completion:nil];
        [self savePickerViewAndSwitchPositionCommand];
//    }

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
        
//        if (self.intervalCommand)
//        {
//            self.intervalCommand = nil;
//        }
        
        if ([self.commands count] > 0 && self.regognizer == 2) {
            
            [self.commands removeObjectAtIndex:0];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self sendMessage:self.recipient];
            });
        }
        
    }
    else {
        NSLog(@"Message failed");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - methods set launguage


- (void)setLaunguage
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
//    [self.lockLabel setText:@"Lock"];
//    [self.repeatLabel setText:@"Alarm repeat"];
//    [self.intervalLabel setText:@"Interval"];
    [self.idleaLabel setText:@"Idlealarm"];
    [self.sendButton setTitle:@"SEND" forState:UIControlStateNormal];
}


- (void)setGermanLaunguage
{
//    [self.lockLabel setText:@"Tastensperre"];
//    [self.repeatLabel setText:@"Alarm-Wiederholung"];
//    [self.intervalLabel setText:@"Intervall"];
    [self.idleaLabel setText:@"IdlealarmAUDIO"];
    [self.sendButton setTitle:@"SENDEN" forState:UIControlStateNormal];
}



@end
