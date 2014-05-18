//
//  CardsViewController.m
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/16/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import "CardsViewController.h"
#import "EditCardViewController.h"

@interface CardsViewController ()

@end

@implementation CardsViewController

- (id)initWithDeck:(Deck *)deck
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.deck = deck;
    }
    return self;
}

- (IBAction)add{}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.deck.name;
    [self fetchCards];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return self.deck.cards.count;
    return self.fetchedResultsController.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CardCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Card *card = (Card *)[self.fetchedResultsController objectAtIndexPath:indexPath];

    //Card *card = [self.deck.cards.allObjects objectAtIndex:indexPath.row];
    /*
    if ([card.nickname isEqualToString:@""]) {
        cell.textLabel.text = card.question;
    }
    else
    {
        cell.textLabel.text = card.nickname;

    }*/
    cell.textLabel.text = card.question;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Card *deleted = [self.deck.cards.allObjects objectAtIndex:indexPath.row];
        [self.deck.managedObjectContext deleteObject:deleted];
        NSError *error;
        BOOL success = [self.deck.managedObjectContext save:&error];
        if (!success)
        {
            NSLog(@"Error saving context: %@", error);
        }
        [self fetchCards];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    EditCardViewController *vc = segue.destinationViewController;

    if ([segue.identifier isEqualToString:@"newCardSegue"]) {
        NSEntityDescription *cardEntityDescription = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:self.deck.managedObjectContext];
        Card *newCard = (Card *)[[NSManagedObject alloc] initWithEntity:cardEntityDescription
                                         insertIntoManagedObjectContext:self.deck.managedObjectContext];
        [self.deck addCardsObject:newCard];
        
        NSError *error;
        if (![self.deck.managedObjectContext save:&error])
        {
            NSLog(@"Error in saved pressed with saving context: %@, %@", error, [error userInfo]);
        }

        vc.card = newCard;
        vc.deck = self.deck;
    }
    else if ([segue.identifier isEqualToString:@"cardEditSegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Card *card = [self.deck.cards.allObjects objectAtIndex:indexPath.row];
        vc.card = card;
        vc.deck = self.deck;

    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.deck.managedObjectContext refreshObject:self.deck mergeChanges:YES];
    [self fetchCards];
    [self.tableView reloadData];
}

#pragma mark - Core Data Helper

-(void)fetchCards
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Card"];
    NSString *cacheName = [@"Card" stringByAppendingString:@"Cache"];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:
                               [NSSortDescriptor sortDescriptorWithKey:@"question" ascending:YES],
                                    [NSSortDescriptor sortDescriptorWithKey:@"nickname" ascending:YES], nil];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest managedObjectContext:self.deck.managedObjectContext
                                     sectionNameKeyPath:nil cacheName:cacheName];
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Fetch failed: %@", error);
    }
}


@end
