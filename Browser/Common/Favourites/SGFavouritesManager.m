//
//  SGScreenshotManager.m
//  Foxbrowser
//
//  Created by Asif Seraje on 27.12.12.
//
//
//  Copyright (c) 2012-2014 Asif Seraje
//

#import "SGFavouritesManager.h"
#import "UIImage+Scaling.h"
#import "SGWebViewController.h"
#import "NSStringPunycodeAdditions.h"
#import "NSString+Levenshtein.h"
#import "FXSyncStock.h"

@implementation SGFavouritesManager {
    NSMutableArray *_favourites;
    
    NSCache *_imageCache;
    NSMutableArray *_blocked;
}

+ (SGFavouritesManager *)sharedManager {
    static SGFavouritesManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SGFavouritesManager alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _favourites = [NSMutableArray arrayWithCapacity:[self maxFavs]];
        _imageCache = [NSCache new];
        _blocked = [NSMutableArray arrayWithContentsOfFile:[self _blacklistFilePath]];
        if (!_blocked) {
            _blocked = [NSMutableArray arrayWithCapacity:10];
        }
        
        // Delete old files after 3 weeks
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSString* path = [self _screenshotPath];
            NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
            for (NSString *file in files) {
                NSString *f = [path stringByAppendingPathComponent:file];
                NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:f error:NULL];
                NSDate *modDate = attr[NSFileModificationDate];
                NSDate *cutoff = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*21];
                if ([modDate compare:cutoff] == NSOrderedAscending) {
                    [[NSFileManager defaultManager] removeItemAtPath:f error:NULL];
                }
            }
        });
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refresh)
                                                     name:kFXDataChangedNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark Favourites stuff
- (NSArray *)favourites {
    if (_favourites.count < [self maxFavs]) {
        [self _fillFavourites];
    }
    return [_favourites copy];
}

- (void)refresh {
    [_favourites removeAllObjects];
    [self _fillFavourites];
}

- (FXSyncItem *)blockItem:(FXSyncItem *)item; {
    NSString *urlS = [item urlString];
    
    if ([urlS length]) {
        [_blocked addObject:urlS];
        [_blocked writeToFile:[self _blacklistFilePath] atomically:NO];
        
        for (NSUInteger i = 0; i < _favourites.count; i++) {
            FXSyncItem *item = _favourites[i];
            if ([[item urlString] isEqualToString:urlS])
                [_favourites removeObjectAtIndex:i];
        }
    }
    
    return [self _fillFavourites];
}

- (void)resetFavourites {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[self _blacklistFilePath] error:NULL];
    [fm removeItemAtPath:[self _screenshotPath] error:NULL];
    [_imageCache removeAllObjects];
    
}

- (CGSize)imageSize {
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat scale = 0.2 * [UIScreen mainScreen].scale;
    return size.height > size.width ? CGSizeMake(size.height*scale, size.width*scale) :
    CGSizeMake(size.width*scale, size.height*scale);
}

- (NSUInteger)maxFavs {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([UIScreen mainScreen].scale == 3.0) {
            return 12;// Show 12 on the iPhone 6 plus
        } else {
            return [UIScreen mainScreen].bounds.size.height >= 568 ? 8 : 6;
        }
    }
    return 8;//on the iPad always 8
}

#pragma mark Screenshot stuff
- (void)webViewDidFinishLoad:(SGWebViewController *)webController; {
    NSURL *url = webController.request.URL;
    if (![self _mightNeedScreenshot:url.host]) return;
    
    NSString *path = [self _imagePathForURL:url];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        NSDictionary *attr = [fm attributesOfItemAtPath:path error:NULL];
        NSDate *modDate = attr[NSFileModificationDate];
        if ([modDate compare:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*3]] == NSOrderedDescending) {
            return;
        }
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIImage *screen = [self _imageWithView:webController.webView];
        if (screen.size.height > screen.size.width) {
            screen = [screen cutImageToSize:CGSizeMake(screen.size.width, screen.size.height)];
        }
        
        screen = [screen scaleProportionalToSize:[self imageSize]];
        if (screen) {
            NSData *data = UIImageJPEGRepresentation(screen, 0.7);
            [data writeToFile:path atomically:NO];
        }
        
    });
}

- (UIImage *)imageWithURL:(NSURL *)url {
    UIImage *image = [_imageCache objectForKey:url];
    
    if (image == nil) {
        NSString *path = [self _searchImagePathForURL:url];
        image = [UIImage imageWithContentsOfFile:path];
        if (image) {
            [_imageCache setObject:image forKey:url];
        }
    }
    return image;
}

#pragma mark  - Utility

- (BOOL)_mightNeedScreenshot:(NSString *)host {
    float bestDistance = MAXFLOAT;
    for (FXSyncItem *item in _favourites) {
        NSString *urlS = [item urlString];
        if ([urlS length] > 0) {
            NSURL *url = [NSURL URLWithString:urlS];
            float dist =  [host levenshteinDistance:url.host];
            if (dist < bestDistance) {
                bestDistance = dist;
            }
        }
    }
    return bestDistance < 10;
}

- (BOOL)_containsHost:(NSString *)host {
    if (host != nil || [host length] > 0) {
        for (FXSyncItem *item in _favourites) {
            NSString *urlS = [item urlString];
            if ([urlS rangeOfString:host].location != NSNotFound// avoid costly conversion
                && [[NSURL URLWithUnicodeString:urlS].host isEqualToString:host])
                return YES;
        }
    }
    return NO;
}

- (FXSyncItem *)_fillFavourites {
    NSArray *history = [[FXSyncStock sharedInstance] history];
    NSArray *bookmarks = [[FXSyncStock sharedInstance] bookmarksWithParent:@"toolbar"];
    
    FXSyncItem *item;
    NSUInteger i = _favourites.count;
    while (_favourites.count < [self maxFavs]) {
        if (i < bookmarks.count) item = bookmarks[i];
        else if (i < history.count) item = history[i];
        else break;
        
        i++;
        
        NSString *urlS = [item bmkUri];
        if ([urlS length] == 0) urlS = [item histUri];
        if ([urlS length] == 0) urlS = [item siteUri];
        
        NSURL *url = [NSURL URLWithUnicodeString:urlS];
        if (![url host]
            || [self _containsHost:[url host]]
            || [_blocked containsObject:url.absoluteString]) {
            item = nil;
            continue;//skip
        }
        
        if ([urlS length]) {
            // We just need url and title.
            [_favourites addObject:item];
        }
    }
    return item;
}

- (UIImage *)_imageWithView:(UIView *)view {
    UIImage *viewImage = nil;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (view.layer && ctx) {
        [view.layer renderInContext:ctx];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return viewImage;
}

- (NSString *)_screenshotPath {
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:@"Screenshots"];
}

- (NSString *)_imagePathForURL:(NSURL *)url {
    NSString* path = [self _screenshotPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path])
        [fm createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:NULL];
    
    return [[path stringByAppendingPathComponent:url.host] stringByAppendingPathExtension:@"jpg"];
}

/*! Search for the image file with the longest matching host suffix */
- (NSString *)_searchImagePathForURL:(NSURL *)url {
    NSString* path = [self _screenshotPath];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSString *host = url.host;
    
    NSString *best = nil;
    float bestDistance = 1000000;
    // Find the smallest Levenshtein distance
    for (NSString *file in files) {
        
        NSString *current = [file stringByDeletingPathExtension];
        float dist =  [host levenshteinDistance:current];
        if (dist < bestDistance) {
            best = current;
            bestDistance = dist;
        }
    }
    
    // No more than 20% difference
    if (best != nil && bestDistance < host.length/5) {
        return [[path stringByAppendingPathComponent:best] stringByAppendingPathExtension:@"jpg"];
    }
    return nil;
}

- (NSString *)_blacklistFilePath {
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:@"blacklist.plist"];
}

@end
