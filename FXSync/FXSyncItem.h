//
//  FXSyncItem.h
//  Foxbrowser
//
//  Created by Asif Seraje on 20.06.14.
//  Copyright (c) 2014 Asif Seraje. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FFSyncItemType) {
    FFSyncBookmarkItem,
    FFSyncTabItem,
    FFSyncHistoryItem,
    FFSyncPasswordItem,
    FFSyncSettingsItem
};

@interface FXSyncItem : NSObject

@property (nonatomic, strong) NSString *syncId;
@property (nonatomic, assign) NSTimeInterval modified;
@property (nonatomic, assign) NSInteger sortindex;

/*! Setting this invalidates jsonPayload */
@property (nonatomic, strong) NSData *payload;
/*! JSON version of payload, uses mutable containers */
@property (strong, nonatomic) NSMutableDictionary *jsonPayload;

@property (nonatomic, strong) NSString *collection;

/*! Convenience method to save the item to the store.
 * Serializes the dictionary and saves it into payload
 */
- (void)save;
/*! Mark item as deleted, you should probably not call this method directly  */
- (void)deleteItem;

@end

FOUNDATION_EXPORT NSInteger kFXSyncItemModified;
FOUNDATION_EXPORT NSInteger kFXSyncItemDeleted;

@interface FXSyncItem (CommonFormat)

/*! (For tabs) title string: title of the current page */
- (NSString *)title;
- (void)setTitle:(NSString *)title;

/*! Depending on the object type, will return the different url properties*/
- (NSString *)urlString;

- (BOOL)deleted;

@end

@interface FXSyncItem (TabFormat)
// ====== On a tab object
/*! tabs array of objects: each object describes a tab {urlHistory, icon, lastUsed, title} */
- (NSArray *)tabs;
/*! clientName string: name of the client providing these tabs */
- (NSString *)clientName;
@end

@interface FXSyncItem (BookmarkFormat)
// ===== Bookmarks =====

/*! bmkUri string uri of the page to load */
- (NSString *)bmkUri;
- (void)setBmkUri:(NSString *)bmkUri;
/*! description string: extra description if provided */
- (NSString *)description;
/*! tags array of strings: tags for the bookmark */
- (NSString *)tags;
/*! parentid string: GUID of the containing folder */
- (NSString *)parentid;
- (void)setParentid:(NSString *)parentid;
/*! string: name of the containing folder */
- (NSString *)parentName;
- (void)setParentName:(NSString *)parentName;
/*! bookmark */
- (NSString *)type;
- (void)setType:(NSString *)type;

/*! siteUri string: site associated with the livemark */
- (NSString *)siteUri;
- (void)setSiteUri:(NSString *)siteUri;
/*! feedUri string: feed to get items for the livemark */
- (NSString *)feedUri;
- (void)setFeedUri:(NSString *)feedUri;

@end

@interface FXSyncItem (FolderFormat)
- (NSArray *)children;
- (void)addChild:(NSString *)syncId;
@end

@interface FXSyncItem (HistoryFormat)
// ====== History ====
/*! string: uri of the page */
- (NSString *)histUri;
- (NSArray *)visits;
- (void)addVisit:(NSTimeInterval)time type:(NSInteger)code;
@end
