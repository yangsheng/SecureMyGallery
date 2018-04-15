//
//  PGDataSource.m
//  PhotoGallery
//
//  Created by Asif Seraje on 1/12/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import "PGDataSource.h"
#import "UIImage+Resize.h"
#import "UIImage+Resizing.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface PGDataSource()

@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *itmesDir;
@property (nonatomic, strong) NSString *cacheDir;

-(NSString *) getBundlePathForFileName: (NSString *) filename;
-(NSString *) getDocumentPathForFileName: (NSString *) filename;

@end

@implementation PGDataSource

//Public
@synthesize delegate = _delegate;

//Private
@synthesize fileManager = _fileManager;
@synthesize itmesDir = _itmesDir;
@synthesize cacheDir = _cacheDir;

BOOL flag;

-(id) init {
    self = [super init];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
        self.itmesDir = [self getDocumentPathForFileName: @"items"];
        self.cacheDir = [self getDocumentPathForFileName: @"cache"];
        
        //Create images directory if it doesn't exist
        if ([self.fileManager fileExistsAtPath: self.itmesDir] == FALSE)
            [self.fileManager createDirectoryAtPath: self.itmesDir withIntermediateDirectories:FALSE attributes:nil error: nil];
        
        //Create cache directory if it doensn't exist
        if ([self.fileManager fileExistsAtPath: self.cacheDir] == FALSE)
            [self.fileManager createDirectoryAtPath: self.cacheDir withIntermediateDirectories:FALSE attributes:nil error: nil]; 
        [self migrateOldVersion];
        //Create default album
        NSArray *folderList = [self.fileManager contentsOfDirectoryAtPath: self.itmesDir error: nil];
        if ([folderList count] == 0)
            [self createFolderWithName: @"Default album"];
    }
    return self;
}


-(id) initWithCaller {
    self = [super init];
    flag = YES;
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
        self.itmesDir = [self getDocumentPathForFileName: @"items2"];
        self.cacheDir = [self getDocumentPathForFileName: @"cache2"];
        
        //Create images directory if it doesn't exist
        if ([self.fileManager fileExistsAtPath: self.itmesDir] == FALSE)
            [self.fileManager createDirectoryAtPath: self.itmesDir withIntermediateDirectories:FALSE attributes:nil error: nil];
        
        //Create cache directory if it doensn't exist
        if ([self.fileManager fileExistsAtPath: self.cacheDir] == FALSE)
            [self.fileManager createDirectoryAtPath: self.cacheDir withIntermediateDirectories:FALSE attributes:nil error: nil];
        [self migrateOldVersion];
        //Create default album
        NSArray *folderList = [self.fileManager contentsOfDirectoryAtPath: self.itmesDir error: nil];
        if ([folderList count] == 0)
            [self createFolderWithName: @"Default album"];
    }
    return self;
}



- (void)migrateOldVersion
{
    NSString *_strOldPath = [self getDocumentPathForFileName: @"images"];
    if ([self.fileManager fileExistsAtPath: _strOldPath] == true)
    {
        NSArray *folderList = [self.fileManager contentsOfDirectoryAtPath: _strOldPath error: nil];
        for (int i = 0; i < folderList.count; i++) {
            NSString *_strToPath = [NSString stringWithFormat:@"%@/%@",self.itmesDir,[folderList[i] lastPathComponent]];
            NSString *_strOrigin = [NSString stringWithFormat:@"%@/%@",_strOldPath,folderList[i]];
            BOOL _bMoved = [self.fileManager moveItemAtPath:_strOrigin toPath:_strToPath error:nil];
            if (!_bMoved) {
                NSArray *_orignList = [self.fileManager contentsOfDirectoryAtPath: _strOrigin error: nil];
                for (int j = 0; j < _orignList.count; j++) {
                    NSString *_strOrgFile = [NSString stringWithFormat:@"%@/%@",_strOrigin,_orignList[j]];
                    NSString *_strToFile = [NSString stringWithFormat:@"%@/%@",_strToPath,_orignList[j]];
                    [self.fileManager moveItemAtPath:_strOrgFile toPath:_strToFile error:nil];
                }
            }
        }
        //[self.fileManager removeItemAtPath:_strOldPath error:nil];
    }
}

#pragma mark - Folders

-(int) numberOfFolders {
    NSArray *folderList = [self.fileManager contentsOfDirectoryAtPath: self.itmesDir error: nil];
    return [folderList count];
}

-(NSString *) folderNameForIndex: (int) index {
    NSArray *folderList = [self.fileManager contentsOfDirectoryAtPath: self.itmesDir error: nil];
    return [folderList objectAtIndex: index];
}

-(NSString *) createFolderWithName: (NSString *) name {
    NSString *folderPath = [self.itmesDir stringByAppendingPathComponent: name];
    [self.fileManager createDirectoryAtPath: folderPath withIntermediateDirectories: FALSE attributes:nil error: nil];
    return folderPath;
}


-(void) renamefoldername: (NSString *) oldname newstr:(NSString *) newname
{

   NSLog (@"Copying download file from %@ ", newname);
    
   // NSLog (@"Copying download file from to %@", oldname);
    NSError *error = nil;
   NSMutableArray *folderList = [self.fileManager contentsOfDirectoryAtPath: self.itmesDir error: nil];
    NSLog(@"%@",folderList);
    
    [folderList replaceObjectAtIndex:1 withObject:newname];
    
    
   // NSLog(@"%@",folderList);
    
     // Attempt the move
    
    NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
    
  //  [prefs setValue:renamestr forKey:@"old_fold_name"];
    
    
    NSString *oldName = [self.itmesDir stringByAppendingPathComponent:[prefs valueForKey: @"old_fold_name"]];
    NSString *newName = [self.itmesDir stringByAppendingPathComponent: newname];

    
    if ([self.fileManager fileExistsAtPath:oldName]) //this will tell you if the file exists at that path
        NSLog (@"exist %@ ", oldName);

    
    if ([self.fileManager moveItemAtPath:oldName  toPath:newName error:&error] != YES){
        NSLog(@"Unable to move file: %@", [error localizedDescription]);
    }
    else
        NSLog (@"success");

    
       
   
    
}


-(void) deleteForlderWithName: (NSString *) name {
    //Remove files
    NSDictionary *_dicItem = [self numberOfFilesForFolder: name];
    int items = [self numberOfFilesForDictionary:_dicItem];
    for (int i=items-1; i>=0; i--)
        [self deleteFileWithName: [self fileNameForFolder: name Index:i] Folder: name];
    
    //Remove folder
    NSString *folderPath = [self.itmesDir stringByAppendingPathComponent: name];
    [self.fileManager removeItemAtPath: folderPath error: nil]; 
}

#pragma mark - Files

-(NSDictionary*) totalPhotoCount {
    int photos = 0,videos = 0;
    for (int i=0; i<[self numberOfFolders]; i++) {
        NSString *folder = [self folderNameForIndex: i];
        NSDictionary *_dicFolderItemCnt = [self numberOfFilesForFolder: folder];
        photos += [[_dicFolderItemCnt objectForKey:@"photos"] intValue];
        videos += [[_dicFolderItemCnt objectForKey:@"videos"] intValue];
    }
    return @{@"photos": [NSString stringWithFormat:@"%d",photos],@"videos": [NSString stringWithFormat:@"%d",videos]};
}

-(int) numberOfFilesForDictionary: (NSDictionary*)aDicItem
{
    int _nCnt = [[aDicItem objectForKey:@"photos"] intValue] + [[aDicItem objectForKey:@"videos"] intValue];
    return _nCnt;
}

-(NSDictionary*) numberOfFilesForFolder: (NSString *) folder {
    NSString *folderPath = [self.itmesDir stringByAppendingPathComponent: folder];
    NSArray *fileList = [self.fileManager contentsOfDirectoryAtPath: folderPath error: nil];
    int photos = 0,videos = 0;
    for (int i = 0; i < fileList.count; i++) {
        NSString *_strFileName = fileList[i];
        if ([_strFileName.pathExtension isEqualToString:@"jpg"]) {
            photos++;
        }
        else
            videos++;
    }
    return @{@"photos": [NSString stringWithFormat:@"%d",photos],@"videos": [NSString stringWithFormat:@"%d",videos]};
}

-(NSString *) fileNameForFolder: (NSString *) folder Index: (int) index {
    NSString *folderPath = [self.itmesDir stringByAppendingPathComponent: folder];
    NSArray *fileList = [self.fileManager contentsOfDirectoryAtPath: folderPath error: nil];
    return [fileList objectAtIndex: index];
}

-(NSString *) createFileWithName: (NSString *) name Folder: (NSString *) folder Item: (NSDictionary *) aDicItem {//kch-data
    UIImage *_imageThumb = [aDicItem objectForKey:@"UIImagePickerControllerOriginalImage"];
    //Thumb110
    UIImage *thumbImage110 = [_imageThumb thumbnailImage:110 transparentBorder:0 cornerRadius:0 interpolationQuality: kCGInterpolationHigh];
    [UIImageJPEGRepresentation(thumbImage110, 0.75) writeToFile: [self getThumbnail110PathForFilename: name] atomically:YES];
    
    //Thumb150
    UIImage *thumbImage150 = [_imageThumb thumbnailImage:150 transparentBorder:0 cornerRadius:0 interpolationQuality: kCGInterpolationHigh];
    [UIImageJPEGRepresentation(thumbImage150, 0.75) writeToFile: [self getThumbnail150PathForFilename: name] atomically:YES];
    NSString *filePath;
    NSString *folderPath = [self.itmesDir stringByAppendingPathComponent: folder];
    filePath = [folderPath stringByAppendingPathComponent: name];
    if ([[aDicItem objectForKey:UIImagePickerControllerMediaType] isEqualToString:ALAssetTypePhoto]) {
        //Image filename
        [UIImageJPEGRepresentation(_imageThumb, 1.0) writeToFile: filePath atomically:YES];
    }
    else
    {
        AVAsset *asset      = [AVURLAsset URLAssetWithURL:[aDicItem objectForKey:@"UIImagePickerControllerReferenceURL"] options:nil];
        AVAssetExportSession *session =
        [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
        
        session.outputFileType  = AVFileTypeQuickTimeMovie;
        session.outputURL       = [NSURL fileURLWithPath:filePath];
        
        [session exportAsynchronouslyWithCompletionHandler:^{
            
            if (session.status == AVAssetExportSessionStatusCompleted)
            {
                //NSData *data    = [NSData dataWithContentsOfURL:session.outputURL];
            }
        }];
        //Thumb150
        UIImage *thumbImage480 =[_imageThumb scaleToFitSize:CGSizeMake(480, 480)];
        [UIImageJPEGRepresentation(thumbImage480, 1.0) writeToFile: [self getThumbnail480PathForFilename: name] atomically:YES];
    }
    //Return file path
    return filePath;
}

-(void) deleteFileWithName: (NSString *) name Folder: (NSString *) folder {
    //Delete file cache
    [self.fileManager removeItemAtPath: [self getThumbnail110PathForFilename: name] error: nil];
    [self.fileManager removeItemAtPath: [self getThumbnail150PathForFilename: name] error: nil];
    
    //Delete file
    NSString *folderPath = [self.itmesDir stringByAppendingPathComponent: folder];
    NSString *filePath = [folderPath stringByAppendingPathComponent: name];
    [self.fileManager removeItemAtPath: filePath error: nil];
}

-(NSString *) getImagePathForFilename: (NSString *) filename Folder: (NSString *)folder {
    NSString *folderPath = [self.itmesDir stringByAppendingPathComponent: folder];
    return [folderPath stringByAppendingPathComponent: filename];
}

#pragma mark - Async operations

-(void) importArrayDictionary: (NSArray *) arrayDictionary ToFolder: (NSString *) folderDestination; {
    //kch-data
    dispatch_queue_t importQueue = dispatch_queue_create("importQueue", NULL);
    dispatch_async(importQueue, ^{
        for(NSDictionary *dictionary in arrayDictionary) {
            //Write Item to local library
            [self createFileWithName: [self generateNewFileName:[self getTypeFromDictionary:dictionary]] Folder: folderDestination Item:dictionary];
        }
        
        //Notify delegate
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pgDataSourceDidFinishImportingFiles:)])
                [self.delegate pgDataSourceDidFinishImportingFiles: self];
        });
    });
}


-(void) copyFiles: (NSArray *) fileNames FromFolder: (NSString *) folderSource ToFolder: (NSString *) folderDestination {
    dispatch_queue_t copyQueue = dispatch_queue_create("copyQueue", NULL);
    dispatch_async(copyQueue, ^{
        for (NSString *fileName in fileNames) {
            //Load Items
            NSString *filepath = [self getImagePathForFilename: fileName Folder: folderSource];
            NSString *_strNewFolderPath = [self.itmesDir stringByAppendingPathComponent: folderDestination];
            NSString *_strNewFileName = [self generateNewFileName:[self getTypeFromName:fileName]];
            NSString *_strNewPath = [_strNewFolderPath stringByAppendingPathComponent:_strNewFileName];
            
            NSString *_strOld110 = [self getThumbnail110PathForFilename: fileName];
            NSString *_strOld150 = [self getThumbnail150PathForFilename: fileName];
            NSString *_strOld480 = [self getThumbnail480PathForFilename: fileName];
            
            NSString *_strNew110 = [self getThumbnail110PathForFilename: _strNewFileName];
            NSString *_strNew150 = [self getThumbnail150PathForFilename: _strNewFileName];
            NSString *_strNew480 = [self getThumbnail480PathForFilename: _strNewFileName];
            
            [[NSFileManager defaultManager] copyItemAtPath:_strOld110 toPath:_strNew110 error:nil];
            [[NSFileManager defaultManager] copyItemAtPath:_strOld150 toPath:_strNew150 error:nil];
            [[NSFileManager defaultManager] copyItemAtPath:_strOld480 toPath:_strNew480 error:nil];

            [[NSFileManager defaultManager] copyItemAtPath:filepath toPath:_strNewPath error:nil];
        }
        //Notify delegate
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pgDataSourceDidFinishCopyingFiles:)])
                [self.delegate pgDataSourceDidFinishCopyingFiles: self];
        });
    });
}

-(void) moveFiles: (NSArray *) fileNames FromFolder: (NSString *) folderSource ToFolder: (NSString *) folderDestination {
    
    dispatch_queue_t moveQueue = dispatch_queue_create("moveQueue", NULL);
    dispatch_async(moveQueue, ^{
        for (NSString *fileName in fileNames) {
            //Load image
            NSString *filepath = [self getImagePathForFilename: fileName Folder: folderSource];
            NSString *_strNewFolderPath = [self.itmesDir stringByAppendingPathComponent: folderDestination];
            NSString *_strNewFileName = [self generateNewFileName:[self getTypeFromName:fileName]];
            NSString *_strNewPath = [_strNewFolderPath stringByAppendingPathComponent:_strNewFileName];
            
            NSString *_strOld110 = [self getThumbnail110PathForFilename: fileName];
            NSString *_strOld150 = [self getThumbnail150PathForFilename: fileName];
            NSString *_strOld480 = [self getThumbnail480PathForFilename: fileName];
            
            NSString *_strNew110 = [self getThumbnail110PathForFilename: _strNewFileName];
            NSString *_strNew150 = [self getThumbnail150PathForFilename: _strNewFileName];
            NSString *_strNew480 = [self getThumbnail480PathForFilename: _strNewFileName];
            
            [[NSFileManager defaultManager] copyItemAtPath:_strOld110 toPath:_strNew110 error:nil];
            [[NSFileManager defaultManager] copyItemAtPath:_strOld150 toPath:_strNew150 error:nil];
            [[NSFileManager defaultManager] copyItemAtPath:_strOld480 toPath:_strNew480 error:nil];

            

            
            [[NSFileManager defaultManager] copyItemAtPath:filepath toPath:_strNewPath error:nil];
            
           
        }
        
        for (NSString *fileName in fileNames)
            [self deleteFileWithName: fileName Folder: folderSource];
        //Notify delegate
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pgDataSourceDidFinishMovingFiles:)])
                [self.delegate pgDataSourceDidFinishMovingFiles: self];
        });
    });
}

-(void) exportFiles: (NSArray *) fileNames FromFolder: (NSString *) folder {
    dispatch_queue_t exportQueue = dispatch_queue_create("exportQueue", NULL);
    dispatch_async(exportQueue, ^{
        //Load photo library
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        for (NSString *fileName in fileNames) {
            //Load image
            NSString *filePath = [self getImagePathForFilename: fileName Folder: folder];
            NSString *_strLastPath = [filePath pathExtension];
            if ([_strLastPath isEqualToString:@"mp4"]) {
                [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:filePath] completionBlock:^(NSURL *assetURL, NSError *error) {
                    
                }];
            }
            else{
                UIImage *image = [UIImage imageWithContentsOfFile: filePath];
                //Write to photo library
                [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock: nil];
            }
        }
        
        //Releasse library
            
        //Notify delegate
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pgDataSourceDidFinishExportingFiles:)])
                [self.delegate pgDataSourceDidFinishExportingFiles: self];
        });
    });
}

-(void) deleteFiles: (NSArray *) fileNames FromFolder: (NSString *) folderSource {
    dispatch_queue_t deleteQueue = dispatch_queue_create("deleteQueue", NULL);
    dispatch_async(deleteQueue, ^{
        //Delete every file
        for (NSString *fileName in fileNames)
            [self deleteFileWithName: fileName Folder: folderSource];
        
        //Notify delegate
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pgDataSourceDidFinishDeletingFiles:)])
                [self.delegate pgDataSourceDidFinishDeletingFiles: self];
        });
    });
}

#pragma mark - Utilities

-(ItemType)getTypeFromDictionary:(NSDictionary*)aDicItem
{
    if ([[aDicItem objectForKey:UIImagePickerControllerMediaType] isEqualToString:ALAssetTypePhoto])
        return IT_PHOTO;
    return IT_VIDEO;
}

-(ItemType)getTypeFromName:(NSString*)aStrFileName
{
    if ([[aStrFileName pathExtension] isEqualToString:@"jpg"])
        return IT_PHOTO;
    return IT_VIDEO;
}

-(NSString *) getBundlePathForFileName: (NSString *) filename {
    return [[NSBundle mainBundle] pathForResource: filename ofType: @""];
}

-(NSString *) getDocumentPathForFileName: (NSString *) filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent: filename];
}

-(NSString *) generateNewFileName:(ItemType)aType {
    //Get current photo id
    int currentItemID = [[NSUserDefaults standardUserDefaults] integerForKey: @"currentItemID"];
    NSString *_strExt = @"jpg";
    if (aType == IT_VIDEO) {
        _strExt = @"mp4";
    }
    //Get filename
    NSString *filename = [NSString stringWithFormat: @"%i.%@",currentItemID,_strExt];
    
    //Fill with zeros
    while ([filename length] < 10)
        filename = [NSString stringWithFormat: @"0%@", filename];
    
    //Increment photo id
    currentItemID++;
    [[NSUserDefaults standardUserDefaults] setInteger: currentItemID forKey: @"currentItemID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Return filename
    return filename;
}

-(NSString *) generateGUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

-(NSString *) getThumbnail110PathForFilename: (NSString *) filename {
    NSString *_strOrign = [self.cacheDir stringByAppendingPathComponent: filename];
    NSString *_strName = [_strOrign stringByDeletingPathExtension];
    return [ _strName stringByAppendingString:@"_110.jpg"];
}

-(NSString *) getThumbnail150PathForFilename: (NSString *) filename {
    NSString *_strOrign = [self.cacheDir stringByAppendingPathComponent: filename];
    NSString *_strName = [_strOrign stringByDeletingPathExtension];
    return [ _strName stringByAppendingString:@"_150.jpg"];
}

-(NSString *) getThumbnail480PathForFilename: (NSString *) filename {
    NSString *_strOrign = [self.cacheDir stringByAppendingPathComponent: filename];
    NSString *_strName = [_strOrign stringByDeletingPathExtension];
    return [ _strName stringByAppendingString:@"_480.jpg"];
}

-(NSString *) getAlbumsStringFromNumber: (int) albums {
    if (albums == 0)
        return @"No albums";
    else if (albums == 1)
        return @"1 album";
    else
        return [NSString stringWithFormat: @"%i albums", albums];
}

-(NSString *) getPhotosStringFromNumber: (NSDictionary*) items {
    int _nPhotos = [[items objectForKey:@"photos"] intValue];
    int _nVideos = [[items objectForKey:@"videos"] intValue];
    if (_nPhotos == 0 && _nVideos == 0)
        return @"No photos & videos";
    else
    {
        NSString *_strPhotoWord,*_strVidoeWord;
        if (_nPhotos == 1)
            _strPhotoWord = @"photo";
        else
            _strPhotoWord = @"photos";
        if (_nVideos == 1)
            _strVidoeWord = @"video";
        else
            _strVidoeWord = @"videos";
        if (_nPhotos == 0) {
            return [NSString stringWithFormat: @"%i %@", _nVideos,_strVidoeWord];
        }
        else if (_nVideos == 0)
        {
            return [NSString stringWithFormat: @"%i %@", _nPhotos,_strPhotoWord];
        }
        return [NSString stringWithFormat: @"%i %@, %i %@", _nPhotos,_strPhotoWord, _nVideos,_strVidoeWord];
    }
    
}

#pragma mark - Memory


@end
