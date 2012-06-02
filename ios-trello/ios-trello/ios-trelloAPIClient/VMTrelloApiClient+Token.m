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

- (void)deleteToken:(NSString *)token success:(JSONSuccess_block_t)JSONSuccess_block
{
    NSString *request = @"token/";
    request = [request stringByAppendingString:self.accesstoken];
     
    TRELLO_API_DELETE_HANDLE_FAIL(request);
}

- (void)deleteToken:(NSString *)token success:(JSONSuccess_block_t)JSONSuccess_block failure:(void (^)(NSError *))failure
{
    NSString *request = @"token/";
    request = [request stringByAppendingString:self.accesstoken];
    
    TRELLO_API_DELETE(request);
}


- (void)getTokens:(NSString *)token success:(JSONSuccess_block_t)JSONSuccess_block
{
    
}

- (void)getTokens:(NSString *)token success:(JSONSuccess_block_t)JSONSuccess_block failure:(void (^)(NSError *error))failure
{
    
}

- (void)getTokens:(NSString *)token field:(NSArray *)fields success:(JSONSuccess_block_t)JSONSuccess_block
{
    
}

- (void)getTokens:(NSString *)token field:(NSArray *)fields success:(JSONSuccess_block_t)JSONSuccess_block failure:(void (^)(NSError *error))failure
{
    
}

- (void)getTokens:(NSString *)token member:(NSString *)member success:(JSONSuccess_block_t)JSONSuccess_block
{
    
}

- (void)getTokens:(NSString *)token member:(NSString *)member success:(JSONSuccess_block_t)JSONSuccess_block failure:(void (^)(NSError *error))failure
{
    
}

- (void)getTokens:(NSString *)token member:(NSString *)member field:(NSArray *)fields
          success:(JSONSuccess_block_t)JSONSuccess_block
{
    
}

- (void)getTokens:(NSString *)token member:(NSString *)member field:(NSArray *)fields
          success:(JSONSuccess_block_t)JSONSuccess_block failure:(void (^)(NSError *error))failure
{
    
}



@end
