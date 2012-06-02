//
//  VMTrelloApiClient+Action.m
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient+Action.h"

@implementation VMTrelloApiClient (Action)

- (void)get1Actions:(NSString *)action_id success:(void (^)(id JSON))JSONSuccess_block;
{
    NSString *request = @"actions/";
    request = [request stringByAppendingString:action_id];
    
    TRELLO_API_GET_HANDLE_FAIL(request);
}

- (void)get1Actions:(NSString *)action_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;
{
    NSString *request = @"actions/";
    request = [request stringByAppendingString:action_id];
    
    TRELLO_API_GET(request);    
}

@end
