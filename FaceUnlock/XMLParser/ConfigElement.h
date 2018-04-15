//
//  ConfigElement.h
//  CellMonitor
//
//  Created by Asif Seraje on 10/14/10.
//  Copyright 2010 TotalSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigElement : NSObject {
	NSString *title;
    NSString *content;
	NSMutableDictionary *properties;
	NSMutableArray *subelements;
	ConfigElement* __weak parent;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSMutableDictionary *properties;
@property (nonatomic, strong) NSMutableArray *subelements;
@property (nonatomic, weak) ConfigElement* parent;
@property (weak, nonatomic, readonly) ConfigElement* rootElement;

-(ConfigElement *) search: (NSString *) searchTitle Attribute: (NSString *) attribute Value: (NSString *) value;

-(ConfigElement *) search: (NSString *) searchTitle Attribute: (NSString *) attribute Value: (NSString *) value rootElement: (ConfigElement *) currentElement;

-(void) debug;

@end
