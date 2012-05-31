//
//  TrelloBoardListViewController.m
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "TrelloBoardListViewController.h"
#import "TrelloLoginViewController.h"

#import "ymacros.h"
#import "TrelloClientCredentials.h"
#import "TrelloDefines.h"

#import "AFNetworking.h"
#import "VMTrelloApiClient.h"
#import "VMTrelloApiClient+Board.h"
#import "VMTrelloApiClient+Member.h"

@interface TrelloBoardListViewController()
{
    UIPopoverController *loginPopoverController;
}

@property (strong,nonatomic) NSMutableArray *boardIDs;

@end;

@implementation TrelloBoardListViewController
+ (NSString *)description {
    //return @"Trello OAuth 1.0";
    return @"Trello Account";
}

@synthesize boardIDs = _boardIDs;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    _boardIDs = [[NSMutableArray alloc] initWithCapacity:20];
}

#pragma mark - network

- (void)parseJSONforShowPlanBoards:(id)JSON
{
    NSLog(@"Name: %@ %@", [JSON valueForKeyPath:@"name"], [JSON valueForKeyPath:@"memberships"]);
    NSLog(@"JSON: %@", JSON);
    if (YIS_INSTANCE_OF(JSON, NSArray)) {
        [self.messages removeAllObjects];
        for (id item in JSON) {
            if (YIS_INSTANCE_OF(item, NSDictionary)) {
                NSString * boardName = [item objectForKey:@"name"];
                if (YIS_INSTANCE_OF(boardName, NSString)) {
                    if ( boardName ) {
                        [self.messages addObject:boardName];
                        [self.boardIDs addObject:[item objectForKey:@"id"]];
                        NSLog(@"boardName: %@, id = %@", boardName, [self.boardIDs lastObject]);
                    }
                }
            }
        }
    }
}

- (void)loadFeedStream {
    if (self.accesstoken && self.tokensecret) {
    
        [[VMTrelloApiClient sharedSession] getMemberMyBoardsWithSuccess:^(id JSON) {
             [self parseJSONforShowPlanBoards:JSON];
             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
         }
         failure:^(NSError *error) {
             [VMTrelloApiClient operationDidFailWithError:error title:@"Trello" message:Network_Authorization_Error_Please_login]; 
             NSLog(@"Authorization Error: %@", error.description);
         }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Board = %@", [self.messages objectAtIndex:indexPath.row]);
    
    [[VMTrelloApiClient sharedSession] 
     getBoards:[self.boardIDs objectAtIndex:indexPath.row]
     field:@"name"
     success:^(id JSON) {
         NSLog(@"Board:JSON = %@", JSON);
     } failure:^(NSError *error) {
         NSLog(@"Board JSON Error: %@", error.description);
     }];
    
    [[VMTrelloApiClient sharedSession] 
     getBoardCards:[self.boardIDs objectAtIndex:indexPath.row]
     success:^(id JSON) {
         NSLog(@"BoardCards:JSON = %@", JSON);
     } failure:^(NSError *error) {
         NSLog(@"BoardCards JSON Error: %@", error.description);
     }];
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
