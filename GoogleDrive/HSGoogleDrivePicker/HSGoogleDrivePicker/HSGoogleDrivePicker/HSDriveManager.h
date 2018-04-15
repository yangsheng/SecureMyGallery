//
//  GDriveManager.h
//  gdrive
//
//  Created by Rob Jonson on 13/10/2015.
//  Copyright © 2015 HobbyistSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTLDrive.h"
#import "GTLDriveFile+HS.h"
#import "GTMHTTPFetcher.h"

@interface HSDriveManager : NSObject

- (instancetype)initWithId:(NSString*)clientId secret:(NSString*)secret;

/** returns auth view if it is required. Returns NULL if user is logged in **/
- (UIViewController*)authorisationViewController;

/** runs a fetch with the current search settings. Cancels any outstanding fetch **/
- (void)fetchFilesWithCompletionHandler:(void (^)(GTLServiceTicket *ticket, GTLDriveFileList *fileList, NSError *error))handler;

/** If the download completes succesfully, then the completion handler will be called with NULL for the error 
 returns GTMHTTPFetcher - this can be used to monitor download progress.
 **/
-(GTMHTTPFetcher*)downloadFile:(GTLDriveFile*)file toPath:(NSString*)path withCompletionHandler:(void (^)(NSError *error))handler;

-(void)signOut;

/** if No, shows 'my files'. Default is NO **/
@property (assign) BOOL sharedWithMe;
/** initially 'root'. Ignored if sharedWithMe is selected **/
@property (retain) NSString *folderId;
/** Default is NO **/
@property (assign) BOOL showTrashed;
/** Default is 1000 **/
@property (assign) NSInteger maxResults;
/** Default is YES. This is not recommended by Google, but I don't want to implement multi-page logic **/
@property (assign) BOOL autoFetchPages;


@end
