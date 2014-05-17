//
//  Card.h
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/16/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Deck;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSData * qImage;
@property (nonatomic, retain) NSData * aImage;
@property (nonatomic, retain) NSNumber * numCorrect;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) Deck *deck;

@end
