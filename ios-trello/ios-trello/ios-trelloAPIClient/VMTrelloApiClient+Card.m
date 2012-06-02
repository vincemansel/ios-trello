//
//  VMTrelloApiClient+Card.m
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient+Card.h"

@implementation VMTrelloApiClient (Card)

// GET /1/cards/[card_id]
- (void)get1Cards:(NSString *)card_id success:(void (^)(id JSON))JSONSuccess_block;
{
    NSString *request = @"cards/";
    request = [request stringByAppendingString:card_id];
    
    TRELLO_API_GET_HANDLE_FAIL(request);
}

- (void)get1Cards:(NSString *)card_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;
{
    NSString *request = @"cards/";
    request = [request stringByAppendingString:card_id];
    
    TRELLO_API_GET(request);    
}

//GET /1/cards/[card_id]/list
- (void)get1CardsList:(NSString *)card_id success:(void (^)(id JSON))JSONSuccess_block;
{
    NSString *request = @"cards/";
    request = [request stringByAppendingString:card_id];
    request = [request stringByAppendingString:@"/list"];
    
    TRELLO_API_GET_HANDLE_FAIL(request);    
}

- (void)get1CardsList:(NSString *)card_id success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;
{
    NSString *request = @"cards/";
    request = [request stringByAppendingString:card_id];
    request = [request stringByAppendingString:@"/list"];
    
    TRELLO_API_GET(request);        
}

//PUT /1/cards/[card_id]/desc
- (void)put1CardsDesc:(NSString *)card_id desc:(NSString *)desc success:(void (^)(id JSON))JSONSuccess_block;
{
    NSString *request = @"cards/";
    request = [request stringByAppendingString:card_id];
    
    NSDictionary *requestParams = [NSDictionary dictionaryWithObject:desc forKey:@"desc"];
    NSDictionary *params = [VMTrelloApiClient attachRequestParams:requestParams toKeyParams:TRELLO_API_PARAMETERS];
    
    TRELLO_API_PUT_HANDLE_FAIL(request, params);        
}

- (void)put1CardsDesc:(NSString *)card_id desc:(NSString *)desc success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;
{
    NSString *request = @"cards/";
    request = [request stringByAppendingString:card_id];
    
    NSDictionary *requestParams = [NSDictionary dictionaryWithObject:desc forKey:@"desc"];
    NSDictionary *params = [VMTrelloApiClient attachRequestParams:requestParams toKeyParams:TRELLO_API_PARAMETERS];
    
    TRELLO_API_PUT(request, params);            
}

//POST /1/cards
- (void)post1Cards:(NSString *)name idList:(NSString *)idList success:(void (^)(id JSON))JSONSuccess_block;
{
    NSString *request = @"cards";
    
    NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", idList, @"idList", nil];
    NSDictionary *params = [VMTrelloApiClient attachRequestParams:requestParams toKeyParams:TRELLO_API_PARAMETERS];
    
    TRELLO_API_POST_HANDLE_FAIL(request, params);            
}

- (void)post1Cards:(NSString *)name idList:(NSString *)idList success:(void (^)(id JSON))JSONSuccess_block failure:(void (^)(NSError *error))failure;
{
    NSString *request = @"cards";
    
    NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", idList, @"idList", nil];
    NSDictionary *params = [VMTrelloApiClient attachRequestParams:requestParams toKeyParams:TRELLO_API_PARAMETERS];
    
    TRELLO_API_POST_HANDLE_FAIL(request, params);                
}


@end
