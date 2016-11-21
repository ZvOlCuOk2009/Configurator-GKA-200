//
//  NSString+TSString.h
//  Mobi-click
//
//  Created by Mac on 10.10.16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TSString)

+ (NSString *)sosComand:(NSArray *)numberPhones checkerPosirion:(NSArray *)checkers;
+ (NSString *)telComand:(NSString *)numberPhone checker:(BOOL)checker;
+ (NSString *)changeNameDiviceComand:(NSString *)newNameDevice;
+ (NSString *)setTimeComand:(NSDictionary *)dictionaryValue;
+ (NSString *)changePinComand:(NSString *)newPin;
+ (NSString *)changeLaunguageComand:(NSString *)newLaunguage;
+ (NSString *)setRingtonComand:(NSDictionary *)dictionaryValue;
+ (NSString *)setGpsCoordinateComand:(NSDictionary *)dictionaryValue determinant:(NSInteger)determinant;
+ (NSString *)resetSettingsComand;

@end
