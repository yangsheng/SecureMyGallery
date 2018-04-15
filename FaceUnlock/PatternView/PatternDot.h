//
//  PatternDot.h
//  Eigenface
//
//  Created by Asif Seraje on 12/20/11.
//  Copyright (c) 2011 Aptogo Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PATTERN_NORMAL = 0,
    PATTERN_ACTIVE = 1
} PatternStatus;

@interface PatternDot : NSObject {
}

#pragma mark - Properties

@property (nonatomic, assign) int horizontalIndex;
@property (nonatomic, assign) int verticalIndex;
@property (nonatomic, assign) float radiusSmall;
@property (nonatomic, assign) float radiusMedium;
@property (nonatomic, assign) float radiusLarge;
@property (nonatomic, assign) PatternStatus status;

#pragma mark - Calculated

@property (nonatomic, readonly) int uniqueIdentifier;
@property (nonatomic, readonly) CGPoint center;
@property (nonatomic, readonly) CGRect strokeRectSmall;
@property (nonatomic, readonly) CGRect strokeRectLarge;

#pragma mark - Methods

-(void) updatePositionToRect: (CGRect) rect;

@end
