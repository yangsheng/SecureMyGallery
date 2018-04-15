//
//  MD5.h
//  v2exmobile
//
//  Created by Asif Seraje on 3/16/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)
- (NSString *) md5;
@end

@interface NSData (MD5)
- (NSString*)md5;
@end
