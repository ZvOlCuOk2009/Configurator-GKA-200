//
//  TSMeinViewController.m
//  Mobi-click
//
//  Created by Mac on 07.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSMeinViewController.h"
#import "TSPrefixHeader.pch"
#import "TSLaunguageViewController.h"
#import "TSPostingMessagesManager.h"
#import "TSSensorViewController.h"

@interface TSMeinViewController ()

@property (weak, nonatomic) IBOutlet UIButton *deviceButton;
@property (weak, nonatomic) IBOutlet UIButton *sosButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UISwitch *switchAlarm;
@property (weak, nonatomic) IBOutlet UISwitch *switchMove;
@property (weak, nonatomic) IBOutlet UISwitch *switchVoice;
@property (weak, nonatomic) IBOutlet UISwitch *switchPressure;
@property (weak, nonatomic) IBOutlet UISwitch *switchPIR;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sosLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmLabel;
@property (weak, nonatomic) IBOutlet UILabel *moveLabel;
@property (weak, nonatomic) IBOutlet UILabel *voiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *vibraLabel;

@property (strong, nonatomic) NSDictionary *valuesDictionary;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSString *sensorSettingsMovie;
@property (strong, nonatomic) NSString *sensorSettingsVoice;
@property (strong, nonatomic) NSString *sensorSettingsVibra;

@property (assign, nonatomic) BOOL alarm;
@property (assign, nonatomic) BOOL move;
@property (assign, nonatomic) BOOL voice;
@property (assign, nonatomic) BOOL pressure;
@property (assign, nonatomic) BOOL pir;

@end

@implementation TSMeinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self configureController];
    
    NSInteger counter = [self.userDefaults integerForKey:@"counter"];
    if (counter == 0) {
        
        NSString *defaultPin = @"1513";
        NSString *nameDevice = @"GKA 200";
        [self.userDefaults setObject:defaultPin forKey:@"pin"];
        [self.userDefaults setObject:nameDevice forKey:@"nameDevice"];
        [self.userDefaults setInteger:1 forKey:@"counter"];
        [self.userDefaults synchronize];
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLaunguage];
    [self loadPositionSwitchs];
    
    NSString *nameDevice = [self.userDefaults objectForKey:@"nameDevice"];
    [self.deviceButton setTitle:nameDevice forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(valuesPickerViewSensorContrNotification:)
                                                 name:ValuesPickerViewNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

}


- (void)viewDidDisappear:(BOOL)animated
{
    [self savePositionsSwitchs];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.scrollView setContentSize:CGSizeMake(320, 603)];
    
    if (IS_IPHONE_4) {
        self.scrollView.frame = CGRectMake(0, 64, 320, 436);
    } else if (IS_IPHONE_5) {
        self.scrollView.frame = CGRectMake(0, 64, 320, 524);
    } else if (IS_IPHONE_6) {
        self.scrollView.frame = CGRectMake(0, 64, 375, 623);
    } else if (IS_IPHONE_6_PLUS) {
        [self.scrollView setContentSize:CGSizeMake(320, 672)];
        self.scrollView.frame = CGRectMake(0, 64, 414, 692);
    }
}


- (void)savePositionsSwitchs
{
    [self.userDefaults setBool:self.switchAlarm.isOn forKey:@"switchAlarm"];
    [self.userDefaults setBool:self.switchMove.isOn forKey:@"switchMove"];
    [self.userDefaults setBool:self.switchVoice.isOn forKey:@"switchVoice"];
    [self.userDefaults setBool:self.switchPressure.isOn forKey:@"switchPressure"];
    [self.userDefaults setBool:self.switchPIR.isOn forKey:@"switchPIR"];
    [self.userDefaults synchronize];
}


- (void)loadPositionSwitchs
{
    self.alarm = [self.userDefaults boolForKey:@"switchAlarm"];
    self.move = [self.userDefaults boolForKey:@"switchMove"];
    self.voice = [self.userDefaults boolForKey:@"switchVoice"];
    self.pressure = [self.userDefaults boolForKey:@"switchPressure"];
    self.pir = [self.userDefaults boolForKey:@"switchPIR"];
    
    [self.switchAlarm setOn:self.alarm animated:YES];
    [self.switchMove setOn:self.move animated:YES];
    [self.switchVoice setOn:self.voice animated:YES];
    [self.switchPressure setOn:self.pressure animated:YES];
    [self.switchPIR setOn:self.pir animated:YES];
}


#pragma mark - Notification


- (void)valuesPickerViewSensorContrNotification:(NSNotification *)notification
{
    self.valuesDictionary = [notification object];
}


#pragma mark - Configuration


- (void)configureController
{
    
    self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.titleImageView setFrame:CGRectMake(0, 0, 250, 44)];
    self.navigationItem.titleView = self.titleImageView;
    
    self.deviceButton.layer.borderColor = BLUE_COLOR.CGColor;
    self.sosButton.layer.borderColor = BLUE_COLOR.CGColor;

    self.clickImage = [UIImage imageNamed:@"click"];
    self.noclickImage = [UIImage imageNamed:@"noclick"];
    
    self.counterComand = 0;
}


- (NSMutableArray *)configureCommand
{
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pin = [self.userDefaults objectForKey:@"pin"];
    
    
    NSString *commandAlarm = nil;
    NSString *commandMove = nil;
    NSString *commandVoice = nil;
    NSString *commandPressure = nil;
    NSString *commandPIR = nil;
    
    if (self.alarm != self.switchAlarm.isOn)
    {
        if (self.switchAlarm.isOn) {
            commandAlarm = [NSString stringWithFormat:@"ALARM ENABLE #%@", pin];
        } else {
            commandAlarm = [NSString stringWithFormat:@"ALARM DISABLE #%@", pin];
        }
    }
    
    if (self.move != self.switchMove.isOn)
    {
        if (self.switchMove.isOn) {
            commandMove = [NSString stringWithFormat:@"SET GUARD %@ #%@", self.sensorSettingsMovie, pin];
        } else {
            commandMove = [NSString stringWithFormat:@"RESET GUARD #%@", pin];
        }
    }
    
    if (self.voice != self.switchVoice.isOn)
    {
        if (self.switchVoice.isOn) {
            commandVoice = [NSString stringWithFormat:@"SET VOICE %@ #%@", self.sensorSettingsVoice, pin];
        } else {
            commandVoice = [NSString stringWithFormat:@"RESET VOICE #%@", pin];
        }
    }
    
    if (self.pressure != self.switchPressure.isOn)
    {
        if (self.switchPressure.isOn) {
            commandPressure = [NSString stringWithFormat:@"SET PRESSURE %@ #%@", self.sensorSettingsVibra, pin];
        } else {
            commandPressure = [NSString stringWithFormat:@"RESET PRESSURE #%@", pin];
        }
    }
    
    if (self.pir != self.switchPIR.isOn)
    {
        if (self.switchPIR.isOn) {
            commandPIR = [NSString stringWithFormat:@"SET MOVE #%@", pin];
        } else {
            commandPIR = [NSString stringWithFormat:@"RESET MOVE #%@", pin];
        }
    }
    
    
    NSMutableArray *comands = [NSMutableArray array];
    
    if (commandAlarm) {
        [comands addObject:commandAlarm];
    }
    
    if (commandMove) {
        [comands addObject:commandMove];
    }

    if (commandVoice) {
        [comands addObject:commandVoice];
    }
    
    if (commandPressure) {
        [comands addObject:commandPressure];
    }
    
    if (commandPIR) {
        [comands addObject:commandPIR];
    }
    
    return comands;
}


#pragma mark - Actions


- (IBAction)actionSendButton:(id)sender
{
    
    if (self.alarm != self.switchAlarm.isOn || self.move != self.switchMove.isOn ||
        self.voice != self.switchVoice.isOn || self.pressure != self.switchPressure.isOn || self.pir != self.switchPIR.isOn)
    {
        
        self.sensorSettingsMovie = [self.valuesDictionary objectForKey:@"valueMove"];
        self.sensorSettingsVoice = [self.valuesDictionary objectForKey:@"valueVoice"];
        self.sensorSettingsVibra = [self.valuesDictionary objectForKey:@"valueVibra"];
        
        
        if (!self.sensorSettingsMovie)
        {
            NSInteger valueMovie = [self.userDefaults integerForKey:@"valueMove"];
            self.sensorSettingsMovie = [NSString stringWithFormat:@"%ld", (long)valueMovie];
        }
        
        if (!self.sensorSettingsVoice)
        {
            NSInteger valueVoice = [self.userDefaults integerForKey:@"valueVoice"];
            self.sensorSettingsVoice = [NSString stringWithFormat:@"%ld", (long)valueVoice];
        }
        
        if (!self.sensorSettingsVibra)
        {
            NSInteger valueVibra = [self.userDefaults integerForKey:@"valueVibra"];
            self.sensorSettingsVibra = [NSString stringWithFormat:@"%ld", (long)valueVibra];
        }
        
        
        if (self.sensorSettingsMovie && self.sensorSettingsVibra && self.sensorSettingsVoice) {
            
            self.contactPicker = [[CNContactPickerViewController alloc] init];
            self.contactPicker.delegate = self;
            
            [self presentViewController:self.contactPicker animated:YES completion:nil];
            
            self.counter = 0;
            self.counterComand = 0;
            
        } else {
            
            NSString *title = @"For the formation of command, you need to confirm the settings on the screen ""Sensor""";
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                     message:nil
                                                                              preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      
                                                                      TSSensorViewController *sensorViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TSSensorViewController"];
                                                                      [self.navigationController pushViewController:sensorViewController animated:YES];
                                                                      
                                                                  }];
            
            [alertController addAction:alertActionOk];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }

        
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
    
    if (self.counterComand == 0) {
        self.commands = [self configureCommand];
        
    }
 
    
    if ([self.commands count] > 0) {
        
        NSString *comand = [self.commands objectAtIndex:0];
        
        MFMessageComposeViewController *messageComposeViewController = [[TSPostingMessagesManager sharedManager] messageComposeViewController:recipients bodyMessage:comand];
        messageComposeViewController.messageComposeDelegate = self;
        
        ++self.counterComand;
        
        [self dismissViewControllerAnimated:NO completion:nil];
        [self presentViewController:messageComposeViewController animated:YES completion:nil];
    }
    
}


#pragma mark - MFMessageComposeViewControllerDelegate


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultCancelled) {
        NSLog(@"Message cancelled");
    } else if (result == MessageComposeResultSent) {
        NSLog(@"Message sent");
        
            if ([self.commands count] > 0)
            {
                [self.commands removeObjectAtIndex:0];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self sendMessage:self.recipient];

            });
    } else {
        NSLog(@"Message failed");
    }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



#pragma mark - Keyboard notification


- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.view.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.view.frame.origin.y - kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
    
}


- (void)keyboardDidHide:(NSNotification *)notification
{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
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
    [self.deviceLabel setText:@"Device"];
    [self.sosLabel setText:@"SOS"];
    [self.alarmLabel setText:@"Alarm"];
    [self.moveLabel setText:@"Move"];
    [self.voiceLabel setText:@"Voice"];
    [self.vibraLabel setText:@"Vibra"];
    [self.sosButton setTitle:@"Phone numbers" forState:UIControlStateNormal];
    [self.sendButton setTitle:@"SEND" forState:UIControlStateNormal];
}


- (void)setGermanLaunguage
{
    [self.deviceLabel setText:@"Gerät"];
    [self.sosLabel setText:@"SOS"];
    [self.alarmLabel setText:@"Alarm"];
    [self.moveLabel setText:@"Bewegung"];
    [self.voiceLabel setText:@"Stimme"];
    [self.vibraLabel setText:@"Vibra"];
    [self.sosButton setTitle:@"Telefonnummern" forState:UIControlStateNormal];
    [self.sendButton setTitle:@"SENDEN" forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
