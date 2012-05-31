//
//  VMTrelloApiClient+Member.h
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient.h"

@interface VMTrelloApiClient (Member)

- (void)getMemberMyBoardsWithSuccess:(void (^)(id JSON))JSONSuccess_block
                             failure:(void (^)(NSError *error))failure;

@end
