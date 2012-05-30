//
//  VMFirstViewController.m
//  ios-trello
//
//  Created by Vince Mansel on 5/30/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMFirstViewController.h"

@interface VMFirstViewController ()

@end

@implementation VMFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
