//
//  VMTrelloApiClient+Token.m
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient+Token.h"
#import "TrelloClientCredentials.h"

@implementation VMTrelloApiClient (Token)

- (void)deleteToken:(NSString *)token success:(JSONSuccess_block_t)JSONSuccess_block failure:(void (^)(NSError *))failure
{
    NSString *deleteToken = @"token/";
    deleteToken = [deleteToken stringByAppendingString:self.accesstoken];
     
    TRELLO_API_DELETE(deleteToken);
}

- (void)getTokens:(NSString *)token
          success:(JSONSuccess_block_t)JSONSuccess_block
          failure:(void (^)(NSError *error))failure
{
    
}

- (void)getTokens:(NSString *)token
field:(NSArray *)fields
success:(JSONSuccess_block_t)JSONSuccess_block
failure:(void (^)(NSError *error))failure
{
    
}

- (void)getTokens:(NSString *)token
           member:(NSString *)member
          success:(JSONSuccess_block_t)JSONSuccess_block
          failure:(void (^)(NSError *error))failure
{
    
}

- (void)getTokens:(NSString *)token
member:(NSString *)member
field:(NSArray *)fields
success:(JSONSuccess_block_t)JSONSuccess_block
failure:(void (^)(NSError *error))failure
{
    
}



@end
