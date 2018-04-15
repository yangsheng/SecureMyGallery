//
//  UILabel+CustomStyle.m
//  UIAlertController-Custom-Style
//
//  Created by Asif Seraje on 12/16/14.
//  Copyright (c) 2014 Asif Seraje. All rights reserved.
//

#import "UILabel+CustomStyle.h"
#import <objc/runtime.h>


@implementation UILabel (CustomStyle)

@dynamic customTextColour;
@dynamic customButtonTextColour;
@dynamic customBackgroundColour;


#pragma mark - Load

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(setTextColor:) withNewSelector:@selector(swizzled_setTextColor:)];
    });
}

#pragma mark - Swizzle

+ (void) swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    BOOL methodAdded = class_addMethod([self class], originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (methodAdded) {
        class_replaceMethod([self class], newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

- (void)swizzled_setTextColor:(UIColor *)textColor
{
    if (self.customButtonTextColour && [[[self.superview.superview class] description] isEqualToString:[NSString stringWithFormat:@"_%@%@", @"UIAlertController", @"ActionView"]]) {
        // Buttons
        [self swizzled_setTextColor:self.customButtonTextColour];
    } else if (self.customTextColour) {
        [self swizzled_setTextColor:self.customTextColour];
    } else{
        [self swizzled_setTextColor:textColor];
    }
}

#pragma mark -

- (void)setAppearanceFont:(UIFont *)font
{
    if (font) {
        [self setFont:[UIFont fontWithName:font.fontName size:self.font.pointSize]];
        self.superview.superview.layer.backgroundColor = self.customBackgroundColour.CGColor;
        if (self.customBackgroundColour && [[[self.superview.superview class] description] isEqualToString:[NSString stringWithFormat:@"_%@%@", @"UIAlertController", @"ActionView"]]) {
            // Buttons
            [self swizzled_setTextColor:self.customButtonTextColour];
        } else {
            [self swizzled_setTextColor:self.customTextColour];
        }
    }
}

- (UIFont *)appearanceFont {
    return self.font;
}

- (void)setCustomBackgroundColour:(UIColor *)object
{
    objc_setAssociatedObject(self, @selector(customBackgroundColour), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)customBackgroundColour
{
    return objc_getAssociatedObject(self, @selector(customBackgroundColour));
}

- (void)setCustomTextColour:(UIColor *)object
{
    objc_setAssociatedObject(self, @selector(customTextColour), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)customTextColour
{
    return objc_getAssociatedObject(self, @selector(customTextColour));
}

- (void)setCustomButtonTextColour:(UIColor *)object
{
    objc_setAssociatedObject(self, @selector(customButtonTextColour), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)customButtonTextColour
{
    return objc_getAssociatedObject(self, @selector(customButtonTextColour));
}


@end




