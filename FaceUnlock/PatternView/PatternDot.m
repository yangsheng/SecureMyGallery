//
//  PatternDot.m
//  Eigenface
//
//  Created by Asif Seraje on 12/20/11.
//  Copyright (c) 2011 Aptogo Limited. All rights reserved.
//

#import "PatternDot.h"

@implementation PatternDot

#pragma mark - Constants

#define PATTERN_DOT_SIZE        3
#define PATTERN_DOT_PADDING     40

#pragma mark - Properties

@synthesize horizontalIndex = _horizontalIndex;
@synthesize verticalIndex = _verticalIndex;
@synthesize radiusSmall = _radiusSmall;
@synthesize radiusMedium = _radiusMedium;
@synthesize radiusLarge = _radiusLarge;
@synthesize status = _status;

#pragma mark - ReadOnly

@synthesize center = _center;
@synthesize strokeRectSmall = _strokeRectSmall;
@synthesize strokeRectLarge = _strokeRectLarge;

-(int) uniqueIdentifier {
    return 1 + self.verticalIndex * PATTERN_DOT_SIZE + self.horizontalIndex;
}

#pragma mark - Methods

-(void) updatePositionToRect: (CGRect) rect {
    //Calculate position
    float posX = PATTERN_DOT_PADDING + self.horizontalIndex * ((rect.size.width - 2 * PATTERN_DOT_PADDING) / (PATTERN_DOT_SIZE - 1));
    float posY = PATTERN_DOT_PADDING + self.verticalIndex * ((rect.size.height - 2 * PATTERN_DOT_PADDING) / (PATTERN_DOT_SIZE - 1));
    
    //Calculate center
    _center = CGPointMake(posX, posY);
    
    //Calculate stroke rects
    _strokeRectSmall = CGRectMake(posX - self.radiusSmall, posY - self.radiusSmall, self.radiusSmall * 2, self.radiusSmall * 2);
    _strokeRectLarge = CGRectMake(posX - self.radiusLarge, posY - self.radiusLarge, self.radiusLarge * 2, self.radiusLarge * 2);
}

@end
