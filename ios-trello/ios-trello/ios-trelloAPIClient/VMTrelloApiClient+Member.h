//
//  VMTrelloApiClient+Member.h
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient.h"

/*
 member
 
 GET /1/members/[member_id or username]
 GET /1/members/[member_id or username]/[field]
 GET /1/members/[member_id or username]/actions
 GET /1/members/[member_id or username]/boards                                  getMemberMyBoardsWithSuccess:
 GET /1/members/[member_id or username]/boards/[filter]
 GET /1/members/[member_id or username]/boardsInvited
 GET /1/members/[member_id or username]/boardsInvited/[field]
 GET /1/members/[member_id or username]/cards
 GET /1/members/[member_id or username]/cards/[filter]
 GET /1/members/[member_id or username]/notifications
 GET /1/members/[member_id or username]/notifications/[filter]
 GET /1/members/[member_id or username]/organizations
 GET /1/members/[member_id or username]/organizations/[filter]
 GET /1/members/[member_id or username]/organizationsInvited
 GET /1/members/[member_id or username]/organizationsInvited/[field]
 GET /1/members/[member_id or username]/tokens
 PUT /1/members/[member_id or username]
 PUT /1/members/[member_id or username]/bio
 PUT /1/members/[member_id or username]/fullName
 PUT /1/members/[member_id or username]/initials
 
 */

@interface VMTrelloApiClient (Member)

- (void)getMemberMyBoardsWithSuccess:(void (^)(id JSON))JSONSuccess_block
                             failure:(void (^)(NSError *error))failure;

@end
