//
//  TrelloBoardListViewController.m
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "TrelloBoardListViewController.h"
#import "TrelloLoginViewController.h"

#import "AFNetworking.h"
#import "ymacros.h"

#import "TrelloClientCredentials.h"
#import "TrelloDefines.h"
#import "VMTrelloApiClient.h"
#import "VMTrelloApiClient+Board.h"
#import "VMTrelloApiClient+Member.h"

@interface TrelloBoardListViewController()
{
    UIPopoverController *loginPopoverController;
}

@property (strong,nonatomic) NSMutableArray *itemIDs;

@end;

@implementation TrelloBoardListViewController
+ (NSString *)description {
    //return @"Trello OAuth 1.0";
    return @"Trello Account";
}

@synthesize delegate = _delegate;
@synthesize operation = _operation;
@synthesize boardID = _boardID;
@synthesize itemIDs = _itemIDs;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    _itemIDs = [[NSMutableArray alloc] initWithCapacity:20];
}

#pragma mark - network

- (void)parseJSONforProjectItems:(id)JSON // Can be used for boards, lists or cards.
{
    NSLog(@"Name: %@", [JSON valueForKeyPath:@"name"]);
    //NSLog(@"Name: %@ %@", [JSON valueForKeyPath:@"name"], [JSON valueForKeyPath:@"memberships"]);
    //NSLog(@"JSON: %@", JSON);
    if (YIS_INSTANCE_OF(JSON, NSArray)) {
        [self.messages removeAllObjects];
        for (id item in JSON) {
            if (YIS_INSTANCE_OF(item, NSDictionary)) {
                NSString * itemName = [item objectForKey:@"name"];
                if (YIS_INSTANCE_OF(itemName, NSString)) {
                    if ( itemName ) {
                        [self.messages addObject:itemName];
                        [self.itemIDs addObject:[item objectForKey:@"id"]];
                        NSLog(@"Item Name: %@, id = %@", itemName, [self.itemIDs lastObject]);
                    }
                }
            }
        }
    }
}

- (void)parseJSONforProjectActions:(id)JSON // Can be used for boards, lists or cards.
{
    NSLog(@"type: %@", [JSON valueForKeyPath:@"type"]);;    NSLog(@"JSON: %@", JSON);
    if (YIS_INSTANCE_OF(JSON, NSArray)) {
        [self.messages removeAllObjects];
        for (id item in JSON) {
            if (YIS_INSTANCE_OF(item, NSDictionary)) {
                NSString * itemName = [item objectForKey:@"type"];
                if (YIS_INSTANCE_OF(itemName, NSString)) {
                    if ( itemName ) {
                        [self.messages addObject:itemName];
                        [self.itemIDs addObject:[item objectForKey:@"id"]];
                        NSLog(@"Item Name: %@, id = %@", itemName, [self.itemIDs lastObject]);
                    }
                }
            }
        }
    }
}


- (void)loadFeedStream {
    if (self.accesstoken && self.tokensecret) {
        
        void (^failureBlock)(NSError *error) = ^(NSError *error) {
            [VMTrelloApiClient operationDidFailWithError:error title:@"Trello" message:Network_Error_Occured_Please_attempt_again]; 
            NSLog(@"Authorization Error: %@", error.description);
        };
    
        if ([self.operation isEqualToString:@"pushWithTrelloSelect"]) {
            [[VMTrelloApiClient sharedSession]
             getMemberMyBoardsWithSuccess:^(id JSON) {
                 [self parseJSONforProjectItems:JSON];
                 [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
             }
             failure:failureBlock];
        }
        else if ([self.operation isEqualToString:@"pushWithTrelloSelectLists"]) {
            [[VMTrelloApiClient sharedSession]
             get1BoardsLists:self.boardID
             success:^(id JSON) {
                 [self parseJSONforProjectItems:JSON];
                 [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
             }
             failure:failureBlock];
        }
        else if ([self.operation isEqualToString:@"pushWithTrelloSelectCards"]) {
            [[VMTrelloApiClient sharedSession]
             get1BoardsCards:self.boardID
             success:^(id JSON) {
                 [self parseJSONforProjectItems:JSON];
                 [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
             }
             failure:failureBlock];
        }
        else if ([self.operation isEqualToString:@"pushWithTrelloSelectActions"]) {
            [[VMTrelloApiClient sharedSession]
             get1BoardsActions:self.boardID
             success:^(id JSON) {
                 [self parseJSONforProjectActions:JSON];
                 [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
             }
             failure:failureBlock];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [self.messages objectAtIndex:indexPath.row];
    
    NSString *itemID = [self.itemIDs objectAtIndex:indexPath.row];
    NSLog(@"Item Selected = %@", name);
    
    /*
    [[VMTrelloApiClient sharedSession] 
     get1Boards:itemID
     field:@"name"
     success:^(id JSON) {
         NSLog(@"Board:JSON = %@", JSON);
     } failure:^(NSError *error) {
         NSLog(@"Board JSON Error: %@", error.description);
     }];
    */
    
    //if ([self.delegate respondsToSelector:@selector(didSelectTrelloBoardID:name:)]) {
    if ([self.delegate conformsToProtocol:@protocol(TrelloBoardListViewControllerDelegate)]) {
        [self.delegate didSelectTrelloItemID:itemID name:name];
    }
}

#pragma mark - properties

#define ACCESSTOKEN_KEY @"trelloaccesstoken"
#define TOKENSECRET_KEY  @"trellotokensecret"

- (void)setAccesstoken:(NSString *)accesstoken {
    [super setAccesstoken:accesstoken];
    if ([super accesstoken]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.accesstoken forKey:ACCESSTOKEN_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)accesstoken {
    
    NSString * token = [super accesstoken];
    if (nil == token) {
        token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESSTOKEN_KEY];
        self.accesstoken = token;
    }
    return token;
}


- (void)setTokensecret:(NSString *)tokensecret
{
    [super setTokensecret:tokensecret];
    if ([super tokensecret]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.tokensecret forKey:TOKENSECRET_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)tokensecret {
    
    NSString * token = [super tokensecret];
    if (nil == token) {
        token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKENSECRET_KEY];
        self.tokensecret = token;
    }
    return token;
}

@end
