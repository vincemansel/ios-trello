//
//  VMTrelloApiClient+Board.m
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient+Board.h"

@implementation VMTrelloApiClient (Board)

//GET /1/boards/[board_id]
- (void)get1Boards:(NSString *)board_id success:(void (^)(id JSON))JSONSuccess_block
{
    NSString *request = @"boards/";
    request = [request stringByAppendingString:board_id];
    
    TRELLO_API_GET_HANDLE_FAIL(request);
}

- (void)get1Boards:(NSString *)board_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;
{
    NSString *request = @"boards/";
    request = [request stringByAppendingString:board_id];
    
    TRELLO_API_GET(request);
}

//GET /1/boards/[board_id]/[field]
- (void)get1Boards:(NSString *)board_id
            field:(NSString *)field
          success:(void (^)(id JSON))JSONSuccess_block
{
    NSString *request = @"boards/";
    request = [request stringByAppendingString:board_id];
    request = [request stringByAppendingFormat:@"/%@",field];
    
    TRELLO_API_GET_HANDLE_FAIL(request);    
}

- (void)get1Boards:(NSString *)board_id
             field:(NSString *)field
           success:(void (^)(id JSON))JSONSuccess_block
           failure:(void (^)(NSError *error))failure;
{
    NSString *request = @"boards/";
    request = [request stringByAppendingString:board_id];
    request = [request stringByAppendingFormat:@"/%@",field];
    
    TRELLO_API_GET(request);    
}

//GET /1/boards/[board_id]/actions
- (void)get1BoardsActions:(NSString *)board_id
                success:(void (^)(id JSON))JSONSuccess_block
{
    NSString *request = @"boards/";
    request = [request stringByAppendingString:board_id];
    request = [request stringByAppendingString:@"/actions"];
    
    TRELLO_API_GET_HANDLE_FAIL(request);    
}

- (void)get1BoardsActions:(NSString *)board_id
                  success:(void (^)(id JSON))JSONSuccess_block
                  failure:(void (^)(NSError *error))failure;
{
    NSString *request = @"boards/";
    request = [request stringByAppendingString:board_id];
    request = [request stringByAppendingString:@"/actions"];
    
    TRELLO_API_GET(request);        
}

//GET /1/boards/[board_id]/cards
- (void)get1BoardsCards:(NSString *)board_id
              success:(void (^)(id JSON))JSONSuccess_block
{
    NSString *request = @"boards/";
    request = [request stringByAppendingString:board_id];
    request = [request stringByAppendingString:@"/cards"];
    
    TRELLO_API_GET_HANDLE_FAIL(request);
}

- (void)get1BoardsCards:(NSString *)board_id
                success:(void (^)(id JSON))JSONSuccess_block
                failure:(void (^)(NSError *error))failure;

{
    NSString *request = @"boards/";
    request = [request stringByAppendingString:board_id];
    request = [request stringByAppendingString:@"/cards"];
    
    TRELLO_API_GET(request);
}

- (void)get1BoardsCards:(NSString *)board_id
               filter:(NSString *)filter
              success:(void (^)(id JSON))JSONSuccess_block
{
    
}

- (void)get1BoardsCards:(NSString *)board_id
                 filter:(NSString *)filter
                success:(void (^)(id JSON))JSONSuccess_block
                failure:(void (^)(NSError *error))failure;
{
    
}


- (void)get1BoardsCards:(NSString *)board_id
               idCard:(NSString *)idCard
              success:(void (^)(id JSON))JSONSuccess_block
{
    
}

- (void)get1BoardsCards:(NSString *)board_id
                 idCard:(NSString *)idCard
                success:(void (^)(id JSON))JSONSuccess_block
                failure:(void (^)(NSError *error))failure;
{
    
}


- (void)get1BoardsChecklists:(NSString *)board_id
                   success:(void (^)(id JSON))JSONSuccess_block
{
    
}

- (void)get1BoardsChecklists:(NSString *)board_id
                     success:(void (^)(id JSON))JSONSuccess_block
                     failure:(void (^)(NSError *error))failure;
{
    
}

//*GET /1/boards/[board_id]/lists
- (void)get1BoardsLists:(NSString *)board_id
               success:(void (^)(id JSON))JSONSuccess_block
{
    NSString *request = @"boards/";
    request = [request stringByAppendingString:board_id];
    request = [request stringByAppendingString:@"/lists"];
    
    TRELLO_API_GET_HANDLE_FAIL(request);
}

- (void)get1BoardsLists:(NSString *)board_id
                success:(void (^)(id JSON))JSONSuccess_block
                failure:(void (^)(NSError *error))failure;

{
    NSString *request = @"boards/";
    request = [request stringByAppendingString:board_id];
    request = [request stringByAppendingString:@"/lists"];
    
    TRELLO_API_GET(request);
}


//*PUT /1/boards/[board_id]/desc
- (void)put1BoardsDesc:(NSString *)board_id
                 desc:(NSString *)desc
              success:(void (^)(id JSON))JSONSuccess_block
{
    NSString *request = @"boards/";
    request = [request stringByAppendingString:board_id];
    
    NSDictionary *requestParams = [NSDictionary dictionaryWithObject:desc forKey:@"desc"];
    NSDictionary *params = [VMTrelloApiClient attachRequestParams:requestParams toKeyParams:TRELLO_API_PARAMETERS];
    
    TRELLO_API_PUT_HANDLE_FAIL(request, params);    
}

- (void)put1BoardsDesc:(NSString *)board_id
                  desc:(NSString *)desc
               success:(void (^)(id JSON))JSONSuccess_block
               failure:(void (^)(NSError *error))failure;
{
    NSString *request = @"boards/";
    request = [request stringByAppendingString:board_id];
    
    NSDictionary *requestParams = [NSDictionary dictionaryWithObject:desc forKey:@"desc"];
    NSDictionary *params = [VMTrelloApiClient attachRequestParams:requestParams toKeyParams:TRELLO_API_PARAMETERS];
    
    TRELLO_API_PUT(request, params);    
}

//*POST /1/boards
- (void)post1Boards:(NSString *)name
           success:(void (^)(id JSON))JSONSuccess_block
{
    NSString *request = @"boards";

    NSDictionary *requestParams = [NSDictionary dictionaryWithObject:name forKey:@"name"];
    NSDictionary *params = [VMTrelloApiClient attachRequestParams:requestParams toKeyParams:TRELLO_API_PARAMETERS];
    
    TRELLO_API_POST_HANDLE_FAIL(request, params);        
}

- (void)post1Boards:(NSString *)name
            success:(void (^)(id JSON))JSONSuccess_block
            failure:(void (^)(NSError *error))failure;
{
    NSString *request = @"boards";
    
    NSDictionary *requestParams = [NSDictionary dictionaryWithObject:name forKey:@"name"];
    NSDictionary *params = [VMTrelloApiClient attachRequestParams:requestParams toKeyParams:TRELLO_API_PARAMETERS];
    
    TRELLO_API_POST(request, params);        
}

//POST /1/boards/[board_id]/lists
- (void)post1BoardsLists:(NSString *)board_id
                  list:(NSString *)list
                success:(void (^)(id JSON))JSONSuccess_block
{
    NSString *request = @"boards/";
    request = [request stringByAppendingString:board_id];
    request = [request stringByAppendingString:@"/lists"];
    
    NSDictionary *requestParams = [NSDictionary dictionaryWithObject:list forKey:@"name"];
    NSDictionary *params = [VMTrelloApiClient attachRequestParams:requestParams toKeyParams:TRELLO_API_PARAMETERS];
    
    TRELLO_API_POST_HANDLE_FAIL(request, params);        
}

- (void)post1BoardsLists:(NSString *)board_id
                    list:(NSString *)list
                 success:(void (^)(id JSON))JSONSuccess_block
                 failure:(void (^)(NSError *error))failure;
{
    NSString *request = @"boards/";
    request = [request stringByAppendingString:board_id];
    request = [request stringByAppendingString:@"/lists"];
    
    NSDictionary *requestParams = [NSDictionary dictionaryWithObject:list forKey:@"name"];
    NSDictionary *params = [VMTrelloApiClient attachRequestParams:requestParams toKeyParams:TRELLO_API_PARAMETERS];
    
    TRELLO_API_POST(request, params);        
}


@end
