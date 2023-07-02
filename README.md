ios-trello (v0.1) 
==========

ARCHIVED PROJECT

An iOS (Objective-C) API Wrapper for Trello

Trello is a free, collaborative task management web tool that can be used for anything. Really!
Check it out [here](http://www.trello.com). This project contains sources to enable you to build Trello into your native iOS projects.
It is basically an API wrapper that makes it easy for your app to login and send GET, PUT, POST and DELETE HTTP signals to your available and authorized Trello boards.

Load up the included iPad demo/test project in your simulator, and take ios4trello for a spin. (See [Client Source Configuration](https://github.com/vincemansel/ios-trello/edit/master/README.md#client-source-configuration) below to obtain keys!).

The Trello API Reference is [here](https://trello.com/docs/api/index.html).

The demo is based on the Trello API, AFNetworking (for transport) and ytoolkit/NSMutableURLRequest (for basic OAuth). You can use any
OAuth library you want, but ios-trello is closely tied to AFNetworking through a few Macros.

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
    NSLog(@"Name: %@ %@", [JSON valueForKeyPath:@"name"], [JSON valueForKeyPath:@"memberships"]);
    NSLog(@"JSON: %@", JSON);
     
    if (YIS_INSTANCE_OF(JSON, NSArray)) {
        [self.boardList removeAllObjects];
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

Assuming you have those listed in a tableView, here is how to access one board and list the cards on that board.


```
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Board = %@", [self.boardList objectAtIndex:indexPath.row]);
    
    [[VMTrelloApiClient sharedSession] 
     get1Boards:[self.boardIDs objectAtIndex:indexPath.row]
     success:^(id JSON) {
         NSLog(@"Board:JSON = %@", JSON);
     } failure:^(NSError *error) {
         NSLog(@"Board JSON Error: %@", error.description);
     }];
    
    [[VMTrelloApiClient sharedSession] 
     get1BoardsCards:[self.boardIDs objectAtIndex:indexPath.row]
     success:^(id JSON) {
         NSLog(@"BoardCards:JSON = %@", JSON);
     } failure:^(NSError *error) {
         NSLog(@"BoardCards JSON Error: %@", error.description);
     }];
}
```


Here's how to get going...
======

## Additional Sources Required:

* Reachability (Apple)
* AFNetworking (http://github.com/AFNetworking/AFNetworking)

## Dependencies:

* ytoolkit (OAuthv1) (http://github.com/sprhawk/ytoolkit)
 * (Note: for expendiency, delete all test directories, SenTesting Framework and ASIHTTPRequest files from ytoolkit)
 * (If you are not linking against the static library, you may also need to fix some fix some imports: i.e. change \<ytoolkit/ydefines.h\> to "ydefines.h" ... etc. Let the compiler be your guide ;)

## Demo Configuration

The included Xcode Project is an iPad app that exercises the Trello API.

1. Under Project > ios-trello > Linking > Other Linker Flags,
Double-Click then click + to set flags
```
-ObjC
-all_load
```

2. Under Targets > ios4trello > Build Phases > Target Dependencies,
Click + and Choose items to add: 
 * (ytoolkit > ytoolkit)

3. Under Targets > ios4trello > Build Settings > Search Paths > Header Search Paths, enter:
```
{BUILT_PRODUCTS_DIR}/usr/local/include
```

4. Under Targets > ios4trello > Build Phases > Compile Sources,
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

## Client Source Configuration

0. If you haven't already, create a Trello account.

1. Go to [Trello Docs](https://trello.com/docs/) and generate an Application Key

2. Edit/Create the file  TrelloClientCredentials.m and substitute your keys.

3. (See Demo): In TrelloLoginViewController.m, globally substitute Your_App_Name for ios4Trello.
(This will let your users know that your app is seeking authorization to access thier Trello account.)

## Keeping it real and live

Here's our [Trello Board](https://trello.com/board/ios-trello/4fc68e03d3e0f0166532f6e9) which tracks development and features of [ios-trello](https://trello.com/board/ios-trello/4fc68e03d3e0f0166532f6e9).

This library is not complete (see status below), so if you do find anything missing or not functioning as you would expect, please [let us know](https://trello.com/card/spot-a-bug-report-it/4fc68e03d3e0f0166532f6e9/1).

And by all means, pitch in. What would you like to add to the project? Feature requests, pull-requests, tests, docs, examples are all welcome.

Peace!

## Roadmap/Implementation Status

The Trello API (Beta) is functional with on-going development and is fairly complete (as far as I know). This is the map/status for ios-trello.

* 0.1 - *Basic* read-only API, create board, edit board description, create list, create card
* 0.2 - support additional read-only methods (i.e. all GET methods)
* 0.3 - support additional, create, update and delete

<table>
  <tr><th>Method</th><th>Version</th></tr>
  
<tr><th colspan="2">Actions</th></tr>
<tr><td>GET /1/actions/[action_id]                      </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>GET /1/actions/[action_id]/[field]              </td><td>0.2</td></tr>  
<tr><td>GET /1/actions/[action_id]/board                </td><td>0.2</td></tr>  
<tr><td>GET /1/actions/[action_id]/board/[field]        </td><td>0.2</td></tr>  
<tr><td>GET /1/actions/[action_id]/card                 </td><td>0.2</td></tr>  
<tr><td>GET /1/actions/[action_id]/card/[field]         </td><td>0.2</td></tr>  
<tr><td>GET /1/actions/[action_id]/list                 </td><td>0.2</td></tr>  
<tr><td>GET /1/actions/[action_id]/list/[field]         </td><td>0.2</td></tr>  
<tr><td>GET /1/actions/[action_id]/member               </td><td>0.2</td></tr>  
<tr><td>GET /1/actions/[action_id]/member/[field]       </td><td>0.2</td></tr>  
<tr><td>GET /1/actions/[action_id]/memberCreator        </td><td>0.2</td></tr>  
<tr><td>GET /1/actions/[action_id]/memberCreator/[field]</td><td>0.2</td></tr>  
<tr><td>GET /1/actions/[action_id]/organization         </td><td>0.2</td></tr>  
<tr><td>GET /1/actions/[action_id]/organization/[field] </td><td>0.2</td></tr>  

<tr><th colspan="2">Boards</th></tr>
<tr><td>GET /1/boards/[board_id]                       </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>GET /1/boards/[board_id]/[field]               </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>GET /1/boards/[board_id]/actions               </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>GET /1/boards/[board_id]/cards                 </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>GET /1/boards/[board_id]/cards/[filter]        </td><td>0.2</td></tr>
<tr><td>GET /1/boards/[board_id]/cards/[idCard]        </td><td>0.2</td></tr>
<tr><td>GET /1/boards/[board_id]/checklists            </td><td>0.2</td></tr>
<tr><td>GET /1/boards/[board_id]/lists                 </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>GET /1/boards/[board_id]/lists/[filter]        </td><td>0.2</td></tr>
<tr><td>GET /1/boards/[board_id]/members               </td><td>0.2</td></tr>
<tr><td>GET /1/boards/[board_id]/members/[filter]      </td><td>0.2</td></tr>
<tr><td>GET /1/boards/[board_id]/membersInvited        </td><td>0.2</td></tr>
<tr><td>GET /1/boards/[board_id]/membersInvited/[field]</td><td>0.2</td></tr>
<tr><td>GET /1/boards/[board_id]/myPrefs               </td><td>0.2</td></tr>
<tr><td>GET /1/boards/[board_id]/organization          </td><td>0.2</td></tr>
<tr><td>GET /1/boards/[board_id]/organization/[field]  </td><td>0.2</td></tr>
<tr><td>PUT /1/boards/[board_id]                       </td><td>0.3</td></tr>
<tr><td>PUT /1/boards/[board_id]/closed                </td><td>0.3</td></tr>
<tr><td>PUT /1/boards/[board_id]/desc                  </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>PUT /1/boards/[board_id]/name                  </td><td>0.1.1 - IMPLEMENTED</td></tr>
<tr><td>POST /1/boards                                 </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>POST /1/boards/[board_id]/checklists           </td><td>0.3</td></tr>
<tr><td>POST /1/boards/[board_id]/lists                </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>POST /1/boards/[board_id]/myPrefs              </td><td>0.3</td></tr>

<tr><th colspan="2">Cards</th></tr>
<tr><td>GET /1/cards/[card_id]                             </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>GET /1/cards/[card_id]/[field]                     </td><td>0.2</td></tr>
<tr><td>GET /1/cards/[card_id]/actions                     </td><td>0.2</td></tr>
<tr><td>GET /1/cards/[card_id]/attachments                 </td><td>0.2</td></tr>
<tr><td>GET /1/cards/[card_id]/board                       </td><td>0.2</td></tr>
<tr><td>GET /1/cards/[card_id]/board/[field]               </td><td>0.2</td></tr>
<tr><td>GET /1/cards/[card_id]/checkItemStates             </td><td>0.2</td></tr>
<tr><td>GET /1/cards/[card_id]/checklists                  </td><td>0.2</td></tr>
<tr><td>GET /1/cards/[card_id]/list                        </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>GET /1/cards/[card_id]/list/[field]                </td><td>0.2</td></tr>
<tr><td>GET /1/cards/[card_id]/members                     </td><td>0.2</td></tr>
<tr><td>PUT /1/cards/[card_id]                             </td><td>0.3</td></tr>
<tr><td>PUT /1/cards/[card_id]/closed                      </td><td>0.3</td></tr>
<tr><td>PUT /1/cards/[card_id]/desc                        </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>PUT /1/cards/[card_id]/due                         </td><td>0.3</td></tr>
<tr><td>PUT /1/cards/[card_id]/idList                      </td><td>0.3</td></tr>
<tr><td>PUT /1/cards/[card_id]/name                        </td><td>0.3</td></tr>
<tr><td>POST /1/cards                                      </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>POST /1/cards/[card_id]/actions/comments           </td><td>0.3</td></tr>
<tr><td>POST /1/cards/[card_id]/attachments                </td><td>0.3</td></tr>
<tr><td>POST /1/cards/[card_id]/checklists                 </td><td>0.3</td></tr>
<tr><td>POST /1/cards/[card_id]/labels                     </td><td>0.3</td></tr>
<tr><td>POST /1/cards/[card_id]/members                    </td><td>0.3</td></tr>
<tr><td>POST /1/cards/[card_id]/membersVoted               </td><td>0.3</td></tr>
<tr><td>DELETE /1/cards/[card_id]                          </td><td>0.1.1 - IMPLEMENTED</td></tr>
<tr><td>DELETE /1/cards/[card_id]/checklists/[idChecklist] </td><td>0.3</td></tr>
<tr><td>DELETE /1/cards/[card_id]/labels/[color]           </td><td>0.3</td></tr>
<tr><td>DELETE /1/cards/[card_id]/members/[idMember]       </td><td>0.3</td></tr>
<tr><td>DELETE /1/cards/[card_id]/membersVoted/[idMember]  </td><td>0.3</td></tr>

<tr><th colspan="2">Checklists</th></tr>
<tr><td>GET /1/checklists/[checklist_id]                                      </td><td>0.2</td></tr>
<tr><td>GET /1/checklists/[checklist_id]/[field]                              </td><td>0.2</td></tr>
<tr><td>GET /1/checklists/[checklist_id]/board                                </td><td>0.2</td></tr>
<tr><td>GET /1/checklists/[checklist_id]/board/[field]                        </td><td>0.2</td></tr>
<tr><td>GET /1/checklists/[checklist_id]/cards                                </td><td>0.2</td></tr>
<tr><td>GET /1/checklists/[checklist_id]/cards/[filter]                       </td><td>0.2</td></tr>
<tr><td>GET /1/checklists/[checklist_id]/checkItems                           </td><td>0.2</td></tr>
<tr><td>PUT /1/checklists/[checklist_id]                                      </td><td>0.3</td></tr>
<tr><td>PUT /1/checklists/[checklist_id]/name                                 </td><td>0.3</td></tr>
<tr><td>POST /1/checklists                                                    </td><td>0.3</td></tr>
<tr><td>POST /1/checklists/[checklist_id]/checkItems                          </td><td>0.3</td></tr>
<tr><td>DELETE /1/checklists/[checklist_id]/checkItems/[idCheckItem]          </td><td>0.3</td></tr>

<tr><th colspan="2">Lists</th></tr>
<tr><td>GET /1/lists/[list_id]                                                </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>GET /1/lists/[list_id]/[field]                                        </td><td>0.2</td></tr>
<tr><td>GET /1/lists/[list_id]/actions                                        </td><td>0.2</td></tr>
<tr><td>GET /1/lists/[list_id]/board                                          </td><td>0.2</td></tr>
<tr><td>GET /1/lists/[list_id]/board/[field]                                  </td><td>0.2</td></tr>
<tr><td>GET /1/lists/[list_id]/cards                                          </td><td>0.2</td></tr>
<tr><td>GET /1/lists/[list_id]/cards/[filter]                                 </td><td>0.2</td></tr>
<tr><td>PUT /1/lists/[list_id]                                                </td><td>0.3</td></tr>
<tr><td>PUT /1/lists/[list_id]/closed                                         </td><td>0.3</td></tr>
<tr><td>PUT /1/lists/[list_id]/name                                           </td><td>0.1.1 - IMPLEMENTED</td></tr>
<tr><td>POST /1/lists                                                         </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>POST /1/lists/[list_id]/cards                                         </td><td>0.1 - IMPLEMENTED</td></tr>

<tr><th colspan="2">Members</th></tr>
<tr><td>GET /1/members/[member_id or username]                                </td><td>0.2</td></tr>
<tr><td>GET /1/members/[member_id or username]/[field]                        </td><td>0.2</td></tr>
<tr><td>GET /1/members/[member_id or username]/actions                        </td><td>0.2</td></tr>
<tr><td>GET /1/members/[member_id or username]/boards                         </td><td>0.1 - IMPLEMENTED</td></tr>
<tr><td>GET /1/members/[member_id or username]/boards/[filter]                </td><td>0.1.1 - IMPLEMENTED</td></tr>
<tr><td>GET /1/members/[member_id or username]/boardsInvited                  </td><td>0.2</td></tr>
<tr><td>GET /1/members/[member_id or username]/boardsInvited/[field]          </td><td>0.2</td></tr>
<tr><td>GET /1/members/[member_id or username]/cards                          </td><td>0.2</td></tr>
<tr><td>GET /1/members/[member_id or username]/cards/[filter]                 </td><td>0.2</td></tr>
<tr><td>GET /1/members/[member_id or username]/notifications                  </td><td>0.2</td></tr>
<tr><td>GET /1/members/[member_id or username]/notifications/[filter]         </td><td>0.2</td></tr>
<tr><td>GET /1/members/[member_id or username]/organizations                  </td><td>0.2</td></tr>
<tr><td>GET /1/members/[member_id or username]/organizations/[filter]         </td><td>0.2</td></tr>
<tr><td>GET /1/members/[member_id or username]/organizationsInvited           </td><td>0.2</td></tr>
<tr><td>GET /1/members/[member_id or username]/organizationsInvited/[field]   </td><td>0.2</td></tr>
<tr><td>PUT /1/members/[member_id or username]                                </td><td>0.3</td></tr>
<tr><td>PUT /1/members/[member_id or username]/bio                            </td><td>0.3</td></tr>
<tr><td>PUT /1/members/[member_id or username]/fullName                       </td><td>0.3</td></tr>
<tr><td>PUT /1/members/[member_id or username]/initials                       </td><td>0.3</td></tr>

<tr><th colspan="2">Notifications</th></tr>
<tr><td>GET /1/notifications/[notification_id]                                </td><td>0.2</td></tr>
<tr><td>GET /1/notifications/[notification_id]/[field]                        </td><td>0.2</td></tr>
<tr><td>GET /1/notifications/[notification_id]/board                          </td><td>0.2</td></tr>
<tr><td>GET /1/notifications/[notification_id]/board/[field]                  </td><td>0.2</td></tr>
<tr><td>GET /1/notifications/[notification_id]/card                           </td><td>0.2</td></tr>
<tr><td>GET /1/notifications/[notification_id]/card/[field]                   </td><td>0.2</td></tr>
<tr><td>GET /1/notifications/[notification_id]/list                           </td><td>0.2</td></tr>
<tr><td>GET /1/notifications/[notification_id]/list/[field]                   </td><td>0.2</td></tr>
<tr><td>GET /1/notifications/[notification_id]/member                         </td><td>0.2</td></tr>
<tr><td>GET /1/notifications/[notification_id]/member/[field]                 </td><td>0.2</td></tr>
<tr><td>GET /1/notifications/[notification_id]/memberCreator                  </td><td>0.2</td></tr>
<tr><td>GET /1/notifications/[notification_id]/memberCreator/[field]          </td><td>0.2</td></tr>
<tr><td>GET /1/notifications/[notification_id]/organization                   </td><td>0.2</td></tr>
<tr><td>GET /1/notifications/[notification_id]/organization/[field]           </td><td>0.2</td></tr>

<tr><th colspan="2">Organizations</th></tr>
<tr><td>GET /1/organizations/[org_id or name]                                 </td><td>0.2</td></tr>
<tr><td>GET /1/organizations/[org_id or name]/[field]                         </td><td>0.2</td></tr>
<tr><td>GET /1/organizations/[org_id or name]/actions                         </td><td>0.2</td></tr>
<tr><td>GET /1/organizations/[org_id or name]/boards                          </td><td>0.2</td></tr>
<tr><td>GET /1/organizations/[org_id or name]/boards/[filter]                 </td><td>0.2</td></tr>
<tr><td>GET /1/organizations/[org_id or name]/members                         </td><td>0.2</td></tr>
<tr><td>GET /1/organizations/[org_id or name]/members/[filter]                </td><td>0.2</td></tr>
<tr><td>PUT /1/organizations/[org_id or name]                                 </td><td>0.3</td></tr>
<tr><td>PUT /1/organizations/[org_id or name]/desc                            </td><td>0.3</td></tr>
<tr><td>PUT /1/organizations/[org_id or name]/displayName                     </td><td>0.3</td></tr>
<tr><td>PUT /1/organizations/[org_id or name]/name                            </td><td>0.3</td></tr>
<tr><td>PUT /1/organizations/[org_id or name]/website                         </td><td>0.3</td></tr>
<tr><td>POST /1/organizations                                                 </td><td>0.3</td></tr>
<tr><td>DELETE /1/organizations/[org_id or name]                              </td><td>0.3</td></tr>

<tr><th colspan="2">Tokens</th></tr>
<tr><td>GET /1/tokens/[token]                                                 </td><td>0.2</td></tr>
<tr><td>GET /1/tokens/[token]/[field]                                         </td><td>0.2</td></tr>
<tr><td>GET /1/tokens/[token]/member                                          </td><td>0.2</td></tr>
<tr><td>GET /1/tokens/[token]/member/[field]                                  </td><td>0.2</td></tr>
<tr><td>DELETE /1/tokens/[token]                                              </td><td>0.1 - IMPLEMENTED</td></tr>


<tr><th colspan="2">Types</th></tr>
<tr><td>GET /1/types/[id]                                                     </td><td>0.2</td></tr>

</table>

## Credits

ios-trello and ios4trello were developed by Vince Mansel (http://github.com/vincemansel)

Additional sources are attributed to the following projects.

* AFNetworking
* ytoolkit
* Roadmap Table Layout (thanks trello4j)

Thanks, Vince

