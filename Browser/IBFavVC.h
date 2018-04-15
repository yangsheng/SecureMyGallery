//
//  IBFavVC.h
//  Icons
//
//  Created by Asif Seraje on 3/28/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBFavVC : UIViewController
{
    NSURL *_url;
}

- (id)initWithTitle:(NSString *)title forURL:(NSURL *)url withIconURL:(NSURL *)iconURL withScreenshot:(UIImage *)screenshot;

- (void)cancel;
- (void)add;
- (void)iconLoaded:(NSString *)iconFilePath;

@end
