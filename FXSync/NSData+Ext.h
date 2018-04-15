//
//  NSData+Ext.h
//  Foxbrowser
//
//  Created by Asif Seraje on 17.06.14.
//  Copyright (c) 2014 Asif Seraje. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Ext)
/*! Returns hexadecimal string of NSData. Empty string if data is empty. */
- (NSString *)hexadecimalString;

/*! BigInteger base 10 decimal string */
- (NSString *)decimalString;
- (NSData *)dataXORdWithData:(NSData *)data;

@end
