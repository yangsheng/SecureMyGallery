//
//  CoreDataManager.h
//  PhotoVault
//
//  Created by Asif Seraje on 12/20/15.
//
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

- (void)saveContactToAddressBook : (NSDictionary *) dict;
-(NSArray *)fetchContactsFromDB;
-(NSArray *)fetchPassBookFromDB;
@end
