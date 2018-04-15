//
//  PGAlbumPicker.h
//  PhotoGallery
//
//  Created by Asif Seraje on 2/4/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGAlbumPicker;

@protocol PGAlbumPickerDelegate <NSObject>

-(void) albumPicker: (PGAlbumPicker *) picker didSelectAlbumName: (NSString *) name;

-(void) albumPickerDidCancel:(PGAlbumPicker *)picker;

@end

@interface PGAlbumPicker : UIViewController

@property (nonatomic, weak) id<PGAlbumPickerDelegate> delegate;
@property (nonatomic, assign) int tag;
@property (nonatomic, strong) NSString *naviTitle;

@end
