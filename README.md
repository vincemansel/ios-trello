ios-trello
==========

An iOS (Objective-C) API Wrapper for Trello

Trello is a free, collaborative task management web tool that can be used for anything. Really!
Check it out [here](http://www.trello.com). This project contains sources to enable you to build Trello into your native iOS projects.
It is basically an API wrapper that makes it easy for your app to login and send GET, PUT, POST and DELETE HTTP signals to your available and authorized Trello boards.

It is based on the Trello API, AFNetworking (for transport) and ytoolkit/NSMutableURLRequest (for OAuth).

Here is the pattern to get a list of boards (with a name that starts with a variant of "MyProject") from Trello. It is up to you how you parse, handle and display the JSON
that is returned. This examples stores the names into an NSArray model called boardList, and the ids into an NSArray called boardIDs.

```
- (void)loadFeedStream {
    if (self.accesstoken && self.tokensecret) {
    
        [[VMTrelloApiClient sharedSession] getMemberMyBoardsWithSuccess:^(id JSON) {
             [self parseJSONforMyProjectBoards:JSON];
             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
         }
         failure:^(NSError *error) {
             [VMTrelloApiClient operationDidFailWithError:error title:@"Trello" message:Network_Authorization_Error_Please_login]; 
             NSLog(@"Authorization Error: %@", error.description);
         }];
    }
}

- (void)parseJSONforMyProjectBoards:(id)JSON
{
    //NSLog(@"Name: %@ %@", [JSON valueForKeyPath:@"name"], [JSON valueForKeyPath:@"memberships"]);
    //NSLog(@"JSON: %@", JSON);
    if (YIS_INSTANCE_OF(JSON, NSArray)) {
        [self.messages removeAllObjects];
        for (id item in JSON) {
            if (YIS_INSTANCE_OF(item, NSDictionary)) {
                NSString * boardName = [item objectForKey:@"name"];
                if (YIS_INSTANCE_OF(boardName, NSString)) {
                    if (   [boardName rangeOfString:@"[MyProject]"].location == 0
                        || [boardName rangeOfString:@"MyProject:"].location  == 0) {
                        [self.boardList addObject:boardName];
                        [self.boardIDs addObject:[item objectForKey:@"id"]];
                        NSLog(@"boardName: %@, id = %@", boardName, [self.boardIDs lastObject]);
                    }
                }
            }
        }
    }
}
```

Assuming you have those listed in a tableView, here is how to acccess one board and list the cards on that board.


```
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Board = %@", [self.messages objectAtIndex:indexPath.row]);
    
    [[VMTrelloApiClient sharedSession] 
     getBoards:[self.boardIDs objectAtIndex:indexPath.row]
     success:^(id JSON) {
         NSLog(@"Board:JSON = %@", JSON);
     } failure:^(NSError *error) {
         NSLog(@"Board JSON Error: %@", error.description);
     }];
    
    [[VMTrelloApiClient sharedSession] 
     getBoardCards:[self.boardIDs objectAtIndex:indexPath.row]
     success:^(id JSON) {
         NSLog(@"BoardCards:JSON = %@", JSON);
     } failure:^(NSError *error) {
         NSLog(@"BoardCards JSON Error: %@", error.description);
     }];
}
```


Here is how to get started.

## Additional Sources Required:

* Reachability (Apple)
* AFNetworking (http://github.com/AFNetworking/AFNetworking)

## Dependencies:

* ytoolkit (OAuthv1) (http://github.com/sprhawk/ytoolkit)
 * (Note: for expendiency, delete all test directories, SenTesting Framework and ASIHTTPRequest files from ytoolkit)
 * (If you are not linking against the static library, you will also need to fix some fix some imports: i.e. change <ytoolkit/ydefines.h> to "ydefines.h")

## Demo Configuration

1. Under Project > ios-trello > Linking > Other Linker Flags,
Double-Click then click + to set flags
```
-ObjC
-all_load
```

2. Under Targets > ios-trello > Build Phases > Target Dependencies,
Click + and Choose items to add: 
* (ytoolkit > ytoolkit)


3. Under Targets > ios-trello > Build Phases > Compile Sources,
Double-click the following source files, and add the flag:
```
-fno-objc-arc
```

* All AFNetworking .m Sources    	(10 files)
* All ytoolkit .m library Sources		(11 files)
* Reachability.m

## Additional Frameworks and Libraries:
Under Targets > ios-trello > Build Phases > Link Binary with Libraries:
* IOS 5.1
 * SystemConfiguration
 * Security
* Workspace
 * libybase64.a
 * libybase64additions.a
 * libycocoaadditions.a from 'ycocoaadditions-iOS' target
 * libyoauth.a
 * libyoauthadditions.a

## Client Source Configuration

1. Go to [Trello Docs](https://trello.com/docs/) and generate an Application Key

2. Substitute your keys in the file TrelloClientCredentials.m

3. (See Demo): In TrelloLoginViewController.m, globally substitute Your_App_Name for ios4Trello.
(This will let your users know that your app is seeking authorization to access thier Trello account.)

## Keeping it real and live

Here's our [Trello Board](https://trello.com/board/ios-trello/4fc68e03d3e0f0166532f6e9) which tracks development and features of [ios-trello](https://trello.com/board/ios-trello/4fc68e03d3e0f0166532f6e9).

This library is mostly complete, but if you do find anything missing or not functioning as you would expect, please [let us know](https://trello.com/card/spot-a-bug-report-it/4fc68e03d3e0f0166532f6e9/1).

And by all means, pitch in. What would like to add to the project? Feature requests, pull-requests, tests, docs, examples are all welcome.

Peace!