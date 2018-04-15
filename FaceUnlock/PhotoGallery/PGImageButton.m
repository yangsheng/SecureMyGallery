//
//  PGButton.m
//  PhotoGallery
//
//  Created by Asif Seraje on 1/29/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import "PGImageButton.h"

@interface PGImageButton()

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIImageView *checkedoverlay,*videoOverlay;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *viewOverlay;

@end

@implementation PGImageButton

//Public
@synthesize delegate = _delegate;
@synthesize selected = _selected;
@synthesize selectionMode = _selectionMode;
@synthesize name = _name;

//Private
@synthesize image = _image;
@synthesize viewOverlay = _viewOverlay;
@synthesize button = _button;

-(id) initWithFrame:(CGRect)frame Image: (UIImage *) image SelectionMode: (BOOL) selectionMode Type:(ItemType)aType {
    self = [super initWithFrame: frame];
    if (self) {
        //Create image
        self.image = [[UIImageView alloc] initWithImage: image];
        self.image.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview: self.image];
        self.itType = aType;
        if (self.itType == IT_VIDEO) {
            self.videoOverlay = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"CTAssetsPickerVideo"]];
            self.videoOverlay.frame = CGRectMake(2, frame.size.height - 12, 15, 8);
            [self addSubview: self.videoOverlay];
        }
        //Create overlay
        self.viewOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.viewOverlay.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        [self addSubview: self.viewOverlay];
    
        self.checkedoverlay = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"CTAssetsPickerChecked"]];
        self.checkedoverlay.frame = CGRectMake( frame.size.width - 35, 3, 31, 31);
        [self.viewOverlay addSubview: self.checkedoverlay];
        
        //Create button
        self.button = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: self.button];
        
        //Remember selection mode
        self.selectionMode = selectionMode;
        
        //Hide selection overlay
        self.selected = FALSE;
        self.viewOverlay.hidden = TRUE;
    }
    return self;
}

-(void) setSelected:(_Bool)selected {
    if (self.selectionMode) {
        _selected = selected;
        self.viewOverlay.hidden = !_selected;
    }
}

-(void) buttonTapped {
    //Toggle overlay image
    self.selected = !self.selected;
    
    //Send message to delegate
    [self.delegate pgImageButtonWasTapped: self];
}


@end
