//
//  TSExtraViewController.m
//  Mobi-click
//
//  Created by Mac on 17.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSExtraViewController.h"
#import "TSPostingMessagesManager.h"
#import "NSString+TSString.h"
#import "TSPrefixHeader.pch"

@interface TSExtraViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *realyPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *externNsPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *externDigitalPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pirPickerView;

@property (weak, nonatomic) IBOutlet UISwitch *switchRealy;
@property (weak, nonatomic) IBOutlet UISwitch *switchExtern;
@property (weak, nonatomic) IBOutlet UISwitch *switchPir;
@property (weak, nonatomic) IBOutlet UISwitch *switchLeds;
@property (weak, nonatomic) IBOutlet UISwitch *switchCommander;

@property (weak, nonatomic) IBOutlet UILabel *realyLabel;
@property (weak, nonatomic) IBOutlet UILabel *externLabel;
@property (weak, nonatomic) IBOutlet UILabel *pirLabel;
@property (weak, nonatomic) IBOutlet UILabel *ledsLabel;
@property (weak, nonatomic) IBOutlet UILabel *commanderLabel;
@property (weak, nonatomic) IBOutlet UILabel *resetSettingsLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendButtonLabel;

@property (strong, nonatomic) NSMutableArray *dataSourceRealy;
@property (strong, nonatomic) NSMutableArray *dataSourceExternDigital;
@property (strong, nonatomic) NSArray *dataSourceExternNc;
@property (strong, nonatomic) NSArray *dataSourcePir;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger recognizer;

@property (assign, nonatomic) BOOL realy;
@property (assign, nonatomic) BOOL extrn;
@property (assign, nonatomic) BOOL pir;
@property (assign, nonatomic) BOOL leds;
@property (assign, nonatomic) BOOL commander;

@end

@implementation TSExtraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureController];
}


-(void)viewWillAppear:(BOOL)animated
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


#pragma mark - Сonfigure controller


- (void)configureController
{
    
    self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.titleImageView setFrame:CGRectMake(0, 0, 250, 44)];
    self.navigationItem.titleView = self.titleImageView;
    
    self.realyPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.externNsPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.externDigitalPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.pirPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    
    
    self.dataSourceRealy = [NSMutableArray array];
    self.dataSourceExternDigital = [NSMutableArray array];
    self.dataSourceExternNc = @[@"NC", @"NO"];
    self.dataSourcePir = @[@"LOW", @"MID", @"HI"];
    
    
    for (int i = 1; i < 180; i++) {
        NSString *hourString = [NSString stringWithFormat:@"%d", i];
        hourString = [NSString stringWithFormat:@"%d", i];
        [self.dataSourceRealy addObject:hourString];
    }
    
    for (int i = 1; i < 3600; i++) {
        NSString *minString = [NSString stringWithFormat:@"%d", i];
        minString = [NSString stringWithFormat:@"%d", i];
        [self.dataSourceExternDigital addObject:minString];
    }
    
}


#pragma mark - load picker view and switch position


- (void)loadSettingsPickerView
{
    
    NSInteger valueRealyPC = [self.userDefaults integerForKey:@"valueRealy"] - 1;
    NSInteger valueExternNSPC = [self.userDefaults integerForKey:@"valueExternNS"];
    NSInteger valueExternDiditalPC = [self.userDefaults integerForKey:@"valueExternDidital"] - 1;
    NSInteger valuePirPC = [self.userDefaults integerForKey:@"valuePir"];
    
    
    [self.realyPickerView selectRow:valueRealyPC inComponent:0 animated:NO];
    [self.externNsPickerView selectRow:valueExternNSPC inComponent:0 animated:NO];
    [self.externDigitalPickerView selectRow:valueExternDiditalPC inComponent:0 animated:NO];
    [self.pirPickerView selectRow:valuePirPC inComponent:0 animated:NO];
    
    
    self.realy = [self.userDefaults boolForKey:@"switchRealy"];
    self.extrn = [self.userDefaults boolForKey:@"switchExtern"];
    self.pir = [self.userDefaults boolForKey:@"switchPir"];
    self.leds = [self.userDefaults boolForKey:@"switchLeds"];
    self.commander = [self.userDefaults boolForKey:@"switchCommander"];
    
    
    [self.switchRealy setOn:self.realy animated:YES];
    [self.switchExtern setOn:self.extrn animated:YES];
    [self.switchPir setOn:self.pir animated:YES];
    [self.switchLeds setOn:self.leds animated:YES];
    [self.switchCommander setOn:self.commander animated:YES];
    
}



#pragma mark - save picker view and switch position


- (void)savePickerViewAndSwitchPositionCommand
{
    
    NSString *valuePickerViewAlarmExternNS = nil;
    NSString *valuePickerViewPir = nil;
    
    NSString *valuePickerViewRealy = [self pickerView:self.realyPickerView titleForRow:[self.realyPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *intermediateValuePickerViewAlarmExternNS = [self pickerView:self.externNsPickerView titleForRow:[self.externNsPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewExternDigital = [self pickerView:self.externDigitalPickerView titleForRow:[self.externDigitalPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *intermediateValuePickerViewPir = [self pickerView:self.pirPickerView titleForRow:[self.pirPickerView selectedRowInComponent:0] forComponent:0];
    
    if ([intermediateValuePickerViewAlarmExternNS isEqualToString:@"NC"]) {
        valuePickerViewAlarmExternNS = @"0";
    } else if ([intermediateValuePickerViewAlarmExternNS isEqualToString:@"NO"]) {
        valuePickerViewAlarmExternNS = @"1";
    }
    
    
    if ([intermediateValuePickerViewPir isEqualToString:@"LOW"]) {
        valuePickerViewPir = @"0";
    } else if ([intermediateValuePickerViewPir isEqualToString:@"MID"]) {
        valuePickerViewPir = @"1";
    } else if ([intermediateValuePickerViewPir isEqualToString:@"HI"]) {
        valuePickerViewPir = @"2";
    }
    
    
    NSInteger realy = [valuePickerViewRealy integerValue];
    NSInteger externNS = [valuePickerViewAlarmExternNS integerValue];
    NSInteger externDidital = [valuePickerViewExternDigital integerValue];
    NSInteger pir = [valuePickerViewPir integerValue];
    
    
    [self.userDefaults setInteger:realy forKey:@"valueRealy"];
    [self.userDefaults setInteger:externNS forKey:@"valueExternNS"];
    [self.userDefaults setInteger:externDidital forKey:@"valueExternDidital"];
    [self.userDefaults setInteger:pir forKey:@"valuePir"];
    
    
    [self.userDefaults setBool:self.switchRealy.isOn forKey:@"switchRealy"];
    [self.userDefaults setBool:self.switchExtern.isOn forKey:@"switchExtern"];
    [self.userDefaults setBool:self.switchPir.isOn forKey:@"switchPir"];
    [self.userDefaults setBool:self.switchLeds.isOn forKey:@"switchLeds"];
    [self.userDefaults setBool:self.switchCommander.isOn forKey:@"switchCommander"];
    
    [self.userDefaults synchronize];
    
}


- (NSMutableArray *)configureCommand
{
    
    NSString *pin = [self.userDefaults objectForKey:@"pin"];

    NSString *commandRealy = nil;
    NSString *commandExtern = nil;
    NSString *commandPir = nil;
    NSString *commandLeds = nil;
    NSString *commandComander = nil;
    
    
    NSString *valuePickerViewRealy = [self pickerView:self.realyPickerView
                                          titleForRow:[self.realyPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewExternNs = [self pickerView:self.externNsPickerView
                                          titleForRow:[self.externNsPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewExternDigital = [self pickerView:self.externDigitalPickerView
                                          titleForRow:[self.externDigitalPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewPir = [self pickerView:self.pirPickerView
                                           titleForRow:[self.pirPickerView selectedRowInComponent:0] forComponent:0];
    
    
    if (self.realy != self.switchRealy.isOn)
    {
        if (self.switchRealy.isOn) {
            commandRealy = [NSString stringWithFormat:@"SET RELAY ALARM %@ #%@", valuePickerViewRealy, pin];
        } else {
            commandRealy = [NSString stringWithFormat:@"RESET RELAY #%@", pin];
        }
    }
    
    
    if (self.extrn != self.switchExtern.isOn)
    {
        if (self.switchExtern.isOn) {
            commandExtern = [NSString stringWithFormat:@"SET EXTERN %@ %@ #%@",
                             valuePickerViewExternNs, valuePickerViewExternDigital, pin];
        } else {
            commandExtern = [NSString stringWithFormat:@"RESET EXTERN #%@", pin];
        }
    }
    
    
    if (self.pir != self.switchPir.isOn)
    {
        if (self.switchPir.isOn) {
            commandPir = [NSString stringWithFormat:@"SET EXTERN PIR %@ #%@", valuePickerViewPir, pin];
        } else {
            commandPir = [NSString stringWithFormat:@"RESET EXTERN PIR #%@", pin];
        }
    }
    
    
    if (self.leds != self.switchLeds.isOn)
    {
        if (self.switchLeds.isOn) {
            commandLeds = [NSString stringWithFormat:@"SET LEDS #%@", pin];
        } else {
            commandLeds = [NSString stringWithFormat:@"RESET LEDS #%@", pin];
        }
    }
    
    
    if (self.commander != self.switchCommander.isOn)
    {
        if (self.switchCommander.isOn) {
            commandComander = [NSString stringWithFormat:@"SET COMMANDER #%@", pin];
        } else {
            commandComander = [NSString stringWithFormat:@"RESET COMMANDER #%@", pin];
        }
    }
    
    
    NSMutableArray *commands = [NSMutableArray array];
    
    if (commandRealy) {
        [commands addObject:commandRealy];
    }
    
    if (commandExtern) {
        [commands addObject:commandExtern];
    }
    
    if (commandPir) {
        [commands addObject:commandPir];
    }
    
    if (commandLeds) {
        [commands addObject:commandLeds];
    }
    
    if (commandComander) {
        [commands addObject:commandComander];
    }
        
    return commands;
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
            return self.dataSourceRealy.count;
            break;
        case 2:
            return self.dataSourceExternNc.count;
            break;
        case 3:
            return self.dataSourceExternDigital.count;
            break;
        case 4:
            return self.dataSourcePir.count;
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
            return [self.dataSourceRealy objectAtIndex:row];
            break;
        case 2:
            return [self.dataSourceExternNc objectAtIndex:row];
            break;
        case 3:
            return [self.dataSourceExternDigital objectAtIndex:row];
            break;
        case 4:
            return [self.dataSourcePir objectAtIndex:row];
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


- (IBAction)actionResetSettings:(id)sender
{
    
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    NSString *title = nil;
    
    if ([language isEqualToString:@"English"]) {
        
        title = @"Reset to factory setting?";
        
    } else if ([language isEqualToString:@"German"]) {
        
        title = @"Auf Werkseinstellung zurücksetzen?";
    }
    
    UIAlertController *alertController = [self sharedAlertController:title];
    
    
    UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              [self callContactPickerViewController];
                                                          }];
    
    UIAlertAction *alertActionNo = [UIAlertAction actionWithTitle:@"No"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                          }];
    [alertController addAction:alertActionOk];
    [alertController addAction:alertActionNo];
    
    [self presentViewController:alertController animated:YES completion:nil];

    self.recognizer = 2;
    self.counter = 0;
}



- (IBAction)actionSendButton:(id)sender
{
    
    BOOL switchRealy = self.switchRealy.isOn;
    BOOL switchExtern = self.switchExtern.isOn;
    BOOL switchPir = self.switchPir.isOn;
    BOOL switchLeds = self.switchLeds.isOn;
    BOOL switchCommander = self.switchCommander.isOn;
    
    if (self.realy != switchRealy || self.extrn != switchExtern ||
        self.pir != switchPir || self.leds != switchLeds ||
        self.commander != switchCommander)
    {
    
        [self callContactPickerViewController];
        self.recognizer = 1;
        self.counterComand = 0;
        
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


- (void)callContactPickerViewController
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
    
    if (self.counterComand == 0)
    {
        self.commands = [self configureCommand];
    }
    
    if ([self.commands count] > 0) {
        
        NSString *command = [self.commands objectAtIndex:0];
        
        [self messageComposeViewController:recipients command:command];
        
        ++self.counterComand;
        
    } else if (self.recognizer == 2) {
        
        [self messageComposeViewController:recipients command:[NSString resetSettingsComand]];
        
    }
    
    
//    if (self.counterComand <= [self.commands count] - 1 && self.recognizer == 1) {
//        
//        NSString *command = [self.commands objectAtIndex:self.counterComand];
//        
//        [self messageComposeViewController:recipients command:command];
//        
//        ++self.counterComand;
//        
//    } else if (self.recognizer == 2) {
//        
//        [self messageComposeViewController:recipients command:[NSString resetSettingsComand]];
//        
//    }
    
}


- (void)messageComposeViewController:(NSArray *)recipients command:(NSString *)command
{
    
    MFMessageComposeViewController *messageComposeViewController = [[TSPostingMessagesManager sharedManager] messageComposeViewController:recipients bodyMessage:command];
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
        
        if ([self.commands count] > 0 || self.recognizer == 2) {
            
            if (self.recognizer == 1 && [self.commands count] > 0)
            {
                [self.commands removeObjectAtIndex:0];
            }
            
            if (self.recognizer == 2 && self.counter == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self sendMessage:self.recipient];
                    ++self.counter;
                });
            } else if ([self.commands count] > 0 ) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self sendMessage:self.recipient];
                });
            }
            
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
    [self.resetSettingsLabel setText:@"Reset to factory settings"];
    [self.sendButtonLabel setTitle:@"SEND" forState:UIControlStateNormal];
}


- (void)setGermanLaunguage
{
    [self.resetSettingsLabel setText:@"Herstellen der Werkseinstellungen"];
    [self.sendButtonLabel setTitle:@"SENDEN" forState:UIControlStateNormal];
}


#pragma mark - UIAlertController


- (UIAlertController *)sharedAlertController:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                      preferredStyle:(UIAlertControllerStyleAlert)];
    
    
    return alertController;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
