//
//  ConfigParser.h
//  CellMonitor
//
//  Created by Asif Seraje on 10/14/10.
//  Copyright 2010 TotalSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"
#import "ConfigElement.h"

@interface ConfigParser : NSObject {
	ConfigElement *rootElement;
}

@property (nonatomic, readonly) ConfigElement *rootElement;

-(id) initWithString: (NSString *) fileContent;

-(id) initWithFile: (NSString *) fileName;

- (void) traverseConfigElement: (ConfigElement *) currentElement XMLElement:(TBXMLElement *)element;

@end
