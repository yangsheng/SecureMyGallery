//
//  ConfigParser.m
//  CellMonitor
//
//  Created by Asif Seraje on 10/14/10.
//  Copyright 2010 TotalSoft. All rights reserved.
//

/************************************************************************************************************************************************
 
 ConfigParser *layout = [[ConfigParser alloc] initWithFile: @"Layout.Config.xml"];
 ConfigElement *front = [[layout.rootElement search: @"CellTemplate" Attribute: @"templateId" Value: @"1"] search: @"Front" Attribute:nil Value:nil];
 
************************************************************************************************************************************************/

#import "ConfigParser.h"

@implementation ConfigParser

@synthesize rootElement;

-(id) initWithString: (NSString *) fileContent {
	if (self = [super init]) {
		//NSLog(@"ConfigParser alloc: %@", fileName);
		
		//Parse xml
		TBXML *tbxml = [TBXML tbxmlWithXMLString: fileContent];
		
		//Root element init
		rootElement = [[ConfigElement alloc] init];
		rootElement.title = @"root";
		
		//Traverse
		if (tbxml.rootXMLElement)
			[self traverseConfigElement:rootElement XMLElement: tbxml.rootXMLElement];
	}
	
	return self;
}

-(id) initWithFile: (NSString *) fileName {
	if (self = [super init]) {
		//NSLog(@"ConfigParser alloc: %@", fileName);
		
		//Parse xml
		TBXML *tbxml = [TBXML tbxmlWithXMLFile: fileName];
		
		//Root element init
		rootElement = [[ConfigElement alloc] init];
		rootElement.title = @"root";
		
		//Traverse
		if (tbxml.rootXMLElement)
			[self traverseConfigElement:rootElement XMLElement: tbxml.rootXMLElement];
	}
	
	return self;
}

- (void) traverseConfigElement: (ConfigElement *) currentElement XMLElement:(TBXMLElement *)element  {
	do {
		//Initiate
		ConfigElement *nextElement = [[ConfigElement alloc] init];
		
		//Set title
		nextElement.title = [TBXML elementName: element];
        nextElement.content = [TBXML textForElement: element];
		
		//Get attributes
		TBXMLAttribute * attribute = element->firstAttribute;
		while (attribute) {
			[nextElement.properties setValue: [NSString stringWithFormat:@"%@", [TBXML attributeValue:attribute]] forKey: [NSString stringWithFormat:@"%@", [TBXML attributeName:attribute]]];
			attribute = attribute->next;
		}
		
		//Dobule linked
		nextElement.parent = currentElement;
		[currentElement.subelements insertObject: nextElement atIndex: [currentElement.subelements count]];

		//Traverse
		if (element->firstChild)
            [self traverseConfigElement: nextElement XMLElement:element->firstChild];
	} while ((element = element->nextSibling)); 
}


@end
