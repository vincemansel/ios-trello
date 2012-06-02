//
//  VMTrelloApiClient+Token.h
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient.h"

/*
 token

 IMPLEMENTED:
 
 DELETE /1/tokens/[token]                                                       deleteToken
 
 PLANNED:
  
 -GET /1/tokens/[token]
 -GET /1/tokens/[token]/[field]
 -GET /1/tokens/[token]/member
 -GET /1/tokens/[token]/member/[field]
 
 */

@interface VMTrelloApiClient (Token)

- (void)getTokens:(NSString *)token success:(JSONSuccess_block_t)JSONSuccess_block;
- (void)getTokens:(NSString *)token success:(JSONSuccess_block_t)JSONSuccess_block failure:(void (^)(NSError *error))failure;

- (void)getTokens:(NSString *)token field:(NSArray *)fields success:(JSONSuccess_block_t)JSONSuccess_block;
- (void)getTokens:(NSString *)token field:(NSArray *)fields success:(JSONSuccess_block_t)JSONSuccess_block failure:(void (^)(NSError *error))failure;

- (void)getTokens:(NSString *)token member:(NSString *)member success:(JSONSuccess_block_t)JSONSuccess_block;
- (void)getTokens:(NSString *)token member:(NSString *)member success:(JSONSuccess_block_t)JSONSuccess_block failure:(void (^)(NSError *error))failure;

- (void)getTokens:(NSString *)token member:(NSString *)member field:(NSArray *)fields
          success:(JSONSuccess_block_t)JSONSuccess_block;
- (void)getTokens:(NSString *)token member:(NSString *)member field:(NSArray *)fields
          success:(JSONSuccess_block_t)JSONSuccess_block
          failure:(void (^)(NSError *error))failure;

- (void)deleteToken:(NSString *)token success:(JSONSuccess_block_t)JSONSuccess_block;
- (void)deleteToken:(NSString *)token success:(JSONSuccess_block_t)JSONSuccess_block failure:(void (^)(NSError *error))failure;

@end
