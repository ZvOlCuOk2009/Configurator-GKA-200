//
//  TSGPSViewController.m
//  Mobi-click
//
//  Created by Mac on 16.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSGPSViewController.h"
#import "TSPostingMessagesManager.h"
#import "TSPrefixHeader.pch"
#import "NSString+TSString.h"

@interface TSGPSViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *nsOnePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *ewOnePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *nsTwoPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *ewTwoPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *zonePickerView;

@property (weak, nonatomic) IBOutlet UITextField *lattitudeOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *longtittudeOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *lattitudeTwoTextField;
@property (weak, nonatomic) IBOutlet UITextField *longtittudeTwoTextField;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lattitudeOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *loungtittudeOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *lattitudeTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *loungtittudeTwoLabel;
@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *testButton;

@property (strong, nonatomic) NSArray *dataSourceNS;
@property (strong, nonatomic) NSArray *dataSourceEW;
@property (strong, nonatomic) NSArray *dataSourceZone;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger determinant;

@end

@implementation TSGPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureController];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLaunguage];
}


#pragma mark - Actions


- (IBAction)actionButtonSet:(id)sender
{
    
    NSUInteger characterCountLattitudeOne = [self.lattitudeOneTextField.text length];
    NSUInteger characterCountLongtittudeeOne = [self.longtittudeOneTextField.text length];
    NSUInteger characterCountLattitudeTwo = [self.lattitudeTwoTextField.text length];
    NSUInteger characterCountLongtittudeeTWo = [self.longtittudeTwoTextField.text length];
    
    
    if (characterCountLattitudeOne < 9) {
        
        UIAlertController *alertController = [self sharedAlertController:@"Not enough characters for the latitude. Must be 8 digitals"];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else if (characterCountLongtittudeeOne < 10) {
        
        UIAlertController *alertController = [self sharedAlertController:@"Not enough characters for longitude. Must be 9 digitals"];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else if (characterCountLattitudeTwo < 9) {
        
        UIAlertController *alertController = [self sharedAlertController:@"Not enough characters for the latitude. Must be 8 digitals"];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else if (characterCountLongtittudeeTWo < 10) {
        
        UIAlertController *alertController = [self sharedAlertController:@"Not enough characters for longitude. Must be 9 digitals"];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [self callContactPickerViewController];
        self.determinant = 1;
        
    }
    
}


- (IBAction)actionButtonReset:(id)sender
{
    [self callContactPickerViewController];
    self.determinant = 2;
}


- (IBAction)actionButtonTest:(id)sender
{
    [self callContactPickerViewController];
    self.determinant = 3;
}


- (void)callContactPickerViewController
{
    self.contactPicker = [[CNContactPickerViewController alloc] init];
    self.contactPicker.delegate = self;
    
    [self presentViewController:self.contactPicker animated:YES completion:nil];
}


#pragma mark - UITextFieldDelegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    static const int lattitudeNumberMaxLength = 10;
    static const int longtittudeNumberMaxLength = 11;
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return NO;
    }
    
    
    NSArray* validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    
    newString = [validComponents componentsJoinedByString:@""];
    
    
    NSMutableString* resaultString = [NSMutableString string];
    
    
    if ([textField isEqual:self.lattitudeOneTextField] || [textField isEqual:self.lattitudeTwoTextField]) {
        
        NSInteger lattitudeLength = MIN([newString length], lattitudeNumberMaxLength);
        
        if (lattitudeLength > 0) {
            
            NSString* number = [newString substringFromIndex:(int)[newString length] - lattitudeLength];
            
            [resaultString appendString:number];
            
            if ([resaultString length] > 2) {
                [resaultString insertString:@"." atIndex:2];
            }
        }
        
        if ([resaultString length] >= 10) {
            return NO;
        }
        
    } else if ([textField isEqual:self.longtittudeOneTextField] || [textField isEqual:self.longtittudeTwoTextField]) {
        
        NSInteger longtittudeLength = MIN([newString length], longtittudeNumberMaxLength);
        
        if (longtittudeLength > 0) {
            
            NSString* number = [newString substringFromIndex:(int)[newString length] - longtittudeLength];
            
            [resaultString appendString:number];
            
            if ([resaultString length] > 3) {
                [resaultString insertString:@"." atIndex:3];
            }
        }
        
        if ([resaultString length] >= 11) {
            return NO;
        }
    }
    

    textField.text = resaultString;
    
    return NO;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.lattitudeOneTextField) {
        [textField resignFirstResponder];
        [self.longtittudeOneTextField becomeFirstResponder];
    } else if (textField == self.longtittudeOneTextField) {
        [textField resignFirstResponder];
        [self.lattitudeTwoTextField becomeFirstResponder];
    } else if (textField == self.lattitudeTwoTextField) {
        [textField resignFirstResponder];
        [self.longtittudeTwoTextField becomeFirstResponder];
    }
    
    return YES;
}


#pragma mark - Configuration controller


- (void)configureController
{
    
    self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.titleImageView setFrame:CGRectMake(0, 0, 250, 44)];
    self.navigationItem.titleView = self.titleImageView;
    
    self.nsOnePickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.ewOnePickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.nsTwoPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.ewTwoPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.zonePickerView.layer.borderColor = [BLUE_COLOR CGColor];
    
    self.lattitudeOneTextField.layer.borderColor = [BLUE_COLOR CGColor];
    self.longtittudeOneTextField.layer.borderColor = [BLUE_COLOR CGColor];
    self.lattitudeTwoTextField.layer.borderColor = [BLUE_COLOR CGColor];
    self.longtittudeTwoTextField.layer.borderColor = [BLUE_COLOR CGColor];
    
    
    self.dataSourceNS = @[@"N", @"S"];
    self.dataSourceEW = @[@"E", @"W"];
    self.dataSourceZone = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
    
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
            return self.dataSourceNS.count;
            break;
        case 2:
            return self.dataSourceEW.count;
            break;
        case 3:
            return self.dataSourceNS.count;
            break;
        case 4:
            return self.dataSourceEW.count;
            break;
        case 5:
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
            return [self.dataSourceNS objectAtIndex:row];
            break;
        case 2:
            return [self.dataSourceEW objectAtIndex:row];
            break;
        case 3:
            return [self.dataSourceNS objectAtIndex:row];
            break;
        case 4:
            return [self.dataSourceEW objectAtIndex:row];
            break;
        case 5:
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
    
    NSString *valuePickerViewNsOne = [self pickerView:self.nsOnePickerView
                                          titleForRow:[self.nsOnePickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewEwOne = [self pickerView:self.ewOnePickerView
                                          titleForRow:[self.ewOnePickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewNsTwo = [self pickerView:self.nsTwoPickerView
                                          titleForRow:[self.nsTwoPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewEwTwoe = [self pickerView:self.ewTwoPickerView
                                           titleForRow:[self.ewTwoPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewZone = [self pickerView:self.zonePickerView
                                         titleForRow:[self.zonePickerView selectedRowInComponent:0] forComponent:0];

    
    NSDictionary *dictionaryValue = @{@"nsOne":valuePickerViewNsOne,
                                      @"ewOne":valuePickerViewEwOne,
                                      @"nsTwo":valuePickerViewNsTwo,
                                      @"ewTwo":valuePickerViewEwTwoe,
                                      @"zone":valuePickerViewZone,
                                      @"lattitudeOne":self.lattitudeOneTextField.text,
                                      @"longtittudeOne":self.longtittudeOneTextField.text,
                                      @"lattitudeTwo":self.lattitudeTwoTextField.text,
                                      @"longtittudeTwo":self.longtittudeTwoTextField.text};
    
    MFMessageComposeViewController *messageComposeViewController = [[TSPostingMessagesManager sharedManager] messageComposeViewController:recipients bodyMessage:[NSString setGpsCoordinateComand:dictionaryValue determinant:self.determinant]];
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
    [self.titleLabel setText:@"Programming GPS zones"];
    [self.lattitudeOneLabel setText:@"Lattitude1"];
    [self.loungtittudeOneLabel setText:@"Longtittude1"];
    [self.lattitudeTwoLabel setText:@"Lattitude2"];
    [self.loungtittudeTwoLabel setText:@"Longtittude2"];
    [self.lattitudeOneTextField setPlaceholder:@"Upper border"];
    [self.longtittudeOneTextField setPlaceholder:@"Left border"];
    [self.lattitudeTwoTextField setPlaceholder:@"Bottom border"];
    [self.longtittudeTwoTextField setPlaceholder:@"Right border"];
}


- (void)setGermanLaunguage
{
    [self.titleLabel setText:@"Programmierung der Sicherheitszonen GPS"];
    [self.lattitudeOneLabel setText:@"Breitengrad1"];
    [self.loungtittudeOneLabel setText:@"Längengrad1"];
    [self.lattitudeTwoLabel setText:@"Breitengrad2"];
    [self.loungtittudeTwoLabel setText:@"Längengrad2"];
    [self.lattitudeOneTextField setPlaceholder:@"obere Grenze"];
    [self.longtittudeOneTextField setPlaceholder:@"linke Grenze"];
    [self.lattitudeTwoTextField setPlaceholder:@"untere Grenze"];
    [self.longtittudeTwoTextField setPlaceholder:@"rechte Grenze"];
}



#pragma mark - UIAlertController


- (UIAlertController *)sharedAlertController:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                      preferredStyle:(UIAlertControllerStyleAlert)];
    
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


#pragma mark - Navigation



@end
