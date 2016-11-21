//
//  TSPostingMessages.m
//  Mobi-click
//
//  Created by Mac on 10.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TSPostingMessagesManager.h"

@implementation TSPostingMessagesManager

+ (TSPostingMessagesManager *)sharedManager
{
    static TSPostingMessagesManager *manger = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[TSPostingMessagesManager alloc] init];
    });
    return manger;
}


- (MFMessageComposeViewController *)messageComposeViewController:(NSArray *)phoneNumberToСall bodyMessage:(NSString *)bodyMessage
{
    MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    [messageComposeViewController setRecipients:phoneNumberToСall];
    [messageComposeViewController setBody:bodyMessage];
    
    return messageComposeViewController;
}


#pragma mark - MFMessageComposeViewControllerDelegate


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                didFinishWithResult:(MessageComposeResult)result
{
    
}


@end
