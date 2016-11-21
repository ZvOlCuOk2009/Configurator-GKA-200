//
//  TSAudioViewController.m
//  Mobi-click
//
//  Created by Mac on 07.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSAudioViewController.h"
#import "TSPostingMessagesManager.h"
#import "NSString+TSString.h"
#import "TSPrefixHeader.pch"

@interface TSAudioViewController () <MFMessageComposeViewControllerDelegate, CNContactPickerDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *loudspeackerPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *microphonePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *ringtonesPickerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *checkerButtonsOutletCollection;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameRingtonLabelOutletColletion;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *microphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *signalVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ringonLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) NSMutableArray *dataSourceSpeakerVolume;
@property (strong, nonatomic) NSMutableArray *dataSourceMicrophone;
@property (strong, nonatomic) NSMutableArray *dataSourceSignalVolume;
@property (strong, nonatomic) NSArray *namesRingtons;

@property (strong, nonatomic) NSDictionary *valuesDictionary;

@property (strong, nonatomic) NSString *valuePickerViewLoudspeacker;
@property (strong, nonatomic) NSString *valuePickerViewMicrophone;
@property (strong, nonatomic) NSString *valuePickerViewRingtones;

@property (assign, nonatomic) NSInteger determinantPressedButton;

@end

@implementation TSAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self configureContrioller];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLaunguage];
    [self loadSettingsPickerView];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        if (IS_IPHONE_4) {
            [self.scrollView setContentSize:CGSizeMake(320, 667)];
            self.scrollView.frame = CGRectMake(0, 64, 320, 410);
        } else if (IS_IPHONE_5) {
            [self.scrollView setContentSize:CGSizeMake(320, 667)];
            self.scrollView.frame = CGRectMake(0, 64, 320, 524);
        } else if (IS_IPHONE_6) {
            [self.scrollView setContentSize:CGSizeMake(320, 667)];
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


#pragma mark - load picker view position


- (void)loadSettingsPickerView
{
    
    NSInteger valueLoudspeackerlPC = [self.userDefaults integerForKey:@"valueLoudspeacker"];
    NSInteger valueMicrophonePC = [self.userDefaults integerForKey:@"valueMicrophone"];
    NSInteger valueRingtonesPC = [self.userDefaults integerForKey:@"valueRingtones"];
    
    [self.loudspeackerPickerView selectRow:valueLoudspeackerlPC inComponent:0 animated:NO];
    [self.microphonePickerView selectRow:valueMicrophonePC inComponent:0 animated:NO];
    [self.ringtonesPickerView selectRow:valueRingtonesPC  inComponent:0 animated:NO];
    
}


#pragma mark - Configure contrioller


- (void)configureContrioller
{
    self.loudspeackerPickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.microphonePickerView.layer.borderColor = [BLUE_COLOR CGColor];
    self.ringtonesPickerView.layer.borderColor = [BLUE_COLOR CGColor];

    
    for (int i = 0; i < self.checkerButtonsOutletCollection.count; i++) {
        UIButton *checkerButton = [self.checkerButtonsOutletCollection objectAtIndex:i];
        checkerButton.layer.borderColor = [BLUE_COLOR CGColor];
        checkerButton.tag = i;
    }
    
    self.dataSourceSpeakerVolume = [NSMutableArray array];
    self.dataSourceMicrophone = [NSMutableArray array];
    self.dataSourceSignalVolume = [NSMutableArray array];
    
    
    for (int i = 0; i < 10; i++)
    {
        NSString *intervalString = [NSString stringWithFormat:@"%d", i];
        [self.dataSourceSpeakerVolume addObject:intervalString];
        [self.dataSourceMicrophone addObject:intervalString];
        [self.dataSourceSignalVolume addObject:intervalString];
    }
    
    self.clickImage = [UIImage imageNamed:@"click"];
    self.noclickImage = [UIImage imageNamed:@"noclick"];
    
    self.determinantPressedButton = 0;
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
            return self.dataSourceSpeakerVolume.count;
            break;
        case 2:
            return self.dataSourceMicrophone.count;
            break;
        case 3:
            return self.dataSourceSignalVolume.count;
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
            return [self.dataSourceSpeakerVolume objectAtIndex:row];
            break;
        case 2:
            return [self.dataSourceMicrophone objectAtIndex:row];
            break;
        case 3:
            return [self.dataSourceSignalVolume objectAtIndex:row];
            break;
        default:
            return 0;
            break;
    }
}


#pragma mark - save picker view position


- (void)savePickerViewPositionCommand
{
    
    NSInteger loudspeacker = [self.valuePickerViewLoudspeacker integerValue];
    NSInteger microphone = [self.valuePickerViewMicrophone integerValue];
    NSInteger ringtones = [self.valuePickerViewRingtones integerValue];
    
    [self.userDefaults setInteger:loudspeacker forKey:@"valueLoudspeacker"];
    [self.userDefaults setInteger:microphone forKey:@"valueMicrophone"];
    [self.userDefaults setInteger:ringtones forKey:@"valueRingtones"];
    [self.userDefaults synchronize];
    
}


#pragma mark - Actions


- (IBAction)actionSendButton:(id)sender
{
    self.contactPicker = [[CNContactPickerViewController alloc] init];
    self.contactPicker.delegate = self;
    
    [self presentViewController:self.contactPicker animated:YES completion:nil];
    
}


- (IBAction)actionCheckerButton:(UIButton *)sender
{
    
    self.determinantPressedButton = sender.tag;
    
    for (UIButton *button in self.checkerButtonsOutletCollection) {
        if (button.tag == sender.tag) {
            [button setImage:self.clickImage forState:UIControlStateNormal];
        } else {
            [button setImage:self.noclickImage forState:UIControlStateNormal];
        }
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

    self.valuePickerViewLoudspeacker = [self pickerView:self.loudspeackerPickerView
                                                 titleForRow:[self.loudspeackerPickerView selectedRowInComponent:0] forComponent:0];
    
    self.valuePickerViewMicrophone = [self pickerView:self.microphonePickerView
                                               titleForRow:[self.microphonePickerView selectedRowInComponent:0] forComponent:0];
    
    self.valuePickerViewRingtones = [self pickerView:self.ringtonesPickerView
                                              titleForRow:[self.ringtonesPickerView selectedRowInComponent:0] forComponent:0];
    
    NSString *determinantPressedButton = [NSString stringWithFormat:@"%ld", (long)self.determinantPressedButton];
    
    NSDictionary *dictionaryValue = @{@"speaker":self.valuePickerViewLoudspeacker,
                                      @"microphone":self.valuePickerViewMicrophone,
                                      @"ringtone":self.valuePickerViewRingtones,
                                      @"determinant":determinantPressedButton};
    
    MFMessageComposeViewController *messageComposeViewController = [[TSPostingMessagesManager sharedManager] messageComposeViewController:recipients bodyMessage:[NSString setRingtonComand:dictionaryValue]];
    messageComposeViewController.messageComposeDelegate = self;
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self presentViewController:messageComposeViewController animated:YES completion:nil];
    [self savePickerViewPositionCommand];
    
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
    NSString *language = [self.userDefaults objectForKey:@"language"];
    
    if ([language isEqualToString:@"English"]) {
        
        self.namesRingtons = @[@"Mystery", @"German national anthem", @"Mozart", @"Strauss", @"Puccini", @"Vici", @"Quick buzzing", @"Compact sound (Standart)", @"Short buzz", @"Long buzz"];
        
        for (int i = 0; i < self.namesRingtons.count; i++) {
            UILabel *label = [self.nameRingtonLabelOutletColletion objectAtIndex:i];
            NSString *text = [self.namesRingtons objectAtIndex:i];
            [label setText:text];
        }
        
        [self setEngleshLaunguage];
        
    } else if ([language isEqualToString:@"German"]) {
        
        self.namesRingtons = @[@"Mystery", @"Deutsche Nationalhymne", @"Mozart", @"Strauss", @"Puccini", @"Vici", @"schneller/kurze Signalfolge", @"Compact Rufton (Standard)", @"kurze Signalfolge", @"langgezogens Signal"];
        
        for (int i = 0; i < self.namesRingtons.count; i++) {
            UILabel *label = [self.nameRingtonLabelOutletColletion objectAtIndex:i];
            NSString *text = [self.namesRingtons objectAtIndex:i];
            [label setText:text];
        }
        
        [self setGermanLaunguage];
    }
}


- (void)setEngleshLaunguage
{
    [self.titleLabel setText:@"Audio volume control and ringing"];
    [self.speakerVolumeLabel setText:@"Speaker volume"];
    [self.microphoneLabel setText:@"Microphone sensitivity"];
    [self.signalVolumeLabel setText:@"Call signal volume"];
    [self.ringonLabel setText:@"Ringtones"];
    [self.sendButton setTitle:@"SEND" forState:UIControlStateNormal];
}


- (void)setGermanLaunguage
{
    [self.titleLabel setText:@"Audio Lautstärkeregler und Ruftone"];
    [self.speakerVolumeLabel setText:@"Lautsprecher-Lautstärke"];
    [self.microphoneLabel setText:@"Mikrofon-Lautstärke"];
    [self.signalVolumeLabel setText:@"Rufton-Lautstärke"];
    [self.ringonLabel setText:@"Ruftone"];
    [self.sendButton setTitle:@"SENDEN" forState:UIControlStateNormal];
}



@end
