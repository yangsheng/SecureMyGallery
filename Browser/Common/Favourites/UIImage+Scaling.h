//
//  UIImage+Scaling.h
//  Foxbrowser
//
//  Created by Asif Seraje on 31.07.12.
//
//
//  Copyright (c) 2012-2014 Asif Seraje
//

#import <UIKit/UIKit.h>

@interface UIImage (Scaling)
- (UIImage *) scaleToSize: (CGSize)size;
- (UIImage *) scaleProportionalToSize: (CGSize)size;
- (UIImage *) cutImageToSize: (CGSize)size;
@end
