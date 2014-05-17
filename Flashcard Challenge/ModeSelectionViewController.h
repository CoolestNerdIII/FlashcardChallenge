//
//  ModeSelectionViewController.h
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/16/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "Card.h"

@interface ModeSelectionViewController : UITableViewController

@property (strong, nonatomic)Deck *deck;

- (id)initWithDeck:(Deck *) deck;



@end
