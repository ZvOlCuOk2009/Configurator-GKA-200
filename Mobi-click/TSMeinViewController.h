//
//  TSMeinViewController.h
//  Mobi-click
//
//  Created by Mac on 07.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Messages/Messages.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <ContactsUI/ContactsUI.h>

@interface TSMeinViewController : UIViewController  <MFMessageComposeViewControllerDelegate, CNContactPickerDelegate>

@property (strong, nonatomic) CNContactPickerViewController *contactPicker;
@property (strong, nonatomic) UIImageView *titleImageView;

@property (strong, nonatomic) UIImage * clickImage;
@property (strong, nonatomic) UIImage * noclickImage;

@property (strong, nonatomic) NSArray *recipient;
@property (strong, nonatomic) NSMutableArray *commands;
@property (strong, nonatomic) NSUserDefaults *userDefaults;

@property (assign, nonatomic) NSInteger counter;
@property (assign, nonatomic) NSInteger counterComand;

@end
