//
//  IBIconHandler.m
//  IconsWebBrowser
//
//  Created by Asif Seraje on 3/27/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import "IBIconHandler.h"
#import "Helper.h"

@implementation IBIconHandler
@synthesize sites;

- (id)init
{
    self = [super init];
    if (self) {
        NSString *iconsFilePath = [Helper getFilePathWithFilename:@"sites.plist"];
        sites = [[NSDictionary dictionaryWithContentsOfFile:iconsFilePath] objectForKey:@"sites"];
        if (sites == nil) {
            iconsFilePath = [[NSBundle mainBundle] pathForResource:@"DefaultSites" ofType:@"plist"];
            sites = [[NSDictionary dictionaryWithContentsOfFile:iconsFilePath] objectForKey:@"sites"];
        }
    }
    return self;
}

+ (IBIconHandler *)getInstance
{
    static IBIconHandler *handler;
    if (handler == nil) {
        handler = [[IBIconHandler alloc] init];
    }
    return handler;
}

+ (NSArray *)sites
{
    return [IBIconHandler getInstance].sites;
}

+ (void)saveNewSites:(NSArray *)newSites
{
    NSString *iconsFilePath = [Helper getFilePathWithFilename:@"sites.plist"];
    
    NSLog(@"%@",iconsFilePath);

    [IBIconHandler getInstance].sites = newSites;
    
    // create NSData from dictionary
   // NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:newSites format:nspro errorDescription:&error];
    
    [[NSDictionary dictionaryWithObjectsAndKeys:newSites, @"sites", nil] writeToFile:iconsFilePath atomically:NO];
}

+ (void)addNewSite:(NSDictionary *)newSite
{
    [IBIconHandler saveNewSites:[[IBIconHandler getInstance].sites arrayByAddingObject:newSite]];
}

@end
