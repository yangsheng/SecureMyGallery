//
//  NSString+Levenshtein.h
//  NextSearch
//
//  Created by Asif Seraje on 07.04.14.
//  Copyright (c) 2014 Asif Seraje. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Levenshtein)

- (float)levenshteinDistance:(NSString *)comparisonString;

@end
