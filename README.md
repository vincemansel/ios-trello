# ios-trello
==========

An iOS (Objective-C) Wrapper for Trello

Additional Sources Required:

Reachability (Apple)
AFNetworking (https://github.com/AFNetworking/AFNetworking.git)

Dependencies:

ytoolkit (OAuthv1) (https://github.com/sprhawk/ytoolkit.git)
(delete all test sources)

Additional XCode Frameworks:

SystemConfiguration
MobileCoreServices

Demo Configuration

1. Under Project > ios-trello > Linking > Other Linker Flags,
Double-Click then click + to set flags
```
-Objc
-all_load
```

2. Under Targets > ios-trello > Build Phases > Target Dependencies,
Click + and Choose items to add:
(ytoolkit)
ybase64-iOS
ybase64additions-iOS
ycocoaadditions-iOS
yoauth-iOS
yoauthadditions-iOS

3. Under Targets > ios-trello > Build Phases > Compile Sources,
Double-click the following source files, and add the flag:
```
-fno-objc-arc
```

All AFNetworking .m Sources  		(10 files)
All ytoolkit .m library Sources		(11 files)
Reachability.m


4. 3. Under Targets > ios-trello > Build Phases > Link Binary with Libraries:


5. Go to [Trello Docs](https://trello.com/docs/) and generate an Application Key


6. Substitute your keys in the file TrelloClientCredentials.m



Here our [Trello Board](https://trello.com/board/ios-trello/4fc68e03d3e0f0166532f6e9) which tracks development and features of [ios-trello](https://trello.com/board/ios-trello/4fc68e03d3e0f0166532f6e9).



This library is mostly complete, if you do find anything missing or not functioning as you expect it to, please [let us know](https://trello.com/card/spot-a-bug-report-it/4fc68e03d3e0f0166532f6e9/1).