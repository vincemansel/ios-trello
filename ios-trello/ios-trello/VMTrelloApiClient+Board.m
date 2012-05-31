//
//  VMTrelloApiClient+Board.m
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient+Board.h"

/*
 board
 
 GET /1/boards/[board_id]                                                       getBoards
 GET /1/boards/[board_id]/[field]
 GET /1/boards/[board_id]/actions
 GET /1/boards/[board_id]/cards                                                 getBoardCards
 GET /1/boards/[board_id]/cards/[filter]
 GET /1/boards/[board_id]/cards/[idCard]
 GET /1/boards/[board_id]/checklists
 GET /1/boards/[board_id]/lists
 GET /1/boards/[board_id]/lists/[filter]
 GET /1/boards/[board_id]/members
 GET /1/boards/[board_id]/members/[filter]
 GET /1/boards/[board_id]/membersInvited
 GET /1/boards/[board_id]/membersInvited/[field]
 GET /1/boards/[board_id]/myPrefs
 GET /1/boards/[board_id]/organization
 GET /1/boards/[board_id]/organization/[field]
 PUT /1/boards/[board_id]
 PUT /1/boards/[board_id]/closed
 PUT /1/boards/[board_id]/desc
 PUT /1/boards/[board_id]/name
 PUT /1/boards/[board_id]/prefs/comments
 PUT /1/boards/[board_id]/prefs/invitations
 PUT /1/boards/[board_id]/prefs/permissionLevel
 PUT /1/boards/[board_id]/prefs/selfJoin
 PUT /1/boards/[board_id]/prefs/voting
 POST /1/boards
 POST /1/boards/[board_id]/checklists
 POST /1/boards/[board_id]/lists
 POST /1/boards/[board_id]/myPrefs
 
 */

@implementation VMTrelloApiClient (Board)

- (void)getBoards:(NSString *)boardID
         success:(void (^)(id JSON))JSONSuccess_block
         failure:(void (^)(NSError *error))failure
{
    NSString *getBoards = @"boards/";
    getBoards = [getBoards stringByAppendingString:boardID];
    
    TRELLO_API_GET(getBoards);
}

- (void)getBoardCards:(NSString *)boardID
         success:(void (^)(id JSON))JSONSuccess_block
         failure:(void (^)(NSError *error))failure
{
    NSString *getBoardCards = @"boards/";
    getBoardCards = [getBoardCards stringByAppendingString:boardID];
    getBoardCards = [getBoardCards stringByAppendingString:@"/cards"];

    TRELLO_API_GET(getBoardCards);
}

@end
