//
//  TSSensorViewController.m
//  Mobi-click
//
//  Created by Mac on 07.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSSensorViewController.h"
#import "TSMeinViewController.h"
#import "TSPrefixHeader.pch"

NSString *const ValuesPickerViewNotification = @"ValuesPickerViewNotification";

@interface TSSensorViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *movePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *voicePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *vibraPickerView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moveLabel;
@property (weak, nonatomic) IBOutlet UILabel *voiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *vibraLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation TSSensorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self configureController];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLauguage];
    [self loadSettingsPickerView];
}


- (void)configureController
{
    
    self.dataSource = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
    
    self.movePickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.voicePickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.vibraPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [titleImageView setFrame:CGRectMake(0, 0, 250, 44)];
    self.navigationItem.titleView = titleImageView;
}


#pragma mark - Action


- (IBAction)actionSendButton:(id)sender
{
    
    NSString *valuePickerViewMove = [self pickerView:self.movePickerView
                           titleForRow:[self.movePickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewVoice = [self pickerView:self.voicePickerView
                              titleForRow:[self.voicePickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *valuePickerViewVibra = [self pickerView:self.vibraPickerView
                              titleForRow:[self.vibraPickerView selectedRowInComponent:0] forComponent:0];

    
    NSDictionary *valuesPickerView = @{@"valueMove":valuePickerViewMove,
                                       @"valueVoice":valuePickerViewVoice,
                                       @"valueVibra":valuePickerViewVibra};
    
    NSInteger movie = [valuePickerViewMove integerValue];
    NSInteger voice = [valuePickerViewVoice integerValue];
    NSInteger vibra = [valuePickerViewVibra integerValue];
    
    
    [self.userDefaults setInteger:movie forKey:@"valueMove"];
    [self.userDefaults setInteger:voice forKey:@"valueVoice"];
    [self.userDefaults setInteger:vibra forKey:@"valueVibra"];
    [self.userDefaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ValuesPickerViewNotification object:valuesPickerView];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (void)loadSettingsPickerView
{
    
    NSInteger valueMovePC = [self.userDefaults integerForKey:@"valueMove"] - 1;
    NSInteger valueVoicePC = [self.userDefaults integerForKey:@"valueVoice"] - 1;
    NSInteger valueVibraPC = [self.userDefaults integerForKey:@"valueVibra"] - 1;
    
    [self.movePickerView selectRow:valueMovePC inComponent:0 animated:NO];
    [self.voicePickerView selectRow:valueVoicePC inComponent:0 animated:NO];
    [self.vibraPickerView selectRow:valueVibraPC inComponent:0 animated:NO];
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
    return [self.dataSource objectAtIndex:row];
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
    [self.titleLabel setText:@"Sensors programming"];
    [self.moveLabel setText:@"Move"];
    [self.voiceLabel setText:@"Voice"];
    [self.vibraLabel setText:@"Vibra"];
    [self.sendButton setTitle:@"SEND" forState:UIControlStateNormal];
}


- (void)setGermanLaunguage
{
    [self.titleLabel setText:@"Programmierung der Sensoren"];
    [self.moveLabel setText:@"Bewegung"];
    [self.voiceLabel setText:@"Stimme"];
    [self.vibraLabel setText:@"Vibra"];
    [self.sendButton setTitle:@"SENDEN" forState:UIControlStateNormal];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
