//
//  TSPostingMessages.h
//  Mobi-click
//
//  Created by Mac on 10.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Messages/Messages.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface TSPostingMessagesManager : NSObject <MFMessageComposeViewControllerDelegate>

+ (TSPostingMessagesManager *)sharedManager;

- (MFMessageComposeViewController *)messageComposeViewController:(NSArray *)phoneNumberToСall bodyMessage:(NSString *)bodyMessage;

@end
