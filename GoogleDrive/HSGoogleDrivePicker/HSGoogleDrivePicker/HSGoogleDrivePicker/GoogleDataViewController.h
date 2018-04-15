//
//  GoogleDataViewController.h
//  Mazurka
//
//  Created by  Limited on 3/9/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSDriveManager.h"

@class GTLDriveFile;

typedef void (^GDriveFileViewerCompletionBlock)(HSDriveManager *manager, GTLDriveFile *file);

@interface GoogleDataViewController : UIViewController

@property (copy) GDriveFileViewerCompletionBlock completion;
@property (strong, nonatomic) GTLDriveFile *file;
@property (nonatomic) BOOL isDownloading;

- (instancetype)initWithId:(NSString*)clientId secret:(NSString*)secret;


@end
