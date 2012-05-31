//
//  TrelloLoginViewController.h
//  ios-trello
//
//  Created by Vince Mansel on 5/24/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OAuthv1BaseLoginViewController.h"

@interface TrelloLoginViewController : OAuthv1BaseLoginViewController <UIWebViewDelegate, NSURLConnectionDelegate>
{
    NSUInteger _step;
}
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (copy, nonatomic) NSString * verifier;

@end

