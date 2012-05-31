//
//  VMTrelloApiClient+Member.m
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient+Member.h"

@implementation VMTrelloApiClient (Member)

- (void)getMemberMyBoardsWithSuccess:(void (^)(id JSON))JSONSuccess_block
                             failure:(void (^)(NSError *error))failure
{
    NSString *getMemberMyBoards = @"members/my/boards";
    
    TRELLO_API_GET(getMemberMyBoards);
}


@end
