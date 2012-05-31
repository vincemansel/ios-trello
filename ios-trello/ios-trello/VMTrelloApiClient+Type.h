//
//  VMTrelloApiClient+Type.h
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient.h"

/*
 type
 
 GET /1/types/[id]
 
 */

@interface VMTrelloApiClient (Type)

- (void)getTypes:(NSString *)typeID
          success:(JSONSuccess_block_t)JSONSuccess_block
          failure:(void (^)(NSError *error))failure;

@end
