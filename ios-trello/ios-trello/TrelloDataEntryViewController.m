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

@synthesize delegate = _delegate;

@synthesize textEntryLabel;
@synthesize textField;

- (IBAction)okButtonPressed:(id)sender {
    
    if ([textField.text length] > 0) {
        NSString *text = textField.text;
        [self.delegate didEnterText:text];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTextEntryLabel:nil];
    [self setTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
