//
//  CardsTableViewCell.m
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/18/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import "CardsTableViewCell.h"

@implementation CardsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.cardName.text = ;
        //self.difficultyName.text;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
