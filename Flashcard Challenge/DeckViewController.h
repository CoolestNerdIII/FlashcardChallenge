//
//  DeckViewController.h
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/16/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface DeckViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic)NSFetchedResultsController *fetchedResultsController;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
