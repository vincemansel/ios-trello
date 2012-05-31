//
//  VMTrelloApiClient+Board.m
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient+Board.h"

@implementation VMTrelloApiClient (Board)

- (void)getBoards:(NSString *)boardID
          success:(void (^)(id JSON))JSONSuccess_block
          failure:(void (^)(NSError *error))failure
{
    NSString *getBoards = @"boards/";
    getBoards = [getBoards stringByAppendingString:boardID];
    
    TRELLO_API_GET(getBoards);
}

- (void)getBoards:(NSString *)boardID
            field:(NSArray *)fields
          success:(void (^)(id JSON))JSONSuccess_block
          failure:(void (^)(NSError *error))failure
{
    
}

- (void)getBoardActions:(NSString *)boardID
                success:(void (^)(id JSON))JSONSuccess_block
                failure:(void (^)(NSError *error))failure
{
    
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

- (void)getBoardCards:(NSString *)boardID
               filter:(NSArray *)filters
              success:(void (^)(id JSON))JSONSuccess_block
              failure:(void (^)(NSError *error))failure
{
    
}

- (void)getBoardCards:(NSString *)boardID
               idCard:(NSString *)idCard
              success:(void (^)(id JSON))JSONSuccess_block
              failure:(void (^)(NSError *error))failure
{
    
}

- (void)getBoardChecklists:(NSString *)boardID
                   success:(void (^)(id JSON))JSONSuccess_block
                   failure:(void (^)(NSError *error))failure
{
    
}



@end
