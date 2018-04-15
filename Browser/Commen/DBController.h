//
//  DataController.h
//  iconsweb
//
//  Created by Asif Seraje on 4/16/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class IBPageCache;
@interface DBController : NSObject
{
    sqlite3 *databaseHandle;
}

- (void)initDatabase;
//- (void)insertPageCache:(IBPageCache *)pageCache;
//- (IBPageCache *)getPageCacheById:(NSString *)pageCacheId;
//- (void)updatePageCache:(IBPageCache *)pageCache;
//- (void)deletePageCacheOldest:(NSInteger)count;

- (void)insertHistory:(NSString *)title url:(NSString *)url;
- (BOOL)historyExistedWithURL:(NSString *)url;
- (NSArray *)searchHistory:(NSString *)query limit:(NSInteger)limit;
@end
