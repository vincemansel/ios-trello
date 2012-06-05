//
//  VMTrelloApiClient+List.h
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient.h"

/*
 list
 
 IMPLEMENTED:
 
 GET /1/lists/[list_id]
 POST /1/lists
 POST /1/lists/[list_id]/cards
 
 PUT /1/lists/[list_id]/name
 
 PLANNED:
 
 GET /1/lists/[list_id]/[field]
 GET /1/lists/[list_id]/actions
 GET /1/lists/[list_id]/board
 GET /1/lists/[list_id]/board/[field]
 GET /1/lists/[list_id]/cards
 GET /1/lists/[list_id]/cards/[filter]
 PUT /1/lists/[list_id]
 PUT /1/lists/[list_id]/closed
 PUT /1/lists/[list_id]/name
 
*/

@interface VMTrelloApiClient (List)

//GET /1/lists/[list_id]
- (void)get1Lists:(NSString *)list_id success:(void (^)(id JSON))JSONSuccess_block;
- (void)get1Lists:(NSString *)list_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

//POST /1/lists
- (void)post1Lists:(NSString *)name idBoard:(NSString *)idBoard success:(void (^)(id JSON))JSONSuccess_block;
- (void)post1Lists:(NSString *)name idBoard:(NSString *)idBoard success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

//POST /1/lists/[list_id]/cards
- (void)post1ListsCards:(NSString *)name list_id:(NSString *)list_id success:(void (^)(id JSON))JSONSuccess_block;
- (void)post1ListsCards:(NSString *)name list_id:(NSString *)list_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

//PUT /1/lists/[list_id]/name
- (void)put1ListsName:(NSString *)name list_id:(NSString *)list_id success:(void (^)(id JSON))JSONSuccess_block;
- (void)put1ListsName:(NSString *)name list_id:(NSString *)list_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;

@end
