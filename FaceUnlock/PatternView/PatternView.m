//
//  PatternView.m
//  Eigenface
//
//  Created by Asif Seraje on 12/20/11.
//  Copyright (c) 2011 Aptogo Limited. All rights reserved.
//

#import "PatternView.h"

@implementation PatternView

#pragma mark - Properties

@synthesize delegate = _delegate;
@synthesize dots = _dots;
@synthesize currentDots = _currentDots;
@synthesize currentTouchID = _currentTouchID;
@synthesize currentPosX = _currentPosX;
@synthesize currentPosY = _currentPosY;
@synthesize drawingPattern = _drawingPattern;
@synthesize showArrows = _showArrows;
@synthesize currentDrawMode = _currentDrawMode;

-(void) setShowArrows:(_Bool)showArrows {
    _showArrows = showArrows;
    [self setNeedsDisplay];
}

-(void) setCurrentDrawMode:(PatternDrawMode)currentDrawMode {
    //Show arrows
    if (currentDrawMode == PATTERN_DRAW_GREEN)
        self.showArrows = FALSE;
    else
        self.showArrows = TRUE;
    
    _currentDrawMode = currentDrawMode;
    [self setNeedsDisplay];
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self)
        [self resetPattern];
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self)
        [self resetPattern];
    return self;
}

#pragma mark - Touch management

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!self.drawingPattern) {
        //Enumerate touchs
        for (UITouch *touch in touches) {
            //Get touch position
            CGPoint cgp = [touch locationInView: self];
            
            //Set current global coordinates
            self.currentPosX = cgp.x;
            self.currentPosY = cgp.y;
            
            //Search for initial dot
            for (PatternDot *dot in self.dots) {
                float distance = [self getPolarVectorDX: dot.center.x - cgp.x DY: dot.center.y - cgp.y];
                
                if (distance < dot.radiusLarge) {
                    //Reset dots
                    for (PatternDot *currentDot in self.dots)
                        currentDot.status = PATTERN_NORMAL;
                    [self.currentDots removeAllObjects];
                    
                    //Remember touch id
                    self.currentTouchID = (int)(__bridge void*) touch;
                    
                    //Drawing patter has started
                    self.drawingPattern = TRUE;

                    //Add first dot only
                    [self.currentDots addObject: dot];
                    
                    //Mark dot as active
                    dot.status = PATTERN_ACTIVE;
                    
                    //Notify delegate about start
                    [self drawStarted];
                    
                    //Redraw view
                    [self setNeedsDisplay];
                    
                    //Exit
                    return;
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.drawingPattern) {
        //Enumerate touchs
        for (UITouch *touch in touches) {
            //We're only interested in one touch
            int touchID = (int) (__bridge void *) touch;
            
            if (touchID == self.currentTouchID) {
                //Get touch position
                CGPoint cgp = [touch locationInView: self];
                
                //Set current global coordinates
                self.currentPosX = cgp.x;
                self.currentPosY = cgp.y;
                
                //Needs display
                [self setNeedsDisplay];
                
                //Search for next dots
                for (PatternDot *dot in self.dots) {
                    float distance = [self getPolarVectorDX: dot.center.x - cgp.x DY: dot.center.y - cgp.y];
                    
                    if (dot.status == PATTERN_NORMAL && distance < dot.radiusLarge) {
                        //Activate intersecting dots
                        if (self.currentDots.lastObject != nil) {
                            PatternDot *lastDot = self.currentDots.lastObject;
                            
                            //Calculate steps
                            float distance = [self getPolarVectorDX: dot.center.x - lastDot.center.x DY: dot.center.y - lastDot.center.y];
                            float stepsNeeded = distance / (dot.radiusLarge / 2);
                            float stepX = (dot.center.x - lastDot.center.x) / stepsNeeded;
                            float stepY = (dot.center.y - lastDot.center.y) / stepsNeeded;
                           
                            for (float k=0; k<=stepsNeeded; k++) {
                                //Current point
                                float checkX = lastDot.center.x + k * stepX;
                                float checkY = lastDot.center.y + k * stepY;
                                
                                //Check all dots
                                for (PatternDot *checkDot in self.dots) {
                                    if (checkDot.status == PATTERN_NORMAL) {
                                        float checkDistance = [self getPolarVectorDX: checkX-checkDot.center.x DY: checkY-checkDot.center.y];
                                        if (checkDistance < checkDot.radiusLarge) {
                                            //Add to array
                                            [self.currentDots addObject: checkDot];
                                        
                                            //Mark as active
                                            checkDot.status = PATTERN_ACTIVE;
                                        }
                                    }
                                }
                            }
                        }
                        
                        //Notify delegate
                        [self drawContinued];
                        
                        //Verify if this is the end of drawing
                        if ([self.dots count] == [self.currentDots count]) {
                            //No longer drawing
                            self.drawingPattern = FALSE;
                            
                            //Reset touch id
                            self.currentTouchID = -1;
                            
                            //Notify delegate
                            [self drawEnded];
                        }
                        
                        //Redraw
                        [self setNeedsDisplay];
                        
                        //Exit
                        return;
                    }
                }

            }
        }
    }   
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.drawingPattern) {
        //Enumerate touchs
        for (UITouch *touch in touches) {
            //We're only interested in one touch
            int touchID = (int) (__bridge void *) touch;
            
            if (touchID == self.currentTouchID) {
                //No longer drawing
                self.drawingPattern = FALSE;
                
                //Reset touch id
                self.currentTouchID = -1;
                
                //Notify delegate
                [self drawEnded];
                
                //Redraw
                [self setNeedsDisplay];
                
                //Exit
                return;
            }
        }
    }      
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.drawingPattern) {
        //Enumerate touchs
        for (UITouch *touch in touches) {
            //We're only interested in one touch
            int touchID = (int) (__bridge void *) touch;
            
            if (touchID == self.currentTouchID) {
                //No longer drawing
                self.drawingPattern = FALSE;
                
                //Reset touch id
                self.currentTouchID = -1;
                
                //Notify delegate
                [self drawEnded];
                
                //Redraw
                [self setNeedsDisplay];
                
                //Exit
                return;
            }
        }
    }      
}

#pragma mark - Methods

-(void) resetPattern {
    //NSLog(@"Drawing was reset...");
    
    //Flags
    self.currentTouchID = -1;
    self.drawingPattern = FALSE;
    self.currentDrawMode = PATTERN_DRAW_GREEN;
    
    //Allocate dots
    self.dots = [[NSMutableArray alloc] init];
    
    //Make dot grid
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            //Create dot
            PatternDot *dot = [[PatternDot alloc] init];
            dot.horizontalIndex = j;
            dot.verticalIndex = i;
            dot.radiusSmall = 5;
            dot.radiusMedium = 20;
            dot.radiusLarge = 25;
            
            //Update position in rect
            [dot updatePositionToRect: self.bounds];
            
            //Add to array
            [self.dots addObject: dot];
        }
    }
    
    //Initiate current dots
    self.currentDots = [[NSMutableArray alloc] init];
}

-(NSString *) getCurrentPattern {
    NSString *buffer = @"";
    for (PatternDot *dot in self.currentDots)
        buffer = [buffer stringByAppendingFormat: @"%i", dot.uniqueIdentifier];
    return buffer;
}

#pragma mark - Internal events

-(void) drawStarted {
    [self.delegate patternView: self startedWithPattern: [self getCurrentPattern]];  
}

-(void) drawContinued {
    [self.delegate patternView: self continuedWithPattern: [self getCurrentPattern]];    
}

-(void) drawEnded {
    [self.delegate patternView: self finishedWithPattern: [self getCurrentPattern]];    
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    //Update positions
    for (PatternDot *dot in self.dots)
        [dot updatePositionToRect: self.frame];
    
    //Get the context
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextClearRect(ctx, rect);
    
    //Set stroke color
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    //Set fill color
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    //Set line width
    CGContextSetLineWidth(ctx, 1);
    
    //Draw dot circles
    for (PatternDot *dot in self.dots) {
        if (dot.status == PATTERN_ACTIVE)
            if (self.currentDrawMode == PATTERN_DRAW_GREEN)
                CGContextFillEllipseInRect(ctx, dot.strokeRectSmall);
            else
                CGContextStrokeEllipseInRect(ctx, dot.strokeRectSmall);
        else
            CGContextStrokeEllipseInRect(ctx, dot.strokeRectSmall);
    }
        
    //Set stroke color
    if (self.currentDrawMode == PATTERN_DRAW_GREEN) { 
        CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
        CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    } else if (self.currentDrawMode == PATTERN_DRAW_RED) {
        CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    }
    
    //Set line width
    CGContextSetLineWidth(ctx, 5);
    
    //Draw dot large circles
    for (PatternDot *dot in self.currentDots)
        CGContextStrokeEllipseInRect(ctx, dot.strokeRectLarge);
    
    //Drow large circle triangles
    if (self.showArrows && [self.currentDots count] > 1) {
        for (int i=0; i<[self.currentDots count]-1; i++) {
            //Get current and next dot
            PatternDot *dot = [self.currentDots objectAtIndex: i];
            PatternDot *nextDot = [self.currentDots objectAtIndex: i+1];
            
            //Geometry
            float angle = [self getPolarAngleDX: nextDot.center.x-dot.center.x DY: nextDot.center.y-dot.center.y];
            CGPoint pointA = CGPointMake(dot.center.x + cos([self deg2Rad: angle - 30]) * dot.radiusMedium,
                                         dot.center.y + sin([self deg2Rad: angle - 30]) * dot.radiusMedium);
            CGPoint pointB = CGPointMake(dot.center.x + cos([self deg2Rad: angle]) * dot.radiusLarge,
                                         dot.center.y + sin([self deg2Rad: angle]) * dot.radiusLarge);
            CGPoint pointC = CGPointMake(dot.center.x + cos([self deg2Rad: angle + 30]) * dot.radiusMedium,
                                         dot.center.y + sin([self deg2Rad: angle + 30]) * dot.radiusMedium);
            
            //Draw triangle
            CGContextBeginPath(ctx);
            CGContextMoveToPoint(ctx, pointA.x, pointA.y);
            CGContextAddLineToPoint(ctx, pointB.x, pointB.y);
            CGContextAddLineToPoint(ctx, pointC.x, pointC.y);
            CGContextAddLineToPoint(ctx, pointA.x, pointA.y);
            CGContextFillPath(ctx);
        }
    }
    
    //Draw lines between current dots
    if ([self.currentDots count] > 0) {
        //Set line color
        CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor);
        
        //Set line width
        CGContextSetLineWidth(ctx, 5);
        
        //Set line cap
        CGContextSetLineCap(ctx, kCGLineCapRound);
        
        //Begin path
        CGContextBeginPath(ctx);
        
        //Move to first location
        PatternDot *first = [self.currentDots objectAtIndex: 0];
        CGContextMoveToPoint(ctx, first.center.x, first.center.y);
        
        //Move to next dots
        for (PatternDot *dot in self.currentDots)
            CGContextAddLineToPoint(ctx, dot.center.x, dot.center.y);
        
        //Move to current position
        if (self.drawingPattern)
            CGContextAddLineToPoint(ctx, self.currentPosX, self.currentPosY);
        
        //Stroke path
        CGContextStrokePath(ctx);
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

-(void) dealloc {
    NSLog(@"[PatternView dealloc]");
 
    
}

@end
