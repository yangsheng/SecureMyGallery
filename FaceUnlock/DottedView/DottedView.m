//
//  DottedView.m
//  FaceUnlock
//
//  Created by Asif Seraje on 12/28/11.
//  Copyright (c) 2011 Asif Seraje. All rights reserved.
//

#import "DottedView.h"

@interface DottedView () {
    NSTimer *animationTimer;
}

@property (nonatomic, assign) int currentValue;
@property (nonatomic, readonly) float dotAlphaTarget;


-(void) incrementViewAlpha;
-(void) decrementViewAlpha;

@end

@implementation DottedView

#pragma mark - Constants

#define DOTTED_VIEW_ALPHA_STOPPED   0.00
#define DOTTED_VIEW_ALPHA_PENDING   0.20
#define DOTTED_VIEW_ALPHA_STARTED   0.10
#define DOTTED_VIEW_ALPHA_STEP      0.05
#define DOTTED_VIEW_DOTS            24

#pragma mark - Properties

@synthesize currentValue = _currentValue;

-(float) dotAlphaTarget {
    if (self.currentStatus == DOTTED_VIEW_STATUS_STOPPED)
        return DOTTED_VIEW_ALPHA_STOPPED;
    else if (self.currentStatus == DOTTED_VIEW_STATUS_PENDING)
        return DOTTED_VIEW_ALPHA_PENDING;
    else if (self.currentStatus == DOTTED_VIEW_STATUS_STARTED)
        return DOTTED_VIEW_ALPHA_STARTED;

    //Default
    return DOTTED_VIEW_ALPHA_STOPPED;
}

@synthesize currentStatus = _currentStatus;
@synthesize hiddenWhenStopped = _hiddenWhenStopped;
@synthesize dotRadius = _dotRadius;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self)
        [self initializeView];
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self)
        [self initializeView];
    return self;
}

-(void) initializeView {
    //Debug
    NSLog(@"[DottedView initializeView]");
    
    //Reset timer
    animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector: @selector(timerTick) userInfo:nil repeats:TRUE];
    
    //Reset current value
    self.currentValue = 0;
    
    //Reset current status
    self.currentStatus = DOTTED_VIEW_STATUS_STOPPED;
    
    //Reset property
    self.hiddenWhenStopped = TRUE;
    
    //Rest current dot size
    self.dotRadius = 5;

    //Reset dots alpha
    for (int i=0; i<DOTTED_VIEW_DOTS; i++)
        dotAlpha[i] = DOTTED_VIEW_ALPHA_STOPPED;
    
    //Reset current view alpha
    self.alpha = 0;
}

#pragma mark - Timer

-(void) timerTick {
    //Values for all dots
    float alphaTarget = [self dotAlphaTarget];
    for (int i=0; i<DOTTED_VIEW_DOTS; i++) {
        if (dotAlpha[i] > alphaTarget) {
            //Decrement
            dotAlpha[i] -= DOTTED_VIEW_ALPHA_STEP;
            if (dotAlpha[i] < alphaTarget)
                dotAlpha[i] = alphaTarget;
        } else if (dotAlpha[i] < alphaTarget) {
            //Increment
            dotAlpha[i] += DOTTED_VIEW_ALPHA_STEP;
            if (dotAlpha[i] > alphaTarget)
                dotAlpha[i] = alphaTarget;
        }
    }
    
    //Animating
    if (self.currentStatus == DOTTED_VIEW_STATUS_STARTED) {
        //Increment current value
        self.currentValue++;
        
        //Cycle current value
        if (self.currentValue == DOTTED_VIEW_DOTS)
            self.currentValue = 0;
        
        //Increment current alpha for dot
        dotAlpha[self.currentValue] = 1.0;
    
        //Increment current view alpha
        [self incrementViewAlpha];
    } else  if (self.currentStatus == DOTTED_VIEW_STATUS_PENDING ) {
        //Increment current view alpha
        [self incrementViewAlpha];
    } else if (self.currentStatus == DOTTED_VIEW_STATUS_STOPPED) {
        if (self.hiddenWhenStopped) {
            //Decrement current view alpha
            [self decrementViewAlpha];
        }
    }
    
    //Force redraw
    [self setNeedsDisplay];
}

-(void) incrementViewAlpha {
    if (self.alpha < 1) {
        self.alpha += DOTTED_VIEW_ALPHA_STEP * 3;
        if (self.alpha > 1)
            self.alpha = 1;
    }            
}

-(void) decrementViewAlpha {
    if (self.alpha > 0) {
        self.alpha -= DOTTED_VIEW_ALPHA_STEP * 3;
        if (self.alpha < 0)
            self.alpha = 0;
    }    
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    //Get the context
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextClearRect(ctx, rect);
    
    //View center
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    //View radius horizontal and vertical
    float radiusX = self.bounds.size.width/2 - self.dotRadius * 2;
    float radiusY = self.bounds.size.height/2 - self.dotRadius * 2;
    
    //Draw dots
    for (int i=0; i<DOTTED_VIEW_DOTS; i++) {
        //Calculate dot center
        CGPoint dotCenter = CGPointMake(center.x + radiusX * cos([self deg2Rad: i * 15 - 90]), center.y + radiusY * sin([self deg2Rad: i * 15 - 90]));
        
        //Calculate dot rect
        CGRect dotRect = CGRectMake(dotCenter.x - self.dotRadius, (dotCenter.y - self.dotRadius), self.dotRadius * 2, self.dotRadius * 2);

        //Calculate fill color
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:1 green:1 blue:1 alpha: dotAlpha[i]].CGColor);
        
        //Stoke dot
        CGContextFillEllipseInRect(ctx, dotRect);
    }
}

#pragma mark - Geometry

-(float) getPolarVectorDX: (float) dx DY: (float) dy {
	return sqrt(dx*dx + dy*dy);
}

-(float) getPolarAngleDX: (float) dx DY: (float) dy {
	if (dx > 0 && dy >= 0)
		return [self rad2Deg: atan(dy/dx)];
	else if (dx > 0 && dy < 0)
		return [self rad2Deg: atan(dy/dx)] + 360;
	else if (dx  < 0)
		return [self rad2Deg: atan(dy/dx)] + 180;
	else if (dx == 0 && dy > 0)
		return 90;
	else if (dx == 0 && dy < 0)
		return 270;
	return 0;
}

-(float) deg2Rad: (float) degrees{
	return degrees * M_PI / 180;
}

-(float) rad2Deg: (float) radians{
	return radians * 180 / M_PI;
}

#pragma mark - Memory

-(void) dealloc{
    //Debug
    NSLog(@"[DottedView dealloc]");
    
}

@end
