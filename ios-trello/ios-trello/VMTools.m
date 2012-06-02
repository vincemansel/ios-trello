//
//  VMTools.m
//  ios-trello
//
//  Created by Vince Mansel on 3/24/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTools.h"
#import "Reachability.h"

#define Network_Unavailable         @"Network Unavailable"
#define iosTrello_requires_an_internet_connection_to_access_online_resources \
@"ios-trello requires an internet connection to access online resources"

@implementation VMTools

+ (NSString *)trimString:(NSString *)inputString
{
    //StackOverflow: 8383034
    inputString = [inputString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([inputString length] == 0)
        inputString = nil;
    return inputString;
}

// IOS 5 Developer's Cookbook, 13
+ (void)showAlert:(NSString *)theTitle withMessage:(NSString *)theMessage
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:theTitle
                                             message:theMessage
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
    [av show];
}

+ (BOOL)checkNetworkStatus
{
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    BOOL status;
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Network_Unavailable
                                                        message:iosTrello_requires_an_internet_connection_to_access_online_resources
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        status = NO;
    }
    else {
        status = YES;
    }

    return status;
}

 
@end
