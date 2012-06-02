//
//  TrelloLoginViewController.m
//  ios-trello
//
//  Created by Vince Mansel on 5/24/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

/***********************************************************************************************************
 Getting a Token from a User
 
 You can request a token from a user by directing them to an authorization URL, like the following:
 
 EXAMPLE APP_KEY 123d8c41eefdd86347e6f4e4194f1234
 
 Request a token granting read-only access for 30 days (the default):
 
 https://trello.com/1/authorize?key=substitutewithyourapplicationkey&name=My+Application&expiration=30days&response_type=token
 
 Request a token granting read-only access forever:
 
 https://trello.com/1/authorize?key=substitutewithyourapplicationkey&name=My+Application&expiration=never&response_type=token
 
 
 Request a token granting read/write access for 1 day:
 
 https://trello.com/1/authorize?key=substitutewithyourapplicationkey&name=My+Application&expiration=1day&response_type=token&scope=read,write
 
 Request a token granting read/write access forever:
 
 https://trello.com/1/authorize?key=substitutewithyourapplicationkey&name=My+Application&expiration=never&response_type=token&scope=read,write
 
 
 EXAMPLE TRELLO_ACCESS_TOKEN @"123502e51940086656e7feb91c296be30f5cd112fd550c429c108af0f3a11234"
 
 If the user accepts your request, they’ll be directed to a page where they will be given a token (64 characters), which they can give back to your application. If you add the token to your request, like so:
 
 https://api.trello.com/1/board/substitutewiththeboardid?key=substitutewithyourapplicationkey&token=substitutethispartwiththeauthorizationtokenthatyougotfromtheuser
 
 
 ... then you’ll be able to read a board that’s only visible to the user


 Basic OAuth:
 
 https://trello.com/1/OAuthGetRequestToken
 error: OAuth consumer did not supply its key
 
 https://trello.com/1/OAuthAuthorizeToken
 App not found
 
 https://trello.com/1/OAuthGetAccessToken
 Missing oauth_verifier
 
 ******************************************************************************************************************************/


#import "TrelloLoginViewController.h"

#import "NSMutableURLRequest+YOAuth.h"
#import "TrelloClientCredentials.h"

#import "ymacros.h"
#import "ycocoaadditions.h"
#import "yoauthadditions.h"


@interface TrelloLoginViewController()

@end

@implementation TrelloLoginViewController

@synthesize webView;
@synthesize activityIndicator = _activityIndicator;
@synthesize verifier = _verifier;

#pragma mark - View lifecycle

//NSURL *requestURL = [NSURL URLWithString:@"https://trello.com/1/OAuthGetRequestToken"];
//NSURL *authorizeURL = [NSURL URLWithString:@"https://trello.com/1/OAuthAuthorizeToken"];
//NSURL *accessURL = [NSURL URLWithString:@"https://trello.com/1/OAuthGetAccessToken"];

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURL *requestURL = [NSURL URLWithString:@"https://trello.com/1/OAuthGetRequestToken"];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:requestURL];

    [request prepareOAuthv1AuthorizationHeaderUsingConsumerKey:kTrelloConsumerKey
                                             consumerSecretKey:kTrelloConsumerSecretKey
                                                         token:nil
                                                   tokenSecret:nil
                                               signatureMethod:YOAuthv1SignatureMethodHMAC_SHA1
                                                         realm:nil
                                                      verifier:nil
#warning -- replace ios4trello with your appName
                                                      callback:@"http://ios4trello/"];
    _step = 0;
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.activityIndicator startAnimating];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

// Call this method to get the received data as an NSString. Don't use for binary data!
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

- (void)requestFinished:(NSData *)data {

    NSLog(@"response:%@", [self responseStringforData:data]);

    NSDictionary * params = [[self responseStringforData:data] decodedUrlencodedParameters];
    
    self.accesstoken = [params objectForKey:YOAuthv1OAuthTokenKey];
    self.tokensecret = [params objectForKey:YOAuthv1OAuthTokenSecretKey];
    NSString * confirmed = [params objectForKey:YOAuthv1OAuthCallbackConfirmedKey];
    
    if(confirmed)NSLog(@"callback is confirmed:%@", confirmed);

    //NSURL *authorizeURL = [NSURL URLWithString:@"https://trello.com/1/OAuthAuthorizeToken"];

    if (self.accesstoken && self.tokensecret) {
        if (0 == _step) {
            NSString * url = [NSString stringWithFormat:@"https://trello.com/1/OAuthAuthorizeToken?%@=%@", YOAuthv1OAuthTokenKey, self.accesstoken];
            NSString * urlParameters = @"&expiration=30days&scope=read,write";
            url = [url stringByAppendingString:urlParameters];
            
            NSMutableURLRequest * r = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [self.webView loadRequest:r];
            self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            [self.activityIndicator startAnimating];
        }
        else {
            [self.delegate oauthv1LoginDidFinishLogging:self];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[[self class] description]
                                                         message:[error localizedDescription]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [alertView show];
    
    NSLog(@"response:%@", [error localizedDescription]);
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
    [self.activityIndicator stopAnimating];
}

//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    [self.activityIndicator stopAnimating];
//    
//    NSLog(@"Error = %@", error);
//}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL * url = request.URL;
    NSString * s = [url absoluteString];
    NSString * host = [s host];
    NSLog(@"%@ navType = %d",s, navigationType);
    
#warning -- replace ios4trello with your appName    
    if ([host isEqualToString:@"ios4trello"]) {
        NSDictionary * p = [s queryParameters];
        if (nil == [p objectForKey:@"denied"]) {
            self.verifier = [p objectForKey:YOAuthv1OAuthVerifierKey];
            
            NSURL *accessURL = [NSURL URLWithString:@"https://trello.com/1/OAuthGetAccessToken"];
            
            NSMutableURLRequest * r = [NSMutableURLRequest requestWithURL:accessURL];

            [r prepareOAuthv1AuthorizationHeaderUsingConsumerKey:kTrelloConsumerKey
                                               consumerSecretKey:kTrelloConsumerSecretKey
                                                           token:self.accesstoken
                                                     tokenSecret:self.tokensecret
                                                 signatureMethod:YOAuthv1SignatureMethodHMAC_SHA1
                                                           realm:nil
                                                        verifier:self.verifier
                                                        callback:nil];
            _step = 1;
            self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            [self.activityIndicator startAnimating];
            [NSURLConnection connectionWithRequest:r delegate:self];
        }
        else {
            NSLog(@"authorize denied:%@", [p objectForKey:@"denied"]);
        }
        
        return NO;
    }
    return YES;
}

@end
