//
//  CardEditViewController.h
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/16/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "Card.h"

@class CardEditViewController;
typedef void (^CardEditViewControllerCompletionHandler)(CardEditViewController *sender,
                                                        BOOL canceled);

@interface CardEditViewController : UIViewController
{
@private
    CardEditViewControllerCompletionHandler _completionHandler;
    Card *_card;
}

@property (strong, nonatomic) IBOutlet UIImageView *questionImage;
@property (strong, nonatomic) IBOutlet UIImageView *solutionImage;

@property (strong, nonatomic) IBOutlet UITextView *questionTextView;
@property (strong, nonatomic) IBOutlet UITextView *solutionTextView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *difficulty;

- (id)initWithCard:(Card *)card completion:(CardEditViewControllerCompletionHandler)completionHandler;

+ (void)editCard:(Card *)card
inNavigationController:(UINavigationController *)navigationController completion:(CardEditViewControllerCompletionHandler)completionHandler;

@end
