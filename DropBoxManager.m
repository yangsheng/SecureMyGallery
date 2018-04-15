//#import "DropBoxManager.h"
//
//@implementation DropBoxManager
//
//@synthesize objDBSession,relinkUserId,apiCallDelegate;
//@synthesize objRestClient;
//@synthesize currentPostType;
//
//@synthesize strFileName;
//@synthesize strFilePath;
//@synthesize strDestDirectory;
//
//@synthesize strFolderCreate;
//
//@synthesize strFolderToList;
//
//static DropBoxManager *singletonManager = nil;
//
//+(id)dropBoxManager
//{
//    if(!singletonManager)
//        singletonManager = [[DropBoxManager alloc] init];
//    
//    return singletonManager;
//}
//
//-(void)initDropbox
//{
//    DBSession* session =  [[DBSession alloc] initWithAppKey:kDropbox_AppKey appSecret:kDropbox_AppSecret root:kDropbox_RootFolder];
//    session.delegate = self;
//    [DBSession setSharedSession:session];
//    //[session release];
//    
//    if([[DBSession sharedSession] isLinked] && objRestClient == nil)
//    {
//        self.objRestClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
//        self.objRestClient.delegate = self;
//    }
//}
//
//-(void)checkForLink
//{
//    if(![[DBSession sharedSession] isLinked])
//        [[DBSession sharedSession] linkFromController:apiCallDelegate];
//}
//
//-(BOOL)handledURL:(NSURL*)url
//{
//    BOOL isLinked=NO;
//    if ([[DBSession sharedSession] handleOpenURL:url])
//    {
//        
//        if([[DBSession sharedSession] isLinked])
//        {
//            isLinked=YES;
//            [self dropboxDidLogin];
//        }
//        else
//        {
//            isLinked = NO;
//            [self dropboxDidNotLogin];
//        }
//    }
//    return isLinked;
//}
//
//#pragma mark -
//#pragma mark Handle login
//
//-(void)dropboxDidLogin
//{
//    NSLog(@"Logged in");
//    
//    if([[DBSession sharedSession] isLinked] && self.objRestClient == nil)
//    {
//        self.objRestClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
//        self.objRestClient.delegate = self;
//    }
//    
//    switch(currentPostType)
//    {
//        case DropBoxTypeStatusNone:
//            
//            break;
//            
//        case DropBoxGetAccountInfo:
//            [self loginToDropbox];
//            break;
//            
//        case DropBoxGetFolderList:
//            [self listFolders];
//            break;
//            
//        case DropBoxCreateFolder:
//            [self createFolder];
//            break;
//            
//        case DropBoxUploadFile:
//            [self uploadFile];
//            break;
//    }
//    
//    //[(MainViewController*)apiCallDelegate setLoginStatus];
//}
//
//-(void)dropboxDidNotLogin
//{
//    NSLog(@"Not Logged in");
//    switch(currentPostType)
//    {
//        case DropBoxTypeStatusNone:
//            
//            break;
//            
//        case DropBoxUploadFile:
//            if([self.apiCallDelegate respondsToSelector:@selector(failedToUploadFile:)])
//                [self.apiCallDelegate failedToUploadFile:@"Problem connecting dropbox. Please try again later."];
//            break;
//            
//        case DropBoxGetFolderList:
//            
//            break;
//            
//        case DropBoxCreateFolder:
//            
//            break;
//            
//        case DropBoxGetAccountInfo:
//            
//            break;
//    }
//}
//
//#pragma mark -
//#pragma mark DBSessionDelegate methods
//
//- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId
//{
//   // relinkUserId = [userId retain];
//    [[[UIAlertView alloc] initWithTitle:@"Dropbox Session Ended" message:@"Do you want to relink?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relink", nil]  show];
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index
//{
//    if (index != alertView.cancelButtonIndex)
//        [[DBSession sharedSession] linkUserId:relinkUserId fromController:apiCallDelegate];
//    
//    relinkUserId = nil;
//}
//
//#pragma mark -
//#pragma mark Fileupload
//
//-(void)uploadFile
//{
//    if([[DBSession sharedSession] isLinked])
//        [self.objRestClient uploadFile:strFileName toPath:strDestDirectory withParentRev:nil fromPath:strFilePath];
//    else
//        [self checkForLink];
//}
//
//-(void)downlaodFileFromSourcePath:(NSString*)pstrSourcePath destinationPath:(NSString*)toPath
//{
//    if([[DBSession sharedSession] isLinked])
//        [self.objRestClient loadFile:pstrSourcePath intoPath:toPath];
//    else
//        [self checkForLink];
//}
//
//- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath metadata:(DBMetadata*)metadata
//{
//    if([self.apiCallDelegate respondsToSelector:@selector(finishedUploadeFile)])
//        [self.apiCallDelegate finishedUploadFile];
//    
//    NSLog(@"File uploaded successfully to path: %@", metadata.path);
//}
//
//- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath contentType:(NSString*)contentType
//{
//    if([self.apiCallDelegate respondsToSelector:@selector(finishedDownloadFile)])
//        [self.apiCallDelegate finishedDownloadFile];
//}
//
//-(void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
//{
//    if([self.apiCallDelegate respondsToSelector:@selector(failedToDownloadFile:)])
//        [self.apiCallDelegate failedToDownloadFile:[error description]];
//}
//
//- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error
//{
//    if([self.apiCallDelegate respondsToSelector:@selector(failedToUploadFile:)])
//        [self.apiCallDelegate failedToUploadFile:[error description]];
//    
//    NSLog(@"File upload failed with error - %@", error);
//}
//
//#pragma mark -
//#pragma mark Create Folder
//
//-(void)createFolder
//{
//    if([[DBSession sharedSession] isLinked])
//        [self.objRestClient createFolder:strFolderCreate];
//    else
//        [self checkForLink];
//}
//
//- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder
//{
//    if([self.apiCallDelegate respondsToSelector:@selector(finishedCreateFolder)])
//        [self.apiCallDelegate finishedCreateFolder];
//    
//    NSLog(@"Folder created successfully to path: %@", folder.path);
//}
//
//- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error
//{
//    if([self.apiCallDelegate respondsToSelector:@selector(failedToCreateFolder:)])
//        [self.apiCallDelegate failedToCreateFolder:[error description]];
//    
//    NSLog(@"Folder create failed with error - %@", error);
//}
//
//#pragma mark -
//#pragma mark Load account information
//
//-(void)loginToDropbox
//{
//    if([[DBSession sharedSession] isLinked])
//        [self.objRestClient loadAccountInfo];
//    else
//        [self checkForLink];
//}
//
//- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info
//{
//    if([self.apiCallDelegate respondsToSelector:@selector(finishedLogin:)])
//    {
//        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init] ;
//        [userInfo setObject:info.displayName forKey:@"UserName"];
//        [userInfo setObject:info.userId forKey:@"UserID"];
//        [userInfo setObject:info.referralLink forKey:@"RefferelLink"];
//        [self.apiCallDelegate finishedLogin:userInfo];
//    }
//    
//    NSLog(@"Got Information: %@", info.displayName);
//}
//
//- (void)restClient:(DBRestClient*)client loadAccountInfoFailedWithError:(NSError*)error
//{
//    if([self.apiCallDelegate respondsToSelector:@selector(failedToLogin:)])
//        [self.apiCallDelegate failedToLogin:[error description]];
//    
//    NSLog(@"Failed to get account information with error - %@", error);
//}
//
//#pragma mark -
//#pragma mark Logout
//
//-(void)logoutFromDropbox
//{
//    [[DBSession sharedSession] unlinkAll];
//    //[self.objRestClient release];
//}
//
//#pragma mark -
//#pragma mark Check for login
//
//-(BOOL)isLoggedIn
//{
//    return [[DBSession sharedSession] isLinked] ? YES : NO;
//}
//
//#pragma mark -
//#pragma mark Load Folder list
//
//-(void)listFolders
//{
//    NSLog(@"Here-->%@",self.strFolderToList);
//    if([[DBSession sharedSession] isLinked])
//        [self.objRestClient loadMetadata:self.strFolderToList];
//    else
//        [self checkForLink];
//}
//
//- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata
//{
//    if (metadata.isDirectory)
//    {
//        NSLog(@"Folder '%@' contains:", metadata.contents);
//        for (DBMetadata *file in metadata.contents)
//        {
//            NSLog(@"\t%@", file);
//        }
//        
//        if([apiCallDelegate respondsToSelector:@selector(getFolderContentFinished:)])
//            [apiCallDelegate getFolderContentFinished:metadata];
//    }
//    NSLog(@"Folder list success: %@", metadata.path);
//    
//}
//
//- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path
//{
//    
//}
//
//- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error
//{
//    NSLog(@"Load meta data failed with error - %@", error);
//    
//    if([apiCallDelegate respondsToSelector:@selector(getFolderContentFailed:)])
//        [apiCallDelegate getFolderContentFailed:[error localizedDescription]];
//}
//
//@end