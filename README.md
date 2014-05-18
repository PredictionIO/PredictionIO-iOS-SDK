#PredictionIO iOS SDK

##PredictionIO API 
See http://docs.prediction.io/current/apis/index.html for full documentation of API endpoints. (An iOS SDK specific client documentation  will be here soon).

##Demo App: The Food Predictor
The main functionality of the app is to show food recommendations. The app allows creation of multiple users, and makes it possible to switch between the users. For each user, we can perform different actions and therefore each user will have different custom recommendations. Selecting a user shows the top N recommended foods for each user.

The app has a list of all the food items and users can add new foods. On the first run, the items are all added to the local PredictionIO server. When a user selects one of the foods, it sends a “view” action to the item. The user can also give the food a rating, and make a conversion and the corresponding U2I actions are sent to the PredictionIO server.

###First time setup
* In `DemoApp/AppDelegate.m` set the API Key and API URL here:
```
self.client = [[PIOClient alloc]
                initWithAppKey: @"l7fdO5nw5N7djl8wpmfC2YyBm8nyMoWK5lPabRPd3LEZpq6ltnlpmm0Dqg5SyJ8o"
                apiURL: @"http://localhost:8000"];
```
* Create a recommendation engine in the PredictionIO admin app, and give it the name `item-rec`. This can be changed by editing the hardcoded name in `DemoApp/TopRecViewController.m` at 
```
 [client getItemRecTopNWithEngine: @"item-rec" uid: self.selectedUser n: 15 success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
```

###How to run the demo

1. Open `PredictionIO-iOS-SDK.xcodeproj`
2. Ensure your local PredictionIO server is up and running
3. Select the `DemoApp` scheme, and choose any iPhone simultator
4. Press the "Play" button or do `Product > Run`, and that's it.

Note that the data takes some time to train, so it may take a little while before you see data under the user recommendations section of the app.
