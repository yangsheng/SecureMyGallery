//
//  ConfigElement.m
//  CellMonitor
//
//  Created by Asif Seraje on 10/14/10.
//  Copyright 2010 TotalSoft. All rights reserved.
//

/************************************************************************************************************************************************
 
 ConfigParser *layout = [[ConfigParser alloc] initWithFile: @"Layout.Config.xml"];
 ConfigElement *front = [[layout.rootElement search: @"CellTemplate" Attribute: @"templateId" Value: @"1"] search: @"Front" Attribute:nil Value:nil];
 
 ************************************************************************************************************************************************/

#import "ConfigElement.h"

@implementation ConfigElement


#pragma mark OS Events

- (id) init {
	self = [super init];
	if (self != nil) {
		//NSLog(@"ConfigElement alloc.");
		
		properties = [[NSMutableDictionary alloc] init];
		subelements = [[NSMutableArray alloc] init];
	}
	return self;
}

#pragma mark Properties

@synthesize title, content, properties, subelements, parent;

-(ConfigElement *) rootElement {
	ConfigElement* crtElement = self;
	do {
		//Found root
		if (crtElement.parent == nil)
			return crtElement;
		
		//Navigate up
		crtElement = crtElement.parent;
	} while (TRUE);
}

#pragma mark Methods

-(ConfigElement *) search: (NSString *) searchTitle Attribute: (NSString *) attribute Value: (NSString *) value {
	return [self  search: searchTitle Attribute: attribute Value: value rootElement: self];
}

-(ConfigElement *) search: (NSString *) searchTitle Attribute: (NSString *) attribute Value: (NSString *) value rootElement: (ConfigElement *) currentElement {
	if ([currentElement.title isEqualToString: searchTitle] && attribute == nil && value == nil) {
		return currentElement;
	} else if ([currentElement.title isEqualToString: searchTitle] && [[currentElement.properties objectForKey: attribute] isEqualToString: value]) {
		return currentElement;
	} else {
		for (ConfigElement *subElement in currentElement.subelements) {
			ConfigElement *result = [self search: searchTitle Attribute:attribute Value:value rootElement: subElement];
			if (result != nil)
				return result;
		}
		return nil;
	}
}

-(void) debug {
	//Debug
	//NSLog(@"ConfigElement debug: %@", self.title);
	
	//Child nodes
	for (ConfigElement *sub in self.subelements) {
		[sub debug];
	}
}

-(void) dealloc {
	//Debug
	//NSLog(@"ConfigElement dealloc: %@", self.title);
	
	[properties removeAllObjects];
	
	[subelements removeAllObjects];
	
    
	
}

@end
