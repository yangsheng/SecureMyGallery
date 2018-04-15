//
//  ImagLoader.h
//  v2exmobile
//
//  Created by Asif Seraje on 3/16/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageLoader : NSObject
{
    NSURLConnection *connection;
    NSMutableData *webdata;
    UIImageView *imageView;
    NSString *cacheFilePath;
    UIButton *imageButton;
    NSArray *urlChoices;
    NSInteger currentURLIdx;
}

- (void)loadImageWithURL:(NSURL *)url forImageView:(UIImageView *)imgView;
- (void)loadImageForImageView:(UIImageView *)imgView inURLs:(NSArray *)urls;
- (void)loadImageWithURL:(NSURL *)url forImageButton:(UIButton *)imgButton;
@end
