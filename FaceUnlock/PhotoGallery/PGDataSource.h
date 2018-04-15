//
//  PGDataSource.h
//  PhotoGallery
//
//  Created by Asif Seraje on 1/12/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    IT_PHOTO = 0,
    IT_VIDEO = 1,
} ItemType;

@class PGDataSource;

@protocol PGDataSourceAsyncOpsProtocol <NSObject>

-(void) pgDataSourceDidFinishImportingFiles: (PGDataSource *) dataSource;

-(void) pgDataSourceDidFinishCopyingFiles: (PGDataSource *) dataSource;

-(void) pgDataSourceDidFinishMovingFiles: (PGDataSource *) dataSource;

-(void) pgDataSourceDidFinishDeletingFiles: (PGDataSource *) dataSource;

-(void) pgDataSourceDidFinishExportingFiles: (PGDataSource *) dataSource;


@end

@interface PGDataSource : NSObject

#pragma mark - Propertie

@property (nonatomic, weak) id<PGDataSourceAsyncOpsProtocol> delegate;

#pragma mark - Folders

-(int) numberOfFolders;

-(NSString *) folderNameForIndex: (int) index;

-(NSString *) createFolderWithName: (NSString *) name;
-(void) renamefoldername: (NSString *) oldname newstr:(NSString *) newname;
-(void) deleteForlderWithName: (NSString *) name;

#pragma mark - Files

-(NSDictionary*) totalPhotoCount;

-(int) numberOfFilesForDictionary: (NSDictionary*)aDicItem;

-(NSDictionary*) numberOfFilesForFolder: (NSString *) folder;

-(NSString *) fileNameForFolder: (NSString *) folder Index: (int) index;

-(NSString *) createFileWithName: (NSString *) name Folder: (NSString *) folder Item: (NSDictionary *) aDicItem ;

-(void) deleteFileWithName: (NSString *) name Folder: (NSString *) folder;

-(NSString *) getImagePathForFilename: (NSString *) filename Folder: (NSString *)folder;

#pragma mark - Async operations

-(void) importArrayDictionary: (NSArray *) arrayDictionary ToFolder: (NSString *) folderDestination;

-(void) copyFiles: (NSArray *) fileNames FromFolder: (NSString *) folderSource ToFolder: (NSString *) folderDestination;

-(void) moveFiles: (NSArray *) fileNames FromFolder: (NSString *) folderSource ToFolder: (NSString *) folderDestination;

-(void) deleteFiles: (NSArray *) fileNames FromFolder: (NSString *) folderSource;

-(void) exportFiles: (NSArray *) fileNames FromFolder: (NSString *) folder;


#pragma mark - Uitilities

-(ItemType)getTypeFromName:(NSString*)aStrFileName;

-(NSString *) generateNewFileName:(ItemType)aType;

-(NSString *) generateGUID;

-(NSString *) getThumbnail110PathForFilename: (NSString *) filename;

-(NSString *) getThumbnail150PathForFilename: (NSString *) filename;

-(NSString *) getThumbnail480PathForFilename: (NSString *) filename;

-(NSString *) getAlbumsStringFromNumber: (int) albums;

-(NSString *) getPhotosStringFromNumber: (NSDictionary*) items;
-(id) initWithCaller;


@end
