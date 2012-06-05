//
//  VMTrelloApiClient+Board.h
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient.h"

/*
 board
 
 IMPLEMENTED:
 
 GET /1/boards/[board_id]
 GET /1/boards/[board_id]/[field]
 GET /1/boards/[board_id]/actions
 GET /1/boards/[board_id]/cards
 GET /1/boards/[board_id]/lists
 PUT /1/boards/[board_id]/desc
 POST /1/boards
 POST /1/boards/[board_id]/lists
 
 PUT /1/boards/[board_id]/name
 
 PLANNED:
 
 -GET /1/boards/[board_id]/[field]
 -GET /1/boards/[board_id]/cards/[filter]
 -GET /1/boards/[board_id]/cards/[idCard]
 -GET /1/boards/[board_id]/checklists
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
 PUT /1/boards/[board_id]/name
 PUT /1/boards/[board_id]/prefs/comments
 PUT /1/boards/[board_id]/prefs/invitations
 PUT /1/boards/[board_id]/prefs/permissionLevel
 PUT /1/boards/[board_id]/prefs/selfJoin
 PUT /1/boards/[board_id]/prefs/voting
 POST /1/boards/[board_id]/checklists
 POST /1/boards/[board_id]/myPrefs
 
 */

@interface VMTrelloApiClient (Board)

//GET /1/boards/[board_id]
- (void)get1Boards:(NSString *)board_id success:(void (^)(id JSON))JSONSuccess_block;
- (void)get1Boards:(NSString *)board_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

// GET /1/boards/[board_id]/[field]
- (void)get1Boards:(NSString *)board_id field:(NSString *)fields success:(void (^)(id JSON))JSONSuccess_block;
- (void)get1Boards:(NSString *)board_id field:(NSString *)fields success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

// GET /1/boards/[board_id]/actions
- (void)get1BoardsActions:(NSString *)board_id success:(void (^)(id JSON))JSONSuccess_block;
- (void)get1BoardsActions:(NSString *)board_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

//GET /1/boards/[board_id]/cards
- (void)get1BoardsCards:(NSString *)board_id success:(void (^)(id JSON))JSONSuccess_block;
- (void)get1BoardsCards:(NSString *)board_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

- (void)get1BoardsCards:(NSString *)board_id filter:(NSString *)filter success:(void (^)(id JSON))JSONSuccess_block;
- (void)get1BoardsCards:(NSString *)board_id filter:(NSString *)filter success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

- (void)get1BoardsCards:(NSString *)board_id idCard:(NSString *)idCard success:(void (^)(id JSON))JSONSuccess_block;
- (void)get1BoardsCards:(NSString *)board_id idCard:(NSString *)idCard success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

- (void)get1BoardsChecklists:(NSString *)board_id success:(void (^)(id JSON))JSONSuccess_block;
- (void)get1BoardsChecklists:(NSString *)board_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

//*GET /1/boards/[board_id]/lists
- (void)get1BoardsLists:(NSString *)board_id success:(void (^)(id JSON))JSONSuccess_block;
- (void)get1BoardsLists:(NSString *)board_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

//*PUT /1/boards/[board_id]/desc
- (void)put1BoardsDesc:(NSString *)board_id desc:(NSString *)desc success:(void (^)(id JSON))JSONSuccess_block;
- (void)put1BoardsDesc:(NSString *)board_id desc:(NSString *)desc success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

//*POST /1/boards
- (void)post1Boards:(NSString *)name success:(void (^)(id JSON))JSONSuccess_block;
- (void)post1Boards:(NSString *)name success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

//?POST /1/boards/[board_id]/lists
- (void)post1BoardsLists:(NSString *)board_id list:(NSString *)list success:(void (^)(id JSON))JSONSuccess_block;
- (void)post1BoardsLists:(NSString *)board_id list:(NSString *)list success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

//PUT /1/board/[board_id]/name
- (void)put1BoardsName:(NSString *)name board_id:(NSString *)board_id success:(void (^)(id JSON))JSONSuccess_block;
- (void)put1BoardsName:(NSString *)name board_id:(NSString *)board_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

@end
