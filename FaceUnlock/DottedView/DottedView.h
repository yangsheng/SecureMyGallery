//
//  DottedView.h
//  FaceUnlock
//
//  Created by Asif Seraje on 12/28/11.
//  Copyright (c) 2011 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DOTTED_VIEW_STATUS_STOPPED = 0,
    DOTTED_VIEW_STATUS_PENDING = 1,
    DOTTED_VIEW_STATUS_STARTED = 2
} DottedViewStatus;

@interface DottedView : UIView {
    float dotAlpha[24];
}

#pragma mark - Properties

@property (nonatomic, assign) DottedViewStatus currentStatus;
@property (nonatomic, assign) bool hiddenWhenStopped;
@property (nonatomic, assign) float dotRadius;

#pragma mark - Initialization

-(void) initializeView;

#pragma mark - Geometry

-(float) deg2Rad: (float) degrees;

-(float) rad2Deg: (float) radians;

-(float) getPolarVectorDX: (float) dx DY: (float) dy;

-(float) getPolarAngleDX: (float) dx DY: (float) dy;

@end
