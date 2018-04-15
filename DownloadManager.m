//
//  DownloadManager.m
//  Foxbrowser
//
//  Created by Asif Seraje on 1/26/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "DownloadManager.h"
#import "PGDataSource.h"
#import "GoogleDriveManager.h"
#import "GTMOAuth2ViewControllerTouch.h"

static NSString *const kKeychainItemName = @"My App";
static NSString *const kClientId = @"861941523810-lfd2q6ss0uni2a3gd5ve7rc45090u7ej.apps.googleusercontent.com";
static NSString *const kClientSecret = @"ShJN0ZuUNUceWkWnOnDiRNvr";

@implementation DownloadManager
@synthesize restClient,isLinked;

int flagCount = 0;

+ (id)sharedManager {
    static DownloadManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];

    });
    return sharedManager;
}






#pragma mark-Dropbox

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
    
    NSLog(@"%@",destPath);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:@"File downloaded successfully."
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    //[alert show];
    NSLog(@"CheckPoint");
    //[SVProgressHUD dismiss];
    [self moveItemAtFolder:destPath];
    //Notify delegate
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (self.dlDelegate != nil && [self.dlDelegate
//                                       respondsToSelector:@selector(dbDidFinishDownloadingFiles:)])
//            [self.dlDelegate dbDidFinishDownloadingFiles:self];
//    });
    
}

- (void)setDrobBoxSelectedImageArray:(NSArray *)imageArray withFolderName:(NSString *)folderN{
    
    self.pgDataSource = [[PGDataSource alloc]init];
    
    self.dbSelectedImages = [imageArray mutableCopy];
    self.folderName = folderN;
    NSLog(@"folder Name %@ selected Image %@",self.folderName,self.dbSelectedImages);
    [self downloadImageFileFromDropBox];
}

- (void)downloadImageFileFromDropBox{
    
    
    int totalCount = (int)self.dbSelectedImages.count;
    NSLog(@"total array count %i",totalCount);
    for (int i = 0; i<totalCount; i++){
        DBMetadata *metadata = [self.dbSelectedImages objectAtIndex:i];
        NSLog(@"%@",metadata.path);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        
        NSString* fPath = [documentsPath stringByAppendingPathComponent:
                           @"ustadji.jpg" ];
        
        NSLog(@"First Final Path ------->>>>>%@",fPath);
        
        [self.restClient loadFile:metadata.path intoPath:fPath];
    }
}

-(void)restClient:(DBRestClient *)client loadedThumbnail:(NSString *)destPath metadata:(DBMetadata *)metadata{
    
    NSLog(@"%@",metadata.path);
    //UIImage *image = [UIImage imageWithContentsOfFile:destPath];
    //Do something with my thumbnail
    //[imgArray addObject:image];
}

//-(void)fetchAllDropboxData
//{
//    restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
//    restClient.delegate = self;
//    //NSLog(@"load Data %@",loadData);
//    [self.restClient loadMetadata:@"/"];
//}



#pragma mark - DBRestClientDelegate Methods for Load Data
- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata *)metadata
{
    for (int i = 0; i < [metadata.contents count]; i++) {
        DBMetadata *data = [metadata.contents objectAtIndex:i];
        if (data.isDirectory) {
            
        }
        
            
            [restClient loadThumbnail:data.path ofSize:@"m" intoPath:[NSTemporaryDirectory() stringByAppendingPathComponent:data.filename]];
            //            [restClient loadThumbnail:<#(NSString *)#> ofSize:<#(NSString *)#> intoPath:<#(NSString *)#>];
        
        
        
    }
    
    
    
}



- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    
}

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
    
    
    
}



#pragma mark-Google Drive

- (void)initGoogleDriveManager
{
    // Initialize the Drive API service & load existing credentials from the keychain if available.
    self.driveService = [[GTLServiceDrive alloc] init];
    
    // Check for authorization.
    GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                          clientID:kClientId
                                                                                      clientSecret:kClientSecret];
    
    if ([auth canAuthorize]) {
        [[self driveService] setAuthorizer:auth];
    }
}




- (void)setGoogleDriveSelectedImageArray:(NSArray *)imageArray withFolderName:(NSString *)folderN{

//    self.pgDataSource = [[PGDataSource alloc]init];
//    
//    self.gdSelectedImages = [imageArray mutableCopy];
//    self.folderName = folderN;
//    NSLog(@"folder Name %@ selected Image %@",self.folderName,self.gdSelectedImages);
//
//    [self downloadImageFileFromGoogleDrive];
}


-(void)downloadImageFileFromGoogleDrive{
    
    int totalCount = (int)self.gdSelectedImages.count;
    for (int i = 0; i<totalCount; i++) {
        GTLDriveFile *file = [self.gdSelectedImages objectAtIndex:i];
        [self downloadFileContentWithService:@"Eaxmple"
                                        file:file];
    }
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        if (self.dlDelegate != nil && [self.dlDelegate
    //                                       respondsToSelector:@selector(gdDidFinishDownloadingFiles:)])
    //            [self.dlDelegate gdDidFinishDownloadingFiles:self];
    //    });
    
    
}

-(void)downloadFileContentWithService:(NSString *)loaclpath
                                 file:(GTLDriveFile *)file
{
    NSLog(@"Dwonload URL %@",file.downloadUrl);
    if (file.downloadUrl != nil)
    {
        if (!self.driveService) {
            [self initGoogleDriveManager];
        }
        NSLog(@"begin download");
        GTMHTTPFetcher *fetcher =[self.driveService.fetcherService fetcherWithURLString:file.thumbnailLink];
        [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
            if (error == nil) {
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
                
                NSString* fPath = [documentsPath stringByAppendingPathComponent:
                                   @"ustadji.jpg" ];
                //[data writeToFile:@"/Users/mycomputer/Desktop/a.mov" atomically:YES];
                //[data writeToFile:@"/Users/mycomputer/Desktop/b.mov" atomically:YES];
                [data writeToFile:fPath atomically:YES];
                NSLog(@"download ok");
                [self moveItemAtFolder:fPath];
                int count = (int)DELEGATE.gdSelectedImeges.count;
//                if (flagCount<count){
//                    ++flagCount;
//                }
//                else{
//                    
//                    [DELEGATE.gdSelectedImeges removeAllObjects];
//                }
                
            } else {
                NSLog(@"An error occurred: %@", error);
            }
        }];
    }
    else
    {
        
    }
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

@end
