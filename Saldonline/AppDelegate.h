//
//  AppDelegate.h
//  Saldonline
//
//  Created by Paulo Cesar on 18/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Pixate/Pixate.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong,nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
