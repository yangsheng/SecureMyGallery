//
//  IBDetachLayoutView.h
//  iconsweb
//
//  Created by Asif Seraje on 6/24/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBDetachLayoutView : UIView
{
    id mainVC;
}

- (id)initWithViewController:(id)_mainVC;
@end
