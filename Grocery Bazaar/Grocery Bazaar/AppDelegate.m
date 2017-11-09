//
//  AppDelegate.m
//  Grocery Bazaar
//
//  Created by NetprophetsMAC on 10/12/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
       if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]) {
           [CommonFunction stroeBoolValueForKey:isCartApiHIt withBoolValue:false];
           [self hitApiForCartItems];
           RearViewController *rearViewController = [[RearViewController alloc]initWithNibName:@"RearViewController" bundle:nil];
           SWRevealViewController *mainRevealController;
           
           HomeViewController *frontViewController = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
           mainRevealController = [[SWRevealViewController alloc]initWithRearViewController:rearViewController frontViewController:frontViewController];
           mainRevealController.delegate = self;
           mainRevealController.view.backgroundColor = [UIColor blackColor];
           UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainRevealController];
           ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = nav;
    }else{
        LoginViewController* vc;
        vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        _window.rootViewController = vc;

    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)hitApiForCartItems{
    if ([ CommonFunction reachability]) {
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
        
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_CART_ITEMS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
                    [CommonFunction stroeBoolValueForKey:isCartApiHIt withBoolValue:true];
                    NSArray *tempAray = [responseObj valueForKey:@"cart"];
                    [[CartItem sharedInstance].myDataArray removeAllObjects];
                    [tempAray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        CartItem* productObj = [[CartItem alloc] init  ];
                        
                        [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                            [productObj setValue:[CommonFunction checkForNull:obj] forKey:(NSString *)key];
                        }];
                        productObj.stock = @"5";
                        [[CartItem sharedInstance].myDataArray addObject:productObj];
                    }];
                   
                }
                
            }
            
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Grocery_Bazaar"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
