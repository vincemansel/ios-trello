//
//  TrelloBoardListViewController.h
//  ios-trello
//
//  Created by Vince Mansel on 5/29/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthv1BaseFeedViewController.h"

@protocol TrelloBoardListViewControllerDelegate <NSObject>

@optional
- (void)didSelectTrelloItemID:(NSString *)itemID name:(NSString *)name;

@end

@interface TrelloBoardListViewController : OAuthv1BaseFeedViewController <NSURLConnectionDelegate>

@property (nonatomic, assign) id<TrelloBoardListViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *operation;
@property (strong, nonatomic) NSString *boardID;

@end
