//
//  VMTrelloApiClient+Token.m
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient+Token.h"
#import "TrelloClientCredentials.h"

/*
 token
 
 GET /1/tokens/[token]
 GET /1/tokens/[token]/[field]
 GET /1/tokens/[token]/member
 GET /1/tokens/[token]/member/[field]
 DELETE /1/tokens/[token]                                                       deleteToken
  
 */

@implementation VMTrelloApiClient (Token)

- (void)deleteToken:(NSString *)token success:(JSONSuccess_block_t)JSONSuccess_block failure:(void (^)(NSError *))failure
{
    NSString *deleteToken = @"token/";
    deleteToken = [deleteToken stringByAppendingString:self.accesstoken];
     
    TRELLO_API_DELETE(deleteToken);
}

@end
