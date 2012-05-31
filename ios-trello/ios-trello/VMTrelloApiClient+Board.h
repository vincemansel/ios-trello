//
//  VMTrelloApiClient+Board.h
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient.h"

@interface VMTrelloApiClient (Board)

- (void)getBoards:(NSString *)boardID
         success:(void (^)(id JSON))JSONSuccess_block
         failure:(void (^)(NSError *error))failure;


- (void)getBoardCards:(NSString *)boardID
         success:(void (^)(id JSON))JSONSuccess_block
         failure:(void (^)(NSError *error))failure;

@end
