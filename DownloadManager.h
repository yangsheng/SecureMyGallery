//
//  DownloadManager.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/26/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTLDrive.h"
#import <DropboxSDK/DropboxSDK.h>
@class DownloadManager;
@protocol DownloadManagerDelegate <NSObject>

- (void)dbDidFinishDownloadingFiles:(DownloadManager *)downloadManager;
- (void)gdDidFinishDownloadingFiles:(DownloadManager *)downloadManager;

@end


@interface DownloadManager : NSObject<DBRestClientDelegate>

@property (nonatomic, weak) id<DownloadManagerDelegate> dlDelegate;


@property (nonatomic, strong)NSString *folderName;
@property (nonatomic, strong)NSMutableArray *dbSelectedImages;
@property (nonatomic, strong)NSArray *gdSelectedImages;
@property (nonatomic, strong) PGDataSource *pgDataSource;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, retain) GTLServiceDrive *driveService;

@property (strong , nonatomic) DBRestClient *restClient;
@property (nonatomic) BOOL isLinked;

+ (id)sharedManager;
- (void)downloadImageFileFromGoogleDrive;
- (void)downloadImageFileFromDropBox;
- (void)setDrobBoxSelectedImageArray:(NSArray *)imageArray withFolderName:(NSString *)folderN;
- (void)setGoogleDriveSelectedImageArray:(NSArray *)imageArray withFolderName:(NSString *)folderN;

@end
