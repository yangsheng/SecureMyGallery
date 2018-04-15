//
//  PatternView.h
//  Eigenface
//
//  Created by Asif Seraje on 12/20/11.
//  Copyright (c) 2011 Aptogo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatternDot.h"

@class PatternView;

@protocol PatternDelegate <NSObject>

-(void) patternView: (PatternView *) patternView startedWithPattern: (NSString *) pattern;

-(void) patternView: (PatternView *) patternView continuedWithPattern: (NSString *) pattern;

-(void) patternView: (PatternView *) patternView finishedWithPattern: (NSString *) pattern;

@end

typedef enum {
    PATTERN_DRAW_GREEN = 0,
    PATTERN_DRAW_RED = 1
} PatternDrawMode;

@interface PatternView : UIView {
    
}

@property (nonatomic, weak) IBOutlet id<PatternDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dots;
@property (nonatomic, strong) NSMutableArray *currentDots;
@property (nonatomic, assign) int currentTouchID;
@property (nonatomic, assign) int currentPosX;
@property (nonatomic, assign) int currentPosY;
@property (nonatomic, assign) bool drawingPattern;
@property (nonatomic, assign) bool showArrows;
@property (nonatomic, assign) PatternDrawMode currentDrawMode;

#pragma mark - Methods

-(void) resetPattern;

-(NSString *) getCurrentPattern;

#pragma mark - Internal Events

-(void) drawStarted;

-(void) drawContinued;

-(void) drawEnded;

#pragma mark - Geometry

-(float) deg2Rad: (float) degrees;

-(float) rad2Deg: (float) radians;

-(float) getPolarVectorDX: (float) dx DY: (float) dy;

-(float) getPolarAngleDX: (float) dx DY: (float) dy;

@end
