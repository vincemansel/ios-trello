//
//  TrelloBoardOpsViewController.h
//  ios-trello
//
//  Created by Vince Mansel on 4/19/12.
//  Copyright (c) 2012 waveOcean Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrelloBoardListViewController.h"
#import "TrelloDataEntryViewController.h"

@interface TrelloBoardOpsViewController : UITableViewController <TrelloBoardListViewControllerDelegate, TrelloDataEntryViewControllerDelegate>

@end
