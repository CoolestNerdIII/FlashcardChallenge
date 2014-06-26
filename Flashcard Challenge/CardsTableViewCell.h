//
//  CardsTableViewCell.h
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/18/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cardImage;
@property (strong, nonatomic) IBOutlet UILabel *cardName;
@property (strong, nonatomic) IBOutlet UILabel *difficultyName;
@property (strong, nonatomic) IBOutlet UITextView *questionDetails;
@property (strong, nonatomic) IBOutlet UIView *difficultColor;

@end
