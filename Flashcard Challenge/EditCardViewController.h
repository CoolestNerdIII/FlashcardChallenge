//
//  EditCardViewController.h
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/18/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "Card.h"

@interface EditCardViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *questionImage;
@property (strong, nonatomic) IBOutlet UIImageView *solutionImage;

@property (strong, nonatomic) IBOutlet UITextView *questionTextView;
@property (strong, nonatomic) IBOutlet UITextView *solutionTextView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *difficulty;

- (IBAction)cancelPressed:(id)sender;
- (IBAction)savePressed:(id)sender;

@property (strong, nonatomic)Card *card;
@property (strong, nonatomic)Deck *deck;

@end
