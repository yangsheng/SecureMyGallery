//
//  FXSyncEngine.h
//  Foxbrowser
//
//  Created by Asif Seraje on 21.06.14.
//  Copyright (c) 2014 Asif Seraje. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FXSyncEngine;

FOUNDATION_EXPORT NSString *const kFXSyncEngineErrorDomain;
typedef NS_ENUM(NSUInteger, kFXSyncEngineError) {
    kFXSyncEngineErrorStorageVersionMismatch,
    kFXSyncEngineErrorEncryption,
    kFXSyncEngineErrorAuthentication,// 404 response
    kFXSyncEngineErrorEndOfLife,
    kFXSyncEngineErrorMaintenance
};

@protocol FXSyncEngineDelegate <NSObject>
@required
- (void)syncEngine:(FXSyncEngine *)engine didLoadCollection:(NSString *)cName;
- (void)syncEngine:(FXSyncEngine *)engine didFailWithError:(NSError *)error;
- (void)syncEngine:(FXSyncEngine *)engine didReceiveCommands:(NSArray *)commands;
- (void)syncEngine:(FXSyncEngine *)engine alertWithString:(NSString *)alert;
@end

@class FXUserAuth, Reachability;
/*! Supposed to do the actual sync process. 
 *
 * https://docs.services.mozilla.com/sync/storageformat5.html
 * https://docs.services.mozilla.com/storage/apis-1.5.html
 */
@interface FXSyncEngine : NSObject

+ (NSArray *)collectionNames;

@property (strong, nonatomic) FXUserAuth *userAuth;
/*! Global record containing info about the stored data */
@property (strong, nonatomic) NSDictionary *metaglobal;

@property (strong, nonatomic, readonly) Reachability *reachability;
@property (weak, nonatomic) id<FXSyncEngineDelegate> delegate;

@property (readonly, getter=isSyncRunning) BOOL syncRunning;
/*! Uses the iOS vendor identifier */
@property (nonatomic, readonly) NSString *clientID;
@property (nonatomic, readonly) NSString *clientName;

- (void)startSync;
- (void)reset;

@end
