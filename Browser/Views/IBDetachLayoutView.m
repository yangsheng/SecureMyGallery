//
//  IBDetachLayoutView.m
//  iconsweb
//
//  Created by Asif Seraje on 6/24/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import "IBDetachLayoutView.h"

@implementation IBDetachLayoutView

- (id)initWithViewController:(id)_mainVC
{
    self = [super init];
    if (self) {
        mainVC = _mainVC;
    }
    return self;
}

- (void)layoutSubviews
{
    [mainVC viewWillLayoutSubviews];
}

@end
