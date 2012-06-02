//
//  VMTrelloApiClient+List.m
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient+List.h"

@implementation VMTrelloApiClient (List)

//GET /1/lists/[list_id]
- (void)get1Lists:(NSString *)list_id success:(void (^)(id JSON))JSONSuccess_block
{
    NSString *request = @"lists/";
    request = [request stringByAppendingString:list_id];
    
    TRELLO_API_GET_HANDLE_FAIL(request);    
}

- (void)get1Lists:(NSString *)list_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure
{
    NSString *request = @"lists/";
    request = [request stringByAppendingString:list_id];
    
    TRELLO_API_GET(request);        
}

//POST /1/lists
- (void)post1Lists:(NSString *)name idBoard:(NSString *)idBoard success:(void (^)(id JSON))JSONSuccess_block
{
    NSString *request = @"lists";
    
    NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", idBoard, @"idBoard", nil];
    NSDictionary *params = [VMTrelloApiClient attachRequestParams:requestParams toKeyParams:TRELLO_API_PARAMETERS];
    
    TRELLO_API_POST_HANDLE_FAIL(request, params);                
}

- (void)post1Lists:(NSString *)name idBoard:(NSString *)idBoard success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure
{
    NSString *request = @"lists";
    
    NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", idBoard, @"idBoard", nil];
    NSDictionary *params = [VMTrelloApiClient attachRequestParams:requestParams toKeyParams:TRELLO_API_PARAMETERS];
    
    TRELLO_API_POST(request, params);                    
}

//POST /1/lists/[list_id]/cards
- (void)post1ListsCards:(NSString *)name list_id:(NSString *)list_id success:(void (^)(id JSON))JSONSuccess_block
{
    NSString *request = @"lists/";
    request = [request stringByAppendingString:list_id];
    request = [request stringByAppendingString:@"/cards"];
    
    NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", nil];
    NSDictionary *params = [VMTrelloApiClient attachRequestParams:requestParams toKeyParams:TRELLO_API_PARAMETERS];

    TRELLO_API_POST_HANDLE_FAIL(request, params);    
}

- (void)post1ListsCards:(NSString *)name list_id:(NSString *)list_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure
{
    NSString *request = @"lists/";
    request = [request stringByAppendingString:list_id];
    request = [request stringByAppendingString:@"/cards"];
    
    NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", nil];
    NSDictionary *params = [VMTrelloApiClient attachRequestParams:requestParams toKeyParams:TRELLO_API_PARAMETERS];
    
    TRELLO_API_POST(request, params);        
}

@end
