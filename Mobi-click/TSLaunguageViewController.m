//
//  TSLaunguageViewController.m
//  Mobi-click
//
//  Created by Mac on 07.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSLaunguageViewController.h"
#import "TSPostingMessagesManager.h"
#import "NSString+TSString.h"
#import "TSPrefixHeader.pch"


@interface TSLaunguageViewController () <MFMessageComposeViewControllerDelegate, CNContactPickerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *launguagePickerView;

@property (weak, nonatomic) IBOutlet UILabel *launguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPinLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *displayOldPinLabel;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNewPin;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSString *launguage;
@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation TSLaunguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self configureController];
    [self setPinToLabel];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.launguage = [self.userDefaults objectForKey:@"language"];
    NSInteger row;
    if ([self.launguage isEqualToString:@"English"]) {
        row = 0;
    } else if ([self.launguage isEqualToString:@"German"]) {
        row = 1;
    }
    
    [self.launguagePickerView selectRow:row inComponent:0 animated:NO];
    
}


/*
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        if (IS_IPHONE_4) {
            [self.scrollView setContentSize:CGSizeMake(320, 436)];
            self.scrollView.frame = CGRectMake(0, 64, 320, 436);
        } else if (IS_IPHONE_5) {
            [self.scrollView setContentSize:CGSizeMake(320, 524)];
            self.scrollView.frame = CGRectMake(0, 64, 320, 524);
        } else if (IS_IPHONE_6) {
            [self.scrollView setContentSize:CGSizeMake(320, 603)];
            self.scrollView.frame = CGRectMake(0, 64, 375, 603);
        } else if (IS_IPHONE_6_PLUS) {
            [self.scrollView setContentSize:CGSizeMake(320, 672)];
            self.scrollView.frame = CGRectMake(0, 64, 414, 672);
        }
        
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        if (IS_IPAD_2) {
            [self.scrollView setContentSize:CGSizeMake(768, 960)];
            self.scrollView.frame = CGRectMake(0, 64, 768, 960);
        } else if (IS_IPAD_AIR) {
            [self.scrollView setContentSize:CGSizeMake(1536, 1984)];
            self.scrollView.frame = CGRectMake(0, 64, 1536, 1984);
        } else if (IS_IPAD_PRO) {
            [self.scrollView setContentSize:CGSizeMake(2048, 2732)];
            self.scrollView.frame = CGRectMake(0, 64, 2048, 2732);
        }
        
    }
    
}
*/


- (void)configureController
{
    
    self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.titleImageView setFrame:CGRectMake(0, 0, 250, 44)];
    self.navigationItem.titleView = self.titleImageView;
    
    self.dataSource = @[@"English", @"German"];
    self.launguagePickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.textFieldNewPin.layer.borderColor = [BLUE_COLOR CGColor];
    self.displayOldPinLabel.layer.borderColor = [BLUE_COLOR CGColor];

}


- (void)setPinToLabel
{
    NSString *pin = [self.userDefaults objectForKey:@"pin"];
    self.displayOldPinLabel.text = [NSString stringWithFormat:@"  %@", pin];
}


#pragma mark - warning that the command is not sent


- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    if (!parent && ([[self configureCommand:0] count] > 0)){
        UIAlertController *alertController = [self alertController:@"The changes will take effect only on the device. To send a command, go back and click ""SEND"" button !!!"];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - UIPickerViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSource.count;
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (row == 0) {
        [self setEngleshLaunguage];
        [self.userDefaults setObject:@"English" forKey:@"language"];
        [self.userDefaults synchronize];
    } else {
        [self setGermanLaunguage];
        [self.userDefaults setObject:@"German" forKey:@"language"];
        [self.userDefaults synchronize];
    }
    
    return [self.dataSource objectAtIndex:row];
}


- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    return component;
}


#pragma mark - UIPickerViewDelegate



- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}



#pragma mark - Actions


- (IBAction)actionSendButton:(id)sender
{
    NSString *currentValueLaunguage = [self currentValuePickerViewLaunguage];
    
    if (![self.textFieldNewPin.text isEqualToString:@""] || ![self.launguage isEqualToString:currentValueLaunguage])
    {
        self.contactPicker = [[CNContactPickerViewController alloc] init];
        self.contactPicker.delegate = self;
        
        [self presentViewController:self.contactPicker animated:YES completion:nil];
        
        self.counter = 0;
        self.counterComand = 0;
    }
   
}


#pragma mark - Configure comand


- (NSMutableArray *)configureCommand:(NSInteger)recognizer
{
    NSString *currentValueLaunguage = [self currentValuePickerViewLaunguage];
    
    NSString *pin = [self.userDefaults objectForKey:@"pin"];
    
    NSString *prefixLaunguage = nil;
    
    if ([currentValueLaunguage isEqualToString:@"English"]) {
        prefixLaunguage = @"EN";
    } else if ([currentValueLaunguage isEqualToString:@"German"]) {
        prefixLaunguage = @"DE";
    }
    
    NSMutableArray *comands = [NSMutableArray array];
    
    if (![self.launguage isEqualToString:currentValueLaunguage]) {
        NSString *changeLaunguageComand = [NSString stringWithFormat:@"SET LANGUAGE %@ #%@", prefixLaunguage, pin];
        [comands addObject:changeLaunguageComand];
    }
    
    if (![self.textFieldNewPin.text isEqualToString:@""] && ![pin isEqualToString:self.textFieldNewPin.text])
    {
        NSString *changePinComand = [NSString stringWithFormat:@"SET PIN %@ #%@", self.textFieldNewPin.text, pin];
        [comands addObject:changePinComand];
        if (recognizer == 1) {
            [self.userDefaults setObject:self.textFieldNewPin.text forKey:@"pin"];
        }
    }
    
    
    return comands;
}


- (NSString *)currentValuePickerViewLaunguage
{
    NSString *valuePickerViewLaunguage = [self pickerView:self.launguagePickerView
                                              titleForRow:[self.launguagePickerView selectedRowInComponent:0] forComponent:0];
    return valuePickerViewLaunguage;
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
        self.commands = [self configureCommand:1];
    }
    
    if (self.counterComand <= [self.commands count]) {
        
        NSString *comand = [self.commands objectAtIndex:self.counterComand];
    
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
    }
    else if (result == MessageComposeResultSent) {
        NSLog(@"Message sent");
        [self setPinToLabel];
        self.textFieldNewPin.text = @"";
        NSInteger countComand = [self.commands count] - 1;
        if (self.counter < countComand) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self sendMessage:self.recipient];
                ++self.counter;
            });
        }
    }
    else {
        NSLog(@"Message failed");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - methods set launguage


- (void)setEngleshLaunguage
{
    [self.launguageLabel setText:@"Language"];
    [self.oldPinLabel setText:@"Old PIN"];
    [self.pinLabel setText:@"New PIN"];
    [self.sendButton setTitle:@"SEND" forState:UIControlStateNormal];
}


- (void)setGermanLaunguage
{
    [self.launguageLabel setText:@"Sprache"];
    [self.oldPinLabel setText:@"Alt PIN"];
    [self.pinLabel setText:@"Neu PIN"];
    [self.sendButton setTitle:@"SENDEN" forState:UIControlStateNormal];
}


#pragma mark - UIAlertController


- (UIAlertController *)alertController:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Ok"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            
                                                        }];
    [alertController addAction:alertAction];
    
    return alertController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
