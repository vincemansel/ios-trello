//
//  VMTrelloApiClient.h
//  ios-trello
//
//  Created by Vince Mansel on 5/23/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

/* Based on Trello API Reference (Beta) 1 */
// https://trello.com/docs/api/index.html
// © Copyright 2011, Fog Creek Software.

#import <Foundation/Foundation.h>
#import "TrelloClientCredentials.h"
#import "TrelloDefines.h"
#import "AFNetworking.h"
#import "OAuthv1BaseLoginViewController.h"

typedef void (^JSONSuccess_block_t)(id JSON);

#define TRELLO_API_PARAMETERS [[VMTrelloApiClient sharedSession] params]

#define TRELLO_API_GET(__X__) [[VMTrelloApiClient sharedSession] \
getPath:__X__ \
parameters:TRELLO_API_PARAMETERS \
success:^(AFHTTPRequestOperation *operation, id JSON) { JSONSuccess_block(JSON); } \
failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];

#define TRELLO_API_GET_HANDLE_FAIL(__X__) [[VMTrelloApiClient sharedSession] \
getPath:__X__ \
parameters:TRELLO_API_PARAMETERS \
success:^(AFHTTPRequestOperation *operation, id JSON) { JSONSuccess_block(JSON); } \
failure:^(AFHTTPRequestOperation *operation, NSError *error) { \
    NSLog(@"%@ JSON Error: %@", __X__, error.description); \
}];

#define TRELLO_API_PUT(__X__,__Y__) [[VMTrelloApiClient sharedSession] \
putPath:__X__ \
parameters:__Y__ \
success:^(AFHTTPRequestOperation *operation, id JSON) { JSONSuccess_block(JSON); } \
failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];

#define TRELLO_API_PUT_HANDLE_FAIL(__X__,__Y__) [[VMTrelloApiClient sharedSession] \
putPath:__X__ \
parameters:__Y__ \
success:^(AFHTTPRequestOperation *operation, id JSON) { JSONSuccess_block(JSON); } \
failure:^(AFHTTPRequestOperation *operation, NSError *error) { \
    NSLog(@"%@ JSON Error: %@", __X__, error.description); \
}];

#define TRELLO_API_POST(__X__,__Y__) [[VMTrelloApiClient sharedSession] \
postPath:__X__ \
parameters:__Y__ \
success:^(AFHTTPRequestOperation *operation, id JSON) { JSONSuccess_block(JSON); } \
failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];

#define TRELLO_API_POST_HANDLE_FAIL(__X__,__Y__) [[VMTrelloApiClient sharedSession] \
postPath:__X__ \
parameters:__Y__ \
success:^(AFHTTPRequestOperation *operation, id JSON) { JSONSuccess_block(JSON); } \
failure:^(AFHTTPRequestOperation *operation, NSError *error) { \
    NSLog(@"%@ JSON Error: %@", __X__, error.description); \
}];

#define TRELLO_API_DELETE(__X__) [[VMTrelloApiClient sharedSession] \
deletePath:__X__ \
parameters:TRELLO_API_PARAMETERS \
success:^(AFHTTPRequestOperation *operation, id JSON) { JSONSuccess_block(JSON); } \
failure:^(AFHTTPRequestOperation *operation, NSError *error) { failure(error); }];

#define TRELLO_API_DELETE_HANDLE_FAIL(__X__) [[VMTrelloApiClient sharedSession] \
deletePath:__X__ \
parameters:TRELLO_API_PARAMETERS \
success:^(AFHTTPRequestOperation *operation, id JSON) { JSONSuccess_block(JSON); } \
failure:^(AFHTTPRequestOperation *operation, NSError *error) { \
    NSLog(@"%@ JSON Error: %@", __X__, error.description); \
}];


@interface VMTrelloApiClient : AFHTTPClient <OAuthv1LoginDelegate>

+ (id)sharedSession;
- (BOOL)isLinked;
- (void)link;
- (void)unLinkAll;

// returns the ConsumerKey and AccessToken in a convenient dictionary to build a requestURL
- (NSDictionary *)params;
+ (NSDictionary *)attachRequestParams:(NSDictionary *)requestParams toKeyParams:(NSDictionary *)keyParams;

+ (void)operationDidFailWithError:(NSError *)error title:(NSString *)title message:(NSString *)message;

@property (nonatomic, copy) NSString * accesstoken;
@property (nonatomic, copy) NSString * tokensecret;

@end
