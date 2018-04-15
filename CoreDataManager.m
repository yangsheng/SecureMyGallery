//
//  CoreDataManager.m
//  PhotoVault
//
//  Created by Asif Seraje on 12/20/15.
//
//

#import "CoreDataManager.h"

@implementation CoreDataManager


- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)saveContactToAddressBook : (NSDictionary *) dict{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];

    [newContact setValue:[dict valueForKey:@"fastN"] forKey:@"firstName"];
    [newContact setValue:[dict valueForKey:@"lastN"] forKey:@"lastName"];
    [newContact setValue:[dict valueForKey:@"emailN"] forKey:@"email"];
    [newContact setValue:[dict valueForKey:@"phoneN"] forKey:@"phone"];
    [newContact setValue:[dict valueForKey:@"url"] forKey:@"url"];

    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        
    }
    
    NSLog(@"data saved");
    
//    [self fetchContactsFromDB];
    
    
    
}

-(NSArray *)fetchContactsFromDB{

    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Contact"];
    return [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
}

-(NSArray *)fetchPassBookFromDB{

    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Password"];
    return [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

@end
