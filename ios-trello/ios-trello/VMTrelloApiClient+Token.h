//
//  VMTrelloApiClient+Token.h
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient.h"

@interface VMTrelloApiClient (Token)

- (void)deleteToken:(NSString *)token
            success:(JSONSuccess_block_t)JSONSuccess_block
            failure:(void (^)(NSError *error))failure;

@end
