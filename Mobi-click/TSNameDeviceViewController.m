//
//  TSNameDeviceViewController.m
//  Mobi-click
//
//  Created by Mac on 07.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSNameDeviceViewController.h"
#import "TSPostingMessagesManager.h"
#import "NSString+TSString.h"
#import "TSPrefixHeader.pch"

@interface TSNameDeviceViewController () <MFMessageComposeViewControllerDelegate, CNContactPickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameDeviceLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UITextField *textFieldNameDevice;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation TSNameDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.textFieldNameDevice.layer.borderColor = [BLUE_COLOR CGColor];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setLauguage];
    
}


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


#pragma mark - Actions


- (IBAction)actionSendButton:(id)sender
{
    
    if (![self.textFieldNameDevice.text isEqualToString:@""]) {
        self.contactPicker = [[CNContactPickerViewController alloc] init];
        self.contactPicker.delegate = self;
        
        [self presentViewController:self.contactPicker animated:YES completion:nil];
    } else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"You must enter a name to send the comand"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Ok"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                
                                                            }];
        [alertController addAction:alertAction];
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
    [self.userDefaults setObject:self.textFieldNameDevice.text forKey:@"nameDevice"];
    
    MFMessageComposeViewController *messageComposeViewController = [[TSPostingMessagesManager sharedManager] messageComposeViewController:recipients bodyMessage:[NSString changeNameDiviceComand:self.textFieldNameDevice.text]];
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
    }
    else {
        NSLog(@"Message failed");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self.titleLabel setText:@"Device name"];
    [self.nameDeviceLabel setText:@"Device name"];
    [self.sendButton setTitle:@"SEND" forState:UIControlStateNormal];
}


- (void)setGermanLaunguage
{
    [self.titleLabel setText:@"Änderung des Gerätenamens"];
    [self.nameDeviceLabel setText:@"Gerätenamens"];
    [self.sendButton setTitle:@"SENDEN" forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
