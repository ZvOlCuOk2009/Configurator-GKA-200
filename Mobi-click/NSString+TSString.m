//
//  NSString+TSString.m
//  Mobi-click
//
//  Created by Mac on 10.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "NSString+TSString.h"
#import "TSPrefixHeader.pch"

static NSString *pin;

@implementation NSString (TSString)

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        pin = [userDefaults objectForKey:@"pin"];
    }
    return self;
}

+ (NSString *)sosComand:(NSArray *)numberPhones checkerPosirion:(NSArray *)checker
{
    
    NSMutableString *sosComand = [NSMutableString stringWithFormat:@"Set TEL1 "];
    NSString *sharp = @"#";
    
    NSString *numberOne = [numberPhones objectAtIndex:0];
    NSString *numberTwo = [numberPhones objectAtIndex:1];
    NSString *numberThree = [numberPhones objectAtIndex:2];
    NSString *numberFore = [numberPhones objectAtIndex:3];
    NSString *numberFive = [numberPhones objectAtIndex:4];
    NSString *numberSix = [numberPhones objectAtIndex:5];
    
    
    NSString *checkerOne = [checker objectAtIndex:0];
    NSString *checkerTwo = [checker objectAtIndex:1];
    NSString *checkerThree = [checker objectAtIndex:2];
    NSString *checkerFore = [checker objectAtIndex:3];
    NSString *checkerFive = [checker objectAtIndex:4];
    NSString *checkerSix = [checker objectAtIndex:5];
    
    
    if ([numberOne length] > 1) {
        NSString *partComand1 = [NSString stringWithFormat:@"%@ %@ ", checkerOne, numberOne];
        [sosComand appendString:partComand1];
    }
    
    if ([numberTwo length] > 1) {
        NSString *partComand2 = [NSString stringWithFormat:@"%@ %@ ", checkerTwo, numberTwo];
        [sosComand appendString:partComand2];
    }
    
    if ([numberThree length] > 1) {
        NSString *partComand3 = [NSString stringWithFormat:@"%@ %@ ", checkerThree, numberThree];
        [sosComand appendString:partComand3];
    }
    
    if ([numberFore length] > 1) {
        NSString *partComand4 = [NSString stringWithFormat:@"%@ %@ ", checkerFore, numberFore];
        [sosComand appendString:partComand4];
    }
    
    if ([numberFive length] > 1) {
        NSString *partComand5 = [NSString stringWithFormat:@"%@ %@ ", checkerFive, numberFive];
        [sosComand appendString:partComand5];
    }
    
    if ([numberSix length] > 1) {
        NSString *partComand6 = [NSString stringWithFormat:@"%@ %@ ", checkerSix, numberSix];
        [sosComand appendString:partComand6];
    }
    
    [sosComand appendString:sharp];
    [sosComand appendString:pin];
    
    
    return sosComand;
    
}


+ (NSString *)telComand:(NSString *)numberPhone checker:(BOOL)checker
{
    NSString *checkerIsOn = nil;
    
    if (checker == YES) {
        checkerIsOn = @"S";
    } else if (checker == NO) {
        checkerIsOn = @"C";
    }
    
    return [NSString stringWithFormat:@"Set TEL %@ %@ %@#", checkerIsOn, numberPhone, pin];
}


+ (NSString *)changeNameDiviceComand:(NSString *)newNameDevice
{
    return [NSString stringWithFormat:@"SET NAME %@ #%@", newNameDevice, pin];
}


+ (NSString *)setTimeComand:(NSDictionary *)dictionaryValue
{
    NSString *hours = [dictionaryValue objectForKey:@"hours"];
    NSString *minutes = [dictionaryValue objectForKey:@"minutes"];
    NSString *days = [dictionaryValue objectForKey:@"days"];
    NSString *months = [dictionaryValue objectForKey:@"months"];
    NSString *years = [dictionaryValue objectForKey:@"years"];
    NSString *zone = [dictionaryValue objectForKey:@"zoneTD"];
    
    return [NSString stringWithFormat:@"SET TIME %@ %@ %@ %@ %@ %@ #%@", hours, minutes, days, months, years, zone, pin];
}


+ (NSString *)changePinComand:(NSString *)newPin
{
    return [NSString stringWithFormat:@"SET PIN %@ #%@", newPin, pin];
}


+ (NSString *)changeLaunguageComand:(NSString *)newLaunguage
{
    return [NSString stringWithFormat:@"SET LANGUAGE %@ #%@", newLaunguage, pin];
}


+ (NSString *)setRingtonComand:(NSDictionary *)dictionaryValue
{
    
    NSString *speaker = [dictionaryValue objectForKey:@"speaker"];
    NSString *microphone = [dictionaryValue objectForKey:@"microphone"];
    NSString *ringtone = [dictionaryValue objectForKey:@"ringtone"];
    NSString *determinant = [dictionaryValue objectForKey:@"determinant"];
    
    NSString *selectRington = nil;
    
    if ([determinant isEqualToString:@"0"]) {
        selectRington = @"0";
    }
    else {
        selectRington = @"1";
    }

    
    return [NSString stringWithFormat:@"SET AUDIO %@ %@ %@ %@ %@ #%@", speaker, microphone, determinant, ringtone, selectRington, pin];
}


+ (NSString *)setGpsCoordinateComand:(NSDictionary *)dictionaryValue determinant:(NSInteger)determinant
{
    NSString *command = nil;
    NSString *zonePV = [dictionaryValue objectForKey:@"zone"];
    
    if (determinant == 1) {
        
        NSString *nsOnePV = [dictionaryValue objectForKey:@"nsOne"];
        NSString *ewOnePV = [dictionaryValue objectForKey:@"ewOne"];
        NSString *nsTwoPV = [dictionaryValue objectForKey:@"nsTwo"];
        NSString *ewTwoPV = [dictionaryValue objectForKey:@"ewTwo"];
        NSString *lattitudeOneTF = [dictionaryValue objectForKey:@"lattitudeOne"];
        NSString *longtittudeOneTF = [dictionaryValue objectForKey:@"longtittudeOne"];
        NSString *lattitudeTwoTF = [dictionaryValue objectForKey:@"lattitudeTwo"];
        NSString *longtittudeTwoTF = [dictionaryValue objectForKey:@"longtittudeTwo"];
        
        command = [NSString stringWithFormat:@"SET %@%@ %@%@ %@%@ %@%@ #%@", lattitudeOneTF, nsOnePV, longtittudeOneTF, ewOnePV, lattitudeTwoTF, nsTwoPV, longtittudeTwoTF, ewTwoPV, pin];
        
    } else if (determinant == 2) {
        
        command = [NSString stringWithFormat:@"RESET GPSZONE %@ #%@", zonePV, pin];
        
    } else if (determinant == 3) {
        
        command = [NSString stringWithFormat:@"TEST GPSZONE %@ #%@", zonePV, pin];
        
    }
    
    return command;
}


+ (NSString *)resetSettingsComand
{
    return [NSString stringWithFormat:@"RESET SETUP 12345678 #%@", pin];
}


@end
