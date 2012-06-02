//
//  TrelloDataEntryViewController.m
//  ios-trello
//
//  Created by Vince Mansel on 5/31/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "TrelloDataEntryViewController.h"

@interface TrelloDataEntryViewController ()

@end

@implementation TrelloDataEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
