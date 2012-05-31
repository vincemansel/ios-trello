//
//  VMTabBarController.m
//  ios-trello
//
//  Created by Vince Mansel on 5/30/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTabBarController.h"

@interface VMTabBarController ()

@end

@implementation VMTabBarController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//    } else {
//        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
//    }
    return YES;
}

@end
