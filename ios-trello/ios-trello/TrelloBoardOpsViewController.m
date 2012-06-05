//
//  TrelloBoardOpsViewController.m
//  Trello Demo
//
//  Created by Vince Mansel on 4/19/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

/*
 *********
 
 This is an overloaded subclass of UITableViewController for demo/testing purposes.
 
 *********
 
 */

#import "TrelloBoardOpsViewController.h"
#import "VMTools.h"
#import "AFNetworking.h"

#import "VMTrelloApiClient.h"
#import "VMTrelloApiClient+Action.h"
#import "VMTrelloApiClient+Board.h"
#import "VMTrelloApiClient+Card.h"
#import "VMTrelloApiClient+List.h"

@interface TrelloBoardOpsViewController ()

@property (strong, nonatomic) NSString *boardID;
@property (strong, nonatomic) UIPopoverController *aPopoverController;
@property (strong, nonatomic) NSString *operation;

@end

@implementation TrelloBoardOpsViewController

@synthesize boardID = _boardID;
@synthesize aPopoverController = _aPopoverController;
@synthesize operation = _operation;

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath = %@", indexPath);
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    BOOL needAlert = NO;
    BOOL needCardAlert = NO;
    BOOL needListAlert = NO;
    
    // Re-using the same ViewController for all Storyboard Views to save time (Test Application only).
            
    switch (indexPath.row) {
        case 0:
            if (![self didPressTrelloLink]) {
                cell.detailTextLabel.text = Network_Touch_To_Connect;
            }
            // else Wait For Notification
            break;
            
        case 1:
            if ([cell.textLabel.text rangeOfString:@"Create Board"].location != NSNotFound) {
                [self didPressTrelloOperation:@"popoverWithTrelloCreate" ];
            }
            else if ([cell.textLabel.text rangeOfString:@"GET /1/actions"].location != NSNotFound) {
                [self didPressTrelloOperation:@"getActions" ];
            }
            else if ([cell.textLabel.text rangeOfString:@"GET /1/cards"].location != NSNotFound) {
                [self didPressTrelloOperation:@"getCards" ];
            }
            else if ([cell.textLabel.text rangeOfString:@"GET /1/lists"].location != NSNotFound) {
                [self didPressTrelloOperation:@"getLists" ];
            }
            
            break;
            
        case 2:
            if ([cell.textLabel.text rangeOfString:@"Select Board"].location != NSNotFound) {
                [self didPressTrelloOperation:@"pushWithTrelloSelect"];
            }
            else if ([cell.textLabel.text rangeOfString:@"GET /1/cards/"].location != NSNotFound) {
                [self didPressTrelloOperation:@"getCardsList" ];
            }
            else if ([cell.textLabel.text rangeOfString:@"POST /1/lists"].location != NSNotFound) {
                NSString *boardID = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloBoard"];
                if (boardID) [self didPressTrelloOperation:@"popoverWithTrelloCreateList" ];
                else needAlert = YES;
            }
            break;
            
        case 3:
            if ([cell.textLabel.text rangeOfString:@"PUT /1/cards"].location != NSNotFound) {
                NSString *cardID = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloCard"];
                if (cardID) [self didPressTrelloOperation:@"popoverWithTrelloEditCardDescription" ];
                else needCardAlert = YES;
            }
            else if ([cell.textLabel.text rangeOfString:@"POST /1/lists/[list_id]/cards"].location != NSNotFound) {
                NSString *listID = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloList"];
                if (listID) [self didPressTrelloOperation:@"popoverWithTrelloAddCard" ];
                else needListAlert = YES;
            }
            else if (self.boardID) [self didPressTrelloOperation:@"popoverWithTrelloEditDescription"]; else needAlert = YES;
            break;
            
        case 4:
            if ([cell.textLabel.text rangeOfString:@"POST /1/cards"].location != NSNotFound) {
                NSString *listID = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloList"];
                if (listID) [self didPressTrelloOperation:@"popoverWithTrelloCreateCard" ];
                else needListAlert = YES;
            }
            else if ([cell.textLabel.text rangeOfString:@"PUT /1/lists/[list_id]/name"].location != NSNotFound) {
                NSString *listID = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloList"];
                if (listID) [self didPressTrelloOperation:@"popoverWithTrelloListsName" ];
                else needListAlert = YES;
            }
            else if (self.boardID) [self didPressTrelloOperation:@"popoverWithTrelloAddList"]; else needAlert = YES;
            break;
            
        case 5:
            if ([cell.textLabel.text rangeOfString:@"DELETE /1/cards/[card_id]"].location != NSNotFound) {
                NSString *cardID = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloCard"];
                if (cardID) [self didPressTrelloOperation:@"deleteCards" ];
                else needCardAlert = YES;
            }
            else if (self.boardID) [self didPressTrelloOperation:@"pushWithTrelloSelectLists"]; else needAlert = YES;
            break;
            
        case 6:
            if (self.boardID) [self didPressTrelloOperation:@"pushWithTrelloSelectCards"]; else needAlert = YES;
            break;
            
        case 7:
            if (self.boardID) [self didPressTrelloOperation:@"pushWithTrelloSelectActions"]; else needAlert = YES;
            break;
            
        case 8:
            if (self.boardID) [self didPressTrelloOperation:@"popoverWithTrelloBoardsName"]; else needAlert = YES;
            break;
            
        default:
            break;
    }
    
    if (needAlert) [VMTools showAlert:@"Trello Board" withMessage:@"Create or select a Board!"];
    if (needListAlert) [VMTools showAlert:@"Trello List" withMessage:@"Go to Board, create/select a Board and a List!"];
    if (needCardAlert) [VMTools showAlert:@"Trello Card" withMessage:@"Go to Board, create/select a Board and a Card!"];
}

#pragma mark - Trello Board Handlers

- (BOOL)didPressTrelloLink {
    
    BOOL linked = YES;
    if (![[VMTrelloApiClient sharedSession] isLinked]) {
        if ([VMTools checkNetworkStatus]) {
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

- (void)didPressTrelloOperation:(NSString *)trelloOperation {
    
    if ([VMTools checkNetworkStatus]) {
        if (![[VMTrelloApiClient sharedSession] isLinked]) {
            [[[UIAlertView alloc] initWithTitle:Network_Account_Not_Linked message:Network_Authorization_Error_Please_login
                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];  
        }
        else {
            if ([trelloOperation isEqualToString:@"getActions"]) {
                [self getActionsOperation];
            }
            else if ([trelloOperation isEqualToString:@"getCards"]) {
                [self getCardsOperation];
            }
            else if ([trelloOperation isEqualToString:@"getCardsList"]) {
                [self getCardsListOperation];
            }
            else if ([trelloOperation isEqualToString:@"getLists"]) {
                [self getListsOperation];
            }
            else if ([trelloOperation isEqualToString:@"deleteCards"]) {
                [self deleteCardsOperation];
            }
            else {
                [self performSegueWithIdentifier:trelloOperation sender:self];
            }
        }
    }
}

- (void)getActionsOperation
{
    NSString *actionID = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloAction"];
    
    if (actionID) {
        [[VMTrelloApiClient sharedSession]
         get1Actions:actionID
         success:^(id JSON) {
             NSLog(@"get1Actions: JSON = %@", JSON);
             
             //NSString *response = [JSON valueForKey:@"type"]; // Does not assign value ??
             
             UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
             //cell.detailTextLabel.text = response;
             
             cell.detailTextLabel.text = [JSON valueForKey:@"type"];
         }];
    }
    else {
        [VMTools showAlert:@"Trello Action" withMessage:@"Go to Board, Create/Select a Board and an Action"];
    }
}

- (void)getCardsOperation
{
    NSString *cardID = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloCard"];
    
    if (cardID) {
        [[VMTrelloApiClient sharedSession]
         get1Cards:cardID
         success:^(id JSON) {
             NSLog(@"get1Cards: JSON = %@", JSON);
             
             NSString *response = [JSON valueForKey:@"name"];
             
             UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
             cell.detailTextLabel.text = response;
         }];
    }
    else {
        [VMTools showAlert:@"Trello Card" withMessage:@"Go to Board, Create/Select a Board and a Card"];
    }
}

- (void)getCardsListOperation
{
    NSString *cardID = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloCard"];
    
    if (cardID) {
        [[VMTrelloApiClient sharedSession]
         get1CardsList:cardID
         success:^(id JSON) {
             NSLog(@"get1CardsList: JSON = %@", JSON);
             
             NSString *response = [JSON valueForKey:@"name"];
             
             UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
             cell.detailTextLabel.text = response;
         }];
    }
    else {
        [VMTools showAlert:@"Trello Card" withMessage:@"Go to Board, Create/Select a Board and a Card"];
    }
}

- (void)getListsOperation
{
    NSString *listID = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloList"];
    
    if (listID) {
        [[VMTrelloApiClient sharedSession]
         get1Lists:listID
         success:^(id JSON) {
             NSLog(@"get1Lists: JSON = %@", JSON);
             
             NSString *response = [JSON valueForKey:@"name"];
             
             UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
             cell.detailTextLabel.text = response;
         }];
    }
    else {
        [VMTools showAlert:@"Trello List" withMessage:@"Go to Board, Create/Select a Board and a List"];
    }
}

- (void)deleteCardsOperation
{
    NSString *cardID = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloCard"];
    
    if (cardID) {
        [[VMTrelloApiClient sharedSession]
         delete1Cards:cardID
         success:^(id JSON) {
             NSLog(@"delete1Cards: JSON = %@", JSON);
             
             //NSString *response = [JSON valueForKey:@"name"];
             
             UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
             cell.detailTextLabel.text = [@"Last deleted: " stringByAppendingString:cardID];
         }];
    }
    else {
        [VMTools showAlert:@"Trello Cards" withMessage:@"Make sure a card is selected..."];
    }
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.operation = [segue identifier];

    if ([segue.identifier isEqualToString:@"popoverWithTrelloCreate"] || 
        [segue.identifier isEqualToString:@"popoverWithTrelloEditDescription"] ||
        [segue.identifier isEqualToString:@"popoverWithTrelloAddList"] ||
        [segue.identifier isEqualToString:@"popoverWithTrelloEditCardDescription"] ||
        [segue.identifier isEqualToString:@"popoverWithTrelloCreateCard"] ||
        [segue.identifier isEqualToString:@"popoverWithTrelloCreateList"] ||
        [segue.identifier isEqualToString:@"popoverWithTrelloAddCard"] ||
        [segue.identifier isEqualToString:@"popoverWithTrelloListsName"] ||
        [segue.identifier isEqualToString:@"popoverWithTrelloBoardsName"] ) {
         
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
            self.aPopoverController = popoverSegue.popoverController;
            [self.aPopoverController setPopoverContentSize:CGSizeMake(260, 180)];
        }
        
        NSString *text;
        if ([segue.identifier isEqualToString:@"popoverWithTrelloCreate"] ||
            [segue.identifier isEqualToString:@"popoverWithTrelloBoardsName"]) {
            text = @"Enter Board Name";
        }
        else if ([segue.identifier isEqualToString:@"popoverWithTrelloEditDescription"]) {
            text = @"Enter Description";
        }
        else if ([segue.identifier isEqualToString:@"popoverWithTrelloAddList"] ||
                 [segue.identifier isEqualToString:@"popoverWithTrelloCreateList"] ||
                 [segue.identifier isEqualToString:@"popoverWithTrelloListsName"]) {
            text = @"Enter List Name";
        }
        else if ([segue.identifier isEqualToString:@"popoverWithTrelloEditCardDescription"]) {
            text = @"Enter Description";
        }
        else if ([segue.identifier isEqualToString:@"popoverWithTrelloCreateCard"] ||
                 [segue.identifier isEqualToString:@"popoverWithTrelloAddCard"]) {
            text = @"Enter Card Name";
        }
        [[[segue destinationViewController] textEntryLabel] setText:text];
        
    }
    else if ([segue.identifier isEqualToString:@"pushWithTrelloSelect"]) {
        [[segue destinationViewController] setTitle:@"Trello - Select A Board"];
        [[segue destinationViewController] setOperation:self.operation];
    }
    else if ([segue.identifier isEqualToString:@"pushWithTrelloSelectLists"]) {
        [[segue destinationViewController] setTitle:@"Trello - Lists on Current Board"];
        [[segue destinationViewController] setBoardID:self.boardID];
        [[segue destinationViewController] setOperation:self.operation];
    }
    else if ([segue.identifier isEqualToString:@"pushWithTrelloSelectCards"]) {
        [[segue destinationViewController] setTitle:@"Trello - Cards on Current Board"];
        [[segue destinationViewController] setBoardID:self.boardID];
        [[segue destinationViewController] setOperation:self.operation];
    }
    else if ([segue.identifier isEqualToString:@"pushWithTrelloSelectActions"]) {
        
        [[segue destinationViewController] setTitle:@"Trello - Actions on Current Board"];
        [[segue destinationViewController] setBoardID:self.boardID];
        [[segue destinationViewController] setOperation:self.operation];
    }
    [[segue destinationViewController] setDelegate:self];
}

#pragma mark - TrelloBoardListViewControllerDelegate Methods

- (void)didSelectTrelloItemID:(NSString *)itemID name:(NSString *)name
{
    UITableViewCell *cell;
    
    if ([self.operation isEqualToString:@"pushWithTrelloSelect"]) {
        cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        self.boardID = itemID;
        [[NSUserDefaults standardUserDefaults] setObject:itemID forKey:@"trelloBoard"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([self.operation isEqualToString:@"pushWithTrelloSelectLists"]) {
        cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        [[NSUserDefaults standardUserDefaults] setObject:itemID forKey:@"trelloList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([self.operation isEqualToString:@"pushWithTrelloSelectCards"]) {
        cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        [[NSUserDefaults standardUserDefaults] setObject:itemID forKey:@"trelloCard"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([self.operation isEqualToString:@"pushWithTrelloSelectActions"]) {
        cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
        [[NSUserDefaults standardUserDefaults] setObject:itemID forKey:@"trelloAction"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    cell.detailTextLabel.text = name;
}

#pragma mark - TrelloDataEntryViewControllerDelegate Methods

- (void)didEnterText:(NSString *)text
{
    [self.aPopoverController dismissPopoverAnimated:YES];
    
    if ([self.operation isEqualToString:@"popoverWithTrelloCreate"]) {
        
        text = [@"[MyProject]" stringByAppendingString:text];
        
        [[VMTrelloApiClient sharedSession]
         post1Boards:text
         success:^(id JSON) {
             NSLog(@"post1Boards: JSON = %@", JSON);
             
             NSString *response = [JSON valueForKey:@"name"];
             self.boardID = [JSON valueForKey:@"id"];
             
             UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
             cell.detailTextLabel.text = [@"Last Created: " stringByAppendingString:response];
             
             cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
             cell.detailTextLabel.text = response;
         }];
    }
    else if ([self.operation isEqualToString:@"popoverWithTrelloEditDescription"]) {
        
        [[VMTrelloApiClient sharedSession]
         put1BoardsDesc:self.boardID
         desc:text
         success:^(id JSON) {
             NSLog(@"put1BoardsDesc: JSON = %@", JSON);
             
             NSString *response = [JSON valueForKey:@"desc"];
             
             UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
             cell.detailTextLabel.text = [@"Edit: " stringByAppendingString:response];
         }];
    }
    else if ([self.operation isEqualToString:@"popoverWithTrelloAddList"]) {
        
        [[VMTrelloApiClient sharedSession]
         post1BoardsLists:self.boardID
         list:text
         success:^(id JSON) {
             NSLog(@"post1BoardsLists: JSON = %@", JSON);
             
             NSString *response = [JSON valueForKey:@"name"];
             
             [[NSUserDefaults standardUserDefaults] setObject:[JSON valueForKey:@"id"] forKey:@"trelloList"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
             cell.detailTextLabel.text = [@"Last Added: " stringByAppendingString:response];
         }];
    }
    else if ([self.operation isEqualToString:@"popoverWithTrelloEditCardDescription"]) {
        
        NSString *cardID = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloCard"];

        [[VMTrelloApiClient sharedSession]
         put1CardsDesc:cardID
         desc:text
         success:^(id JSON) {
             NSLog(@"post1CardsDesc: JSON = %@", JSON);
             
             NSString *response = [JSON valueForKey:@"desc"];
             
             UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
             cell.detailTextLabel.text = [@"Edit: " stringByAppendingString:response];
         }];
    }
    else if ([self.operation isEqualToString:@"popoverWithTrelloCreateCard"]) {
        
        NSString *idList = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloList"];
        
        [[VMTrelloApiClient sharedSession]
         post1Cards:text
         idList:idList
         success:^(id JSON) {
             NSLog(@"post1Cards: JSON = %@", JSON);
             
             NSString *response = [JSON valueForKey:@"name"];
             [[NSUserDefaults standardUserDefaults] setObject:[JSON valueForKey:@"id"] forKey:@"trelloCard"];
             
             UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
             cell.detailTextLabel.text = [@"Last Added: " stringByAppendingString:response];
         }];
    }
    else if ([self.operation isEqualToString:@"popoverWithTrelloCreateList"]) {
        
        NSString *idBoard = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloBoard"];
        
        [[VMTrelloApiClient sharedSession]
         post1Lists:text
         idBoard:idBoard
         success:^(id JSON) {
             NSLog(@"post1Lists: JSON = %@", JSON);
             
             NSString *response = [JSON valueForKey:@"name"];
             [[NSUserDefaults standardUserDefaults] setObject:[JSON valueForKey:@"id"] forKey:@"trelloList"];
             
             UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
             cell.detailTextLabel.text = [@"Last Added: " stringByAppendingString:response];
         }];
    }
    else if ([self.operation isEqualToString:@"popoverWithTrelloAddCard"]) {
        
        NSString *list_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloList"];
        
        [[VMTrelloApiClient sharedSession]
         post1ListsCards:text
         list_id:list_id
         success:^(id JSON) {
             NSLog(@"post1ListsCards: JSON = %@", JSON);
             
             NSString *response = [JSON valueForKey:@"name"];
             [[NSUserDefaults standardUserDefaults] setObject:[JSON valueForKey:@"id"] forKey:@"trelloCard"];
             
             UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
             cell.detailTextLabel.text = [@"Last Added: " stringByAppendingString:response];
         }];
    }
    else if ([self.operation isEqualToString:@"popoverWithTrelloListsName"]) {
        
        NSString *list_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloList"];
        
        [[VMTrelloApiClient sharedSession]
         put1ListsName:text
         list_id:list_id
         success:^(id JSON) {
             NSLog(@"put1ListsName: JSON = %@", JSON);
             
             NSString *response = [JSON valueForKey:@"name"];
             [[NSUserDefaults standardUserDefaults] setObject:[JSON valueForKey:@"id"] forKey:@"trelloList"];
             
             UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
             cell.detailTextLabel.text = [@"Last Rename: " stringByAppendingString:response];
         }];
    }
    else if ([self.operation isEqualToString:@"popoverWithTrelloBoardsName"]) {
        
        NSString *board_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"trelloBoard"];
        
        [[VMTrelloApiClient sharedSession]
         put1BoardsName:text
         board_id:board_id
         success:^(id JSON) {
             NSLog(@"put1BoardsName: JSON = %@", JSON);
             
             NSString *response = [JSON valueForKey:@"name"];
             [[NSUserDefaults standardUserDefaults] setObject:[JSON valueForKey:@"id"] forKey:@"trelloBoard"];
             
             UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
             cell.detailTextLabel.text = [@"Last Rename: " stringByAppendingString:response];
         }];
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
   
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Trello
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if ([[VMTrelloApiClient sharedSession] isLinked]) {
        cell.detailTextLabel.text = Network_Linked;
    }
    else {
        cell.detailTextLabel.text = Network_Touch_To_Connect;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

@end

