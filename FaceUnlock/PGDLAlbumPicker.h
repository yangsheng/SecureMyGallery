//
//  PGDLAlbumPicker.h
//  Foxbrowser
//
//  Created by Twinbit2 on 3/30/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGDLAlbumPicker;

@protocol PGDLAlbumPickerDelegate <NSObject>

-(void) dlAlbumPicker: (PGDLAlbumPicker *) picker didSelectAlbumName: (NSString *) name;

-(void) dlAlbumPickerDidCancel:(PGDLAlbumPicker *)picker;

@end


@interface PGDLAlbumPicker : UIViewController

@property (nonatomic, weak) id<PGDLAlbumPickerDelegate> delegate;
@property (nonatomic, assign) int tag;
@property (nonatomic,strong)NSString *naviTitle;

@end
