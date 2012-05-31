//
//  DPLogisticsConnectTVC.m
//  Trello Demo
//
//  Created by Vince Mansel on 4/19/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "DPLogisticsConnectTVC.h"
#import "DPTools.h"
#import "AFNetworking.h"
#import "VMTrelloApiClient.h"

@interface DPLogisticsConnectTVC ()

@end

@implementation DPLogisticsConnectTVC

- (void)handleTrelloLinkNotificationSuccess
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    cell.detailTextLabel.text = Network_Linked;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TRELLO_LINK_NOTIFICATION_SUCCESS object:[VMTrelloApiClient sharedSession]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TRELLO_LINK_NOTIFICATION_FAILURE object:[VMTrelloApiClient sharedSession]];
}

- (void)handleTrelloLinkNotificationFailure
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    cell.detailTextLabel.text = Network_Touch_To_Connect;
    [[[UIAlertView alloc] initWithTitle:Network_Account_Not_Linked message:Your_attempt_to_link_your_Trello_account_ended_unsuccessfully 
                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TRELLO_LINK_NOTIFICATION_SUCCESS object:[VMTrelloApiClient sharedSession]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TRELLO_LINK_NOTIFICATION_FAILURE object:[VMTrelloApiClient sharedSession]];
}

- (BOOL)didPressTrelloLink {
    
    BOOL linked = YES;
    if (![[VMTrelloApiClient sharedSession] isLinked]) {
        if ([DPTools checkNetworkStatus]) {
            [[VMTrelloApiClient sharedSession] link];
            // Wait for Notification
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleTrelloLinkNotificationSuccess)
                                                         name:TRELLO_LINK_NOTIFICATION_SUCCESS object:[VMTrelloApiClient sharedSession]];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleTrelloLinkNotificationFailure)
                                                         name:TRELLO_LINK_NOTIFICATION_FAILURE object:[VMTrelloApiClient sharedSession]];  
        }
    }
    else {
        [[VMTrelloApiClient sharedSession] unLinkAll];
        linked = NO;
        
        [[[UIAlertView alloc] initWithTitle:Network_Account_Unlinked message:Your_Trello_account_has_been_unlinked
                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    return linked;
}

- (void)didPressTrelloCreateBoard {
    
    if ([DPTools checkNetworkStatus]) {
        if (![[VMTrelloApiClient sharedSession] isLinked]) {
            [[[UIAlertView alloc] initWithTitle:Network_Account_Not_Linked message:Network_Authorization_Error_Please_login
                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];  
        }
        else {
            // [self performSegueWithIdentifier:@"pushWithTrelloCreate" sender:self];
        }
    }
    
}

- (void)didPressTrelloSelectBoard {
    
    if ([DPTools checkNetworkStatus]) {
        if (![[VMTrelloApiClient sharedSession] isLinked]) {
            [[[UIAlertView alloc] initWithTitle:Network_Account_Not_Linked message:Network_Authorization_Error_Please_login
                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];  
        }
        else {
            [self performSegueWithIdentifier:@"pushWithTrelloSelect" sender:self];
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath = %@", indexPath);
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:@"Trello"]) {
        
        switch (indexPath.row) {
            case 0:
                if (![self didPressTrelloLink]) {
                    cell.detailTextLabel.text = Network_Touch_To_Connect;
                }
                // else Wait For Notification
                break;
                
            case 1:
                [self didPressTrelloCreateBoard];
                break;
                
            case 2:
                [self didPressTrelloSelectBoard];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushWithTrelloSelect"]) {
        [[segue destinationViewController] setTitle:@"Trello - Select A Board"];
    }
}


#pragma mark - Table view data source


#pragma mark - Lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Trello
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if ([[VMTrelloApiClient sharedSession] isLinked]) {
        cell.detailTextLabel.text = Network_Linked;
    }
    else {
        cell.detailTextLabel.text = Network_Touch_To_Connect;
    }

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}



@end

