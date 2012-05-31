//
//  VMTrelloApiClient.m
//  ios-trello
//
//  Created by Vince Mansel on 5/23/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import "VMTrelloApiClient.h"
#import "NSMutableURLRequest+YOAuth.h"

#import "ymacros.h"
#import "TrelloLoginViewController.h"

#import "VMTrelloApiClient+Token.h"


@interface VMTrelloApiClient()
{
    UIPopoverController *loginPopoverController;
}

@property BOOL isTrelloLinked;

@end

@implementation VMTrelloApiClient

#define VMTrelloAPIBaseURLString @"https://api.trello.com/1/"

@synthesize tokensecret = _tokensecret;
@synthesize accesstoken = _accesstoken;
@synthesize isTrelloLinked = _isTrelloLinked;

+ (id)sharedSession
{
    static VMTrelloApiClient *__sharedSession;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedSession = [[VMTrelloApiClient alloc] initWithBaseURL:[NSURL URLWithString:VMTrelloAPIBaseURLString]];
            });
    
    return __sharedSession;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        // custom settings
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    
    return self;
}

- (BOOL)isLinked
{
    return self.isTrelloLinked;
}

- (void)link
{
    [[[self class] sharedSession] establishLink];
}

- (void)unLinkAll
{
    // send DELETE /1/tokens/[token] to delete token at Trello
    
    [[[self class] sharedSession]
     deleteToken:self.accesstoken
     success:^(id JSON) {
        NSLog(@"DELETE Token Successful: %@", JSON);
     }
     failure:^(NSError *error) {
        [[self class] operationDidFailWithError:error title:@"Trello" message:@"DELETE Token Error"];
         NSLog(@"DELETE Token Error: %@", error.description);
     }];

    self.accesstoken = nil;
    self.tokensecret = nil;
    self.isTrelloLinked = NO;
}

- (void)establishLink {
    if (self.accesstoken && self.tokensecret) {
        
        //NSString *url = [NSString stringWithFormat:@"%@?key=%@&token=%@", @"https://trello.com/1/members/my/boards/pinned", kTrelloConsumerKey, self.accesstoken];
        
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://trello.com/1/members/my/boards/pinned"]];

        [request prepareOAuthv1AuthorizationHeaderUsingConsumerKey:kTrelloConsumerKey
                                                 consumerSecretKey:kTrelloConsumerSecretKey
                                                             token:self.accesstoken
                                                       tokenSecret:self.tokensecret 
                                                             realm:nil
                                                          verifier:nil
                                                          callback:nil];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    else {
        // LoginViewController
        [[[self class] sharedSession] startLogin];
    }
    
}

- (void)startLogin
{
    TrelloLoginViewController * login = [[TrelloLoginViewController alloc] initWithNibName:@"TrelloLoginViewController" bundle:nil];
    login.delegate = self;
    
    if (loginPopoverController) {
        [loginPopoverController dismissPopoverAnimated:YES];
    }
    loginPopoverController = [[UIPopoverController alloc] initWithContentViewController:login];
    
    CGRect rect;
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
        rect = CGRectMake(1, 1, 1, 1);
    }
    else {
        rect = CGRectMake(1023, 660, 10, 10);
    }
    
    [loginPopoverController presentPopoverFromRect:rect inView:[[UIApplication sharedApplication] keyWindow]  permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
    
    [loginPopoverController setPopoverContentSize:CGSizeMake(1024, 660) animated:YES];
}

- (void)oauthv1LoginDidFinishLogging:(OAuthv1BaseLoginViewController *)loginViewController {
    self.accesstoken = loginViewController.accesstoken;
    self.tokensecret = loginViewController.tokensecret;
    
    [[[self class] sharedSession] establishLink];
    [loginPopoverController dismissPopoverAnimated:YES];
}


- (NSString *)responseStringforData:(NSData *)data
{
	if (!data) {
		return nil;
	}
    return [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSISOLatin1StringEncoding]; //Hack!!!
}


- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    NSString *encoding = [response textEncodingName];
    encoding = encoding;
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
    [self requestFinished:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [[self class] operationDidFailWithError:error title:[[self class] description] message:Network_Authorization_Error_Please_login];
    self.isTrelloLinked = NO;
}

+ (void)operationDidFailWithError:(NSError *)error title:(NSString *)title message:(NSString *)message
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [alertView show];
    
    NSLog(@"response:%@", [error localizedDescription]);
}

- (void)requestFinished:(NSData *)data
{
    NSError *error = nil;
    id value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
   //NSLog(@"JSON: %@", value);
    if (YIS_INSTANCE_OF(value, NSArray)) {
        
        self.isTrelloLinked = YES;
        NSLog(@"App linked successfully!");
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:TRELLO_LINK_NOTIFICATION_SUCCESS object:[VMTrelloApiClient sharedSession]]];
        // At this point you can start making API calls
    }
    else {
        NSLog(@"Authorization Error: %@", error.description);
        NSLog(@"App not linked successfully!");
        //[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:TRELLO_LINK_NOTIFICATION_FAILURE object:[VMTrelloApiClient sharedSession]]];
        self.isTrelloLinked = NO;
        [[[self class] sharedSession] startLogin];
    }
}

- (NSDictionary *)params
{
    return [NSDictionary dictionaryWithObjectsAndKeys:kTrelloConsumerKey, @"key", self.accesstoken, @"token", nil];;
}

#pragma mark - properties

#define ACCESSTOKEN_KEY @"trelloaccesstoken"
#define TOKENSECRET_KEY @"trellotokensecret"
#define ISTRELLOLINKED  @"isTrelloLinked"

- (void)setAccesstoken:(NSString *)accesstoken {
    
    [[NSUserDefaults standardUserDefaults] setObject:accesstoken forKey:ACCESSTOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _accesstoken = accesstoken;
}

- (NSString *)accesstoken {
    
    NSString * token = nil;
    token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESSTOKEN_KEY];
    _accesstoken = token;
    return token;
}

- (void)setTokensecret:(NSString *)tokensecret
{

    [[NSUserDefaults standardUserDefaults] setObject:tokensecret forKey:TOKENSECRET_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _tokensecret = tokensecret;
}


- (NSString *)tokensecret {
    
    NSString * token = nil;
    token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKENSECRET_KEY];
    _tokensecret = token;
    return token;
}

- (BOOL)isTrelloLinked {

    NSNumber * linkStatus = nil;
    linkStatus = [[NSUserDefaults standardUserDefaults] objectForKey:ISTRELLOLINKED];
    _isTrelloLinked = [linkStatus boolValue];
    return _isTrelloLinked;

}

- (void)setIsTrelloLinked:(BOOL)isTrelloLinked
{    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isTrelloLinked] forKey:ISTRELLOLINKED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _isTrelloLinked = isTrelloLinked;
}


@end