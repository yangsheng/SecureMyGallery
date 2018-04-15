//
//  PGButton.h
//  PhotoGallery
//
//  Created by Asif Seraje on 1/29/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGDataSource.h"

@class PGImageButton;

@protocol PGImageButtonDelegate <NSObject>

-(void) pgImageButtonWasTapped: (PGImageButton *) sender;

@end

@interface PGImageButton : UIView

@property (nonatomic, weak) id<PGImageButtonDelegate> delegate;
@property (nonatomic, assign) bool selected;
@property (nonatomic, assign) bool selectionMode;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) ItemType itType;

-(id) initWithFrame:(CGRect)frame Image: (UIImage *) image SelectionMode: (BOOL) selectionMode Type:(ItemType)aType;

@end
