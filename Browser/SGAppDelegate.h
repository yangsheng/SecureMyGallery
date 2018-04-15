//
//  SGAppDelegate.h
//  Foxbrowser
//
//  Created by Asif Seraje on 27.06.12.
//
//
//  Copyright (c) 2012 Asif Seraje
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AppiraterDelegate.h"
#import <CoreData/CoreData.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <DropboxSDK/DropboxSDK.h>
#import "DBController.h"
#import "PGAlbumsController.h"
#import "PGADownloadsController.h"
#import "WizardPatternController.h"
#import "MFSideMenu.h"
#import "SettingsViewController.h"
#import "PGADownloadsController.h"
#import "KKPasscodeViewController.h"



#define DELEGATE ((SGAppDelegate*)[[UIApplication sharedApplication]delegate])


@class PGAlbumsController;
@class BrowserViewController;
@class WizardPatternController;
@class SettingsViewController;


@class SGBrowserViewController;
@protocol GAITracker, AppiraterDelegate;

@interface SGAppDelegate : UIResponder <UIApplicationDelegate, AppiraterDelegate,UIAlertViewDelegate,DBSessionDelegate, DBNetworkRequestDelegate,DBRestClientDelegate,KKPasscodeViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) SGBrowserViewController *browserViewController;
@property (strong, nonatomic) id<GAITracker> tracker;

- (BOOL)canConnectToInternet;

//Download
@property (nonatomic, strong)NSMutableArray *gdSelectedImeges;
@property (nonatomic, strong)NSMutableArray *dbSelectedImages;
@property (nonatomic, strong)NSString *folderName;
@property (nonatomic, strong) PGDataSource *pgDataSource;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (strong , nonatomic) DBRestClient *restClient;

// Photo Voult
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) PGAlbumsController *gallery;
@property (nonatomic, strong) WizardPatternController *pattern;
@property (nonatomic, strong) SettingsViewController *settings;
@property (nonatomic, strong) PGADownloadsController *downloads;
@property (nonatomic, strong) BrowserViewController *browser;
@property (nonatomic, strong) UINavigationController *photoNavigation;
@property (nonatomic, strong) UINavigationController *downloadNavigation;
@property (nonatomic, strong) UINavigationController *browserNavigation;
@property (nonatomic, strong) UINavigationController *patternNavigation;
@property (strong, nonatomic) MFSideMenuContainerViewController *slideContainer;
@property (strong,nonatomic)  UITabBarController *tabBarController;

//coredata
-(void) saveContext;
-(NSURL *)applicationDocumentsDirectory;

//Other
-(void) showPhotoGallery;

-(void) showPatternLock;
+ (ALAssetsLibrary *)defaultAssetsLibrary;
@property(nonatomic, strong) NSMutableArray *localViewControllersArray;

@end

extern SGAppDelegate *appDelegate;

FOUNDATION_EXPORT NSString *const kSGEnableStartpageKey;
FOUNDATION_EXPORT NSString *const kSGStartpageURLKey;
FOUNDATION_EXPORT NSString *const kSGOpenPagesInForegroundKey;
FOUNDATION_EXPORT NSString *const kSGSearchEngineURLKey;
FOUNDATION_EXPORT NSString *const kSGEnableHTTPStackKey;
FOUNDATION_EXPORT NSString *const kSGEnableAnalyticsKey;
