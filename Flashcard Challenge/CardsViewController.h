//
//  CardsViewController.h
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/16/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "Card.h"

@interface CardsViewController : UITableViewController

@property (strong, nonatomic)Deck *deck;
@property (strong, nonatomic)NSFetchedResultsController *fetchedResultsController;


@property (strong, nonatomic) IBOutlet UISegmentedControl *cardSortControl;

- (id)initWithDeck:(Deck *) deck;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addCard;
@property (strong, nonatomic) IBOutlet UIView *tableHeader;
- (IBAction)cardSortChanged:(id)sender;

@end
