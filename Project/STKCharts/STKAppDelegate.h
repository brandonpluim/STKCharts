//
//  STKAppDelegate.h
//  STKCharts
//
//  Created by Rick Roberts on 12/30/13.
//  Copyright (c) 2013 Street Technology, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;

@end
