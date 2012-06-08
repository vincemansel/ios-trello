//
//  VMTrelloApiClient+Member.m
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient+Member.h"

@implementation VMTrelloApiClient (Member)

//GET /1/members/[member_id or username]/boards
- (void)getMemberMyBoardsWithSuccess:(void (^)(id JSON))JSONSuccess_block
{
    NSString *request = @"members/my/boards";
    
    TRELLO_API_GET_HANDLE_FAIL(request);
}

- (void)getMemberMyBoardsWithSuccess:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *))failure
{
    NSString *request = @"members/my/boards";
    
    TRELLO_API_GET(request);
}

//GET /1/members/[member_id or username]/boards/[filter]
- (void)getMemberMyBoardsFilter:(NSString *)filter success:(void (^)(id JSON))JSONSuccess_block;
{
    NSString *request = [@"members/my/boards/" stringByAppendingString:filter];
    
    TRELLO_API_GET_HANDLE_FAIL(request);    
}

- (void)getMemberMyBoardsFilter:(NSString *)filter success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *))failure;
{
    NSString *request = [@"members/my/boards/" stringByAppendingString:filter];
    
    TRELLO_API_GET(request);       
}

@end
