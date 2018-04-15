//
//  SGAppDelegate.m
//  Foxbrowser
//
//  Created by Asif Seraje on 27.06.12.
//
//
//  Copyright (c) 2012 Asif Seraje
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//


#import "SGAppDelegate.h"
#import "PGADownloadsController.h"
#import "NSStringPunycodeAdditions.h"
#import "SGTabsViewController.h"
#import "SGPageViewController.h"
#import "SGFavouritesManager.h"
//#import "UIFont+OpenSans.h"
#import "FXSyncStock.h"
#import "FXLoginViewController.h"
#import "DownloadManager.h"
#import "Reachability.h"
#import "Appirater.h"
#import "IBMainVC.h"
#import "KKPasscodeLock.h"
#import "DZNWebViewController.h"
#import "SlideViewController.h"
#import "RNRWebViewController.h"
#import "MapViewController.h"
#define APP_COLOR [UIColor colorWithRed:20.0/255.0 green:26.0/255.0 blue:32.0/255.0 alpha:1.0]
#define TAB_BAR_TINT_COLOR [UIColor colorWithRed:36.0/255.0 green:227.0/255.0 blue:255.0/255.0 alpha:1.0]
#define NAV_BAR_TINT_COLOR [UIColor colorWithRed:31.0/255.0 green:37.0/255.0 blue:47.0/255.0 alpha:1.0]
#define NAV_TINT_COLOR [UIColor colorWithRed:36.0/255.0 green:227.0/255.0 blue:255.0/255.0 alpha:1.0]



//#define DBAPP_KEY  @"5liyk6rqa99uvui"
//#define DBAPP_SECRET  @"0wllh2y0ikrsa6r"

#define BDAPP_KEYTEST @"5af0p8jgymj92vn"
#define DBAPP_SECRETTEST @"2e05mhq9vmedaum"



SGAppDelegate *appDelegate;
NSString *const kSGEnableStartpageKey = @"org.graetzer.enableStartpage";
NSString *const kSGStartpageURLKey = @"org.graetzer.startpageurl";
NSString *const kSGOpenPagesInForegroundKey = @"org.graetzer.tabs.foreground";
NSString *const kSGSearchEngineURLKey = @"org.graetzer.search";
NSString *const kSGEnableHTTPStackKey = @"org.graetzer.httpauth";
NSString *const kSGEnableAnalyticsKey = @"org.graetzer.analytics";

// Only used in the appdelegate
NSString *const kSGBackgroundedAtTimeKey = @"kSGBackgroundedAtTimeKey";
NSString *const kSGDidRunBeforeKey = @"kSGDidRunBeforeKey";

@implementation SGAppDelegate {
    Reachability *_reachability;
    UINavigationController *albumViewNav;
    int flagCount;
   
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize gallery = _gallery;
@synthesize pattern = _pattern;
@synthesize settings = _settings;
@synthesize browser = _browser;
@synthesize downloads = _downloads;
@synthesize photoNavigation = _photoNavigation;
@synthesize downloadNavigation = _downloadNavigation;
@synthesize browserNavigation = _browserNavigation;
@synthesize patternNavigation = _patternNavigation;
@synthesize localViewControllersArray;
@synthesize restClient;


- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    appDelegate = self;
    _reachability = [Reachability reachabilityForInternetConnection];
    [self evaluateDefaultSettings];
    
    /// DropBox
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hide"];

    
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    self.tabBarController = [[UITabBarController alloc]init];
    [self.tabBarController.tabBar setBarTintColor:NAV_BAR_TINT_COLOR];
    [self.tabBarController.tabBar setTintColor:NAV_TINT_COLOR];

    self.tabBarController.tabBar.translucent = NO;
    
    localViewControllersArray =
    [[NSMutableArray alloc] initWithCapacity:5];


    
    NSURL *URL = [NSURL URLWithString:@"http://www.google.com/"];
    
    DZNWebViewController *WVC = [[DZNWebViewController alloc] initWithURL:URL];
    //UINavigationController *NC = [[UINavigationController alloc] initWithRootViewController:WVC];
    
    WVC.supportedWebNavigationTools = DZNWebNavigationToolAll;
    WVC.supportedWebActions = DZNWebActionAll;
    WVC.showLoadingProgress = YES;
    WVC.allowHistory = YES;
    WVC.hideBarsWithGestures = YES;
    
    RNRWebViewController *RNRWVC = [[RNRWebViewController alloc]initWithNibName:@"RNRWebViewController" bundle:nil];
    
    
    //Gallery
    _gallery = [[PGAlbumsController alloc] initWithNibName: @"PGAlbumsController" bundle: nil];
    _downloads = [[PGADownloadsController alloc]initWithNibName:@"PGADownloadsController" bundle:nil];
    
    
    _photoNavigation = [[UINavigationController alloc] initWithRootViewController: _gallery];
    _downloadNavigation =[[UINavigationController alloc]initWithRootViewController:_downloads];
    _browserNavigation = [[UINavigationController alloc]initWithRootViewController:RNRWVC];
    

    
    
    [self.tabBarController.tabBar setTintColor:NAV_TINT_COLOR];
    _downloadNavigation.tabBarItem.title = @"Downloads";
    _photoNavigation.tabBarItem.title = @"Album";
    _browserNavigation.tabBarItem.title = @"Browser";
    //----------------------------------------------------------------------
    _downloadNavigation.tabBarItem.image = [UIImage imageNamed:@"download"];
    _downloadNavigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"download_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    _photoNavigation.tabBarItem.image = [UIImage imageNamed:@"album"];
    _photoNavigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"album_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    _browserNavigation.tabBarItem.image = [UIImage imageNamed:@"browser"];
    _browserNavigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"browser_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //-----------------------------------------------------------------------

    

    
    [localViewControllersArray addObject:_browserNavigation];
    [localViewControllersArray addObject:_photoNavigation];
    [localViewControllersArray addObject:_downloadNavigation];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.slideContainer = [MFSideMenuContainerViewController
                               containerWithCenterViewController:self.tabBarController                              leftMenuViewController:[SlideViewController instance]
                               rightMenuViewController:nil];
    }
    else
    {
    
        self.slideContainer = [MFSideMenuContainerViewController
                               containerWithCenterViewController:self.tabBarController                              leftMenuViewController:[SlideViewController instance]
                               rightMenuViewController:nil];
        
    }
    
    self.tabBarController.viewControllers = localViewControllersArray;
    self.tabBarController.view.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    [self.tabBarController setSelectedIndex:1];
    

    if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) {
        KKPasscodeViewController *vc = [[KKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
        vc.mode = KKPasscodeModeEnter;
        vc.delegate = self;
        [self.window setRootViewController:vc];
    }else{
        [self.window setRootViewController:self.slideContainer];

    }


    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"blankPage"];

//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"Font Family === %@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"Font Name ===  %@", name);
//        }
//    }
    
    //OpenSans-Bold
    //OpenSans
    //OpenSans-Semibold
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:BDAPP_KEYTEST
                            appSecret:DBAPP_SECRETTEST
                            root:kDBRootDropbox]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    dbSession.delegate = self;
    [DBSession setSharedSession:dbSession];
    [DBRequest setNetworkRequestDelegate:self];
    
 

    self.gdSelectedImeges = [[NSMutableArray alloc]init];
    self.dbSelectedImages = [[NSMutableArray alloc]init];
    self.pgDataSource = [[PGDataSource alloc]init];
    NSString *notificationName = @"dropBoxDownload";
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(downloadImageFileFromDropBox)
                                                name:notificationName
                                              object:nil];
    
    NSString *gdNotificationName = @"googleDriveDownload";
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(globalGoogleDriveDownload)
                                                name:gdNotificationName
                                              object:nil];
    

    [[UINavigationBar appearance]setBarTintColor:NAV_BAR_TINT_COLOR];
    [[UINavigationBar appearance]setTintColor:NAV_TINT_COLOR];

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
    shadow.shadowOffset = CGSizeMake(0, 0);
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar_img"]  forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"OpenSans-Semibold" size:17.0], NSFontAttributeName, nil]];
    
    

     flagCount = 0;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:
  @{
    NSForegroundColorAttributeName:[UIColor blackColor],
    NSFontAttributeName: [UIFont systemFontOfSize:12]
    }];
    
    //    [[UINavigationBar appearance]setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ];
    MapViewController *listingVC = [[MapViewController alloc] init];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:listingVC];
    [self.window.rootViewController presentViewController:navCon animated:YES completion:nil];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)didPasscodeEnteredCorrectly:(KKPasscodeViewController*)viewController{

    [self.window setRootViewController:self.slideContainer];
    
}

static int outstandingRequests;
- (void)networkRequestStarted
{
    outstandingRequests++;
    if (outstandingRequests == 1) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}
- (void)networkRequestStopped
{
    outstandingRequests--;
    if (outstandingRequests == 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //[Appirater appEnteredForeground:YES];
    // 0.5 delay as a workaround so that modal views work
//    [self performSelector:@selector(setupSync) withObject:nil afterDelay:0.5];
    
   if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) {
        KKPasscodeViewController *vc = [[KKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
        vc.mode = KKPasscodeModeEnter;
        vc.delegate = self;
        

        
        [self.window setRootViewController:vc];

    }
    else{
    
        [self.window setRootViewController:self.slideContainer];
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    self.window.rootViewController = nil;
   
    if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) {
        KKPasscodeViewController *vc = [[KKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
        vc.mode = KKPasscodeModeEnter;
        vc.delegate = self;
        
      
        [self.window setRootViewController:vc];
        
    }
    else{
        
        [self.window setRootViewController:self.slideContainer];
    }

   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //stop timers, threads, spinner animations, etc.
    // note the time we were suspended, so we can decide whether to do a refresh when we are resumed
    
    [[NSUserDefaults standardUserDefaults] setDouble:[[NSDate date] timeIntervalSince1970]
                                              forKey:kSGBackgroundedAtTimeKey];
    [self.browserViewController saveCurrentTabs];
//    [[GAI sharedInstance] dispatch];
    
    __block UIBackgroundTaskIdentifier identifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:identifier];
        identifier = UIBackgroundTaskInvalid;
    }];
    // Just wait 10 seconds to finish uploads
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), q, ^{
        if (identifier != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:identifier];
        }
    });
    self.window.rootViewController = nil;
    if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) {
        KKPasscodeViewController *vc = [[KKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
        vc.mode = KKPasscodeModeEnter;
        vc.delegate = self;
   
        [self.window setRootViewController:vc];
        
    }
    else{
        
        [self.window setRootViewController:self.slideContainer];
    }

}

- (void)applicationWillTerminate:(UIApplication *)application {
    //[self.browserViewController saveCurrentTabs];
}

- (UIViewController *)application:(UIApplication *)application
viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
                            coder:(NSCoder *)coder {
    
    NSString *last = [identifierComponents lastObject];
    if ([last isEqualToString:NSStringFromClass([SGTabsViewController class])]
        || [last isEqualToString:NSStringFromClass([SGPageViewController class])] ) {
        return _browserViewController;
    }
    return nil;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    return YES;
}

#pragma mark-DropBox

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    if ([[DBSession sharedSession] handleOpenURL:url]) {
//        if ([[DBSession sharedSession] isLinked]) {
//            NSLog(@"App linked successfully!");
//            // At this point you can start making API calls
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"DropboxAppLinked" object:nil] ;
//        } else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideViewController" object:nil] ;
//        }
//        return YES;
//    }
//    // Add whatever other url handling code your app requires here
//    return NO;
//}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSString *urlS = url.resourceSpecifier;
    if ([url.scheme isEqualToString:@"foxbrowser"]) {
        urlS = [NSString stringWithFormat:@"http:%@", urlS];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnicodeString:urlS]];
        [self.browserViewController addTabWithURLRequest:request title:sourceApplication];
        return YES;
    } else if ([url.scheme isEqualToString:@"foxbrowsers"]) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnicodeString:urlS]];
        [self.browserViewController addTabWithURLRequest:request title:sourceApplication];
        return YES;
    } else if ([url.scheme hasPrefix:@"http"] || [url.scheme hasPrefix:@"https"]) {
        [self.browserViewController addTabWithURLRequest:[NSMutableURLRequest requestWithURL:url] title:sourceApplication];
        return YES;
    }
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DropboxAppLinked" object:nil] ;
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideViewController" object:nil] ;
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;

}
- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId
{

    NSLog(@"Auth Failed");
}


- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    NSString* version = [[NSBundle mainBundle].infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];
    NSString* storedVersion = [coder decodeObjectForKey: UIApplicationStateRestorationBundleVersionKey];
    return [version isEqualToString:storedVersion];
}



#pragma mark - Methods

- (void)setupSync {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isReady = [[FXSyncStock sharedInstance] hasUserCredentials];
    if (isReady) {
        
        //check to see if we were suspended for 15 minutes or more, and refresh if true
        double slept = [defaults doubleForKey:kSGBackgroundedAtTimeKey];
        double now = [[NSDate date] timeIntervalSince1970];
        if ((now - slept) >= 60 * 15) {
            [[FXSyncStock sharedInstance] restock];
        }
    } else {
        
        // Only show this at start once
        BOOL didRunBefore = [defaults boolForKey:kSGDidRunBeforeKey];
        if (!didRunBefore) {
            [defaults setBool:YES forKey:kSGDidRunBeforeKey];
            [defaults synchronize];
            
            FXLoginViewController* login = [FXLoginViewController new];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:login];
            navController.modalPresentationStyle = UIModalPresentationFormSheet;
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.browserViewController presentViewController:navController animated:YES completion:NULL];
        }
    }
}

- (void)evaluateDefaultSettings {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    id mutable = [NSMutableDictionary dictionary];
    id settings = [NSDictionary dictionaryWithContentsOfFile: [path stringByAppendingPathComponent:@"Root.plist"]];
    id specifiers = settings[@"PreferenceSpecifiers"];
    for (id prefItem in specifiers) {
        id key = prefItem[@"Key"];
        id value = prefItem[@"DefaultValue"];
        if ( key && value ) {
            mutable[key] = value;
        }
    }
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def registerDefaults:mutable];
    [def synchronize];
}

- (BOOL) canConnectToInternet; {
    return [_reachability isReachable];
}


#pragma mark New Photo Voult
#pragma mark - Window switcher

-(void) showPhotoGallery {
    
//    self.photoNavigation.navigationBar.barTintColor = [UIColor colorWithRed:(20/255.0) green:(20/255.0) blue:(20/255.0) alpha:1] ;
//    
//    [self.photoNavigation.navigationBar
//     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    self.photoNavigation.navigationBar.translucent = NO;
//    
//    
//    self.slideContainer = [MFSideMenuContainerViewController
//                           containerWithCenterViewController:self.photoNavigation                               leftMenuViewController:[SlideViewController instance]
//                           rightMenuViewController:nil];
//    
//    
//    
//    
//    self.window.tintColor=[UIColor whiteColor];
//    self.slideContainer.panMode = 0;
//    
//    
//    self.slideContainer.menuSlideAnimationEnabled = NO;
//    //  self.navigationcontroller = [[UINavigationController alloc] initWithRootViewController:self.slideContainer];
//    
//    self.window.rootViewController = self.slideContainer;
}

-(void) showPatternLock {
   // self.window.rootViewController = self.patternNavigation;
}

-(void) resumePatternLock {
    //Get current state
//    bool wizard = [[NSUserDefaults standardUserDefaults] boolForKey: @"wizardInProgress"];
//    bool pattern = [[NSUserDefaults standardUserDefaults] objectForKey: @"definedPattern"] != nil;
//    
//    //Show gallery or lockscreen
//    if (wizard == TRUE || pattern == FALSE)
//    {
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey: @"touch_btn"];
//        
//        [self showPhotoGallery];
//    }
//    else
//    {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"touch_btn"];
//        
//        [self showPatternLock];
//        
//    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Force reconfiguration
    //[self.gallery switchToConfiguration];
}

#pragma mark - Core Data stack
#pragma mark - KCHAlbum Picker

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static ALAssetsLibrary *assetsLibrary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        // Workaround for triggering ALAssetsLibraryChangedNotification
        [assetsLibrary writeImageToSavedPhotosAlbum:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) { }];
    });
    
    return assetsLibrary;
}


- (NSURL *)applicationDocumentsDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PhotoVault" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DemoCoreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
#pragma mark - DropBox


- (DBRestClient *)restClient
{
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
{
    
    
    [self moveItemAtFolder:destPath];
    NSString *notificationName = @"refreshDownLoad";
    [[NSNotificationCenter defaultCenter]postNotificationName:notificationName object:nil];
    NSLog(@"%i",(int)self.dbSelectedImages.count);
    int count = (int)self.dbSelectedImages.count;
    if (flagCount<count-1){
        ++flagCount;
    }
    else{
    
        [self.dbSelectedImages removeAllObjects];
    }
    

    
}
- (void)downloadImageFileFromDropBox{
    
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    //NSLog(@"SELECTED IMAGES === %@ FOLDER NAME===%@ TOTAL COUNT %i",self.dbSelectedImages,self.folderName,(int)self.dbSelectedImages.count);
    NSArray *selectedArray = [self.dbSelectedImages mutableCopy];
    int totalCount = (int)self.dbSelectedImages.count;
    for (int i = 0; i<totalCount; i++){
        DBMetadata *metadata = [selectedArray objectAtIndex:i];
        NSLog(@"%@",metadata.path);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        
        NSString* fPath = [documentsPath stringByAppendingPathComponent:
                           @"ustadji.jpg" ];
        
        NSLog(@"First Final Path ------->>>>>%@",fPath);
        
        [self.restClient loadFile:metadata.path intoPath:fPath];
        
    }
    //[self.dbSelectedImages removeAllObjects];

}


#pragma mark-Google Drive
- (void)globalGoogleDriveDownload{

//    DownloadManager *gdManager = [[DownloadManager alloc]init];
//    gdManager.gdSelectedImages = self.gdSelectedImeges;
//    gdManager.folderName = self.folderName;
//    [gdManager downloadImageFileFromGoogleDrive];
}

-(void)moveItemAtFolder:(NSString *)filePath{
    NSLog(@"%@",filePath);
    UIImage *downloadedImage = [UIImage imageWithContentsOfFile: filePath];
    NSData *imageData = UIImageJPEGRepresentation(downloadedImage, 1);
    [imageData writeToFile:filePath atomically:YES];
    
    
    NSLog(@"%@",downloadedImage);
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
    [workingDictionary setObject:ALAssetTypePhoto forKey:@"UIImagePickerControllerMediaType"];
    [workingDictionary setObject:downloadedImage forKey:@"UIImagePickerControllerOriginalImage"];
    [workingDictionary setObject:filePath forKey:@"UIImagePickerControllerReferenceURL"];
    
    [returnArray addObject:workingDictionary];
    
    [self.pgDataSource importArrayDictionary:returnArray ToFolder:self.folderName];
    //---------------------------------------------------------------------------------------------------------
    //   ******** [self.fileManager removeItemAtPath:filePath error:nil];//take care about this path's content after downloading the file........*********
    //---------------------------------------------------------------------------------------------------------
    
    
    
}

#pragma mark - AppiraterDelegate
- (void)appiraterDidDeclineToRate:(Appirater *)appirater {
//    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Rating"
//                                                               action:@"Decline"
//                                                                label:nil
//                                                                value:nil] build]];
}

- (void)appiraterDidOptToRate:(Appirater *)appirater {
//    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Rating"
//                                                               action:@"Rate"
//                                                                label:nil
//                                                                value:nil] build]];
}

- (void)appiraterDidOptToRemindLater:(Appirater *)appirater {
//    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Rating"
//                                                               action:@"Remind Later"
//                                                                label:nil
//                                                                value:nil] build]];
}

@end
