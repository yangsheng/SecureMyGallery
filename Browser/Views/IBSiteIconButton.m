//
//  IBSiteIconButton.m
//  iconsweb
//
//  Created by Asif Seraje on 6/15/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import "IBSiteIconButton.h"

@implementation IBSiteIconButton

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];;
    [self setHighlighted:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setHighlighted:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setHighlighted:NO];
}

@end
