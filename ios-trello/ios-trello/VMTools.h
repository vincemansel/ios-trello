//
//  VMTools.h
//  ios-trello
//
//  Created by Vince Mansel on 3/24/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMTools : NSObject

+ (NSString *)trimString:(NSString *)inputString;
+ (void)showAlert:(NSString *)theTitle withMessage:(NSString *)theMessage;
+ (BOOL)checkNetworkStatus;

@end
