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

- (IBAction)add
{
    /*
    NSEntityDescription *wordEntityDescription = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:self.deck.managedObjectContext];
    Card *newCard = (Card *)[[NSManagedObject alloc] initWithEntity:wordEntityDescription
                                     insertIntoManagedObjectContext:self.deck.managedObjectContext];
    [self.deck addCardsObject:newCard];
    NSLog(@"Initial State");
    NSLog(@"%@", newCard.question);
    NSLog(@"%@", newCard.answer);

    
    //Deck *deck = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    CardEditViewController *vc = [[CardEditViewController alloc] init];
    vc.card = newCard;
    */
    /*
    [CardEditViewController editCard:newCard inNavigationController:self.navigationController completion:^(CardEditViewController *sender, BOOL canceled)
     {
         if (canceled)
         {
             [self.deck.managedObjectContext deleteObject:newCard];
         }
         else
         {
             [self.deck addCardsObject:newCard];
             
             NSError *error;
             if (![self.deck.managedObjectContext save:&error])
             {
                 NSLog(@"Error saving context: %@", error);
             }
             [self.tableView reloadData];
         }
         [self.navigationController popViewControllerAnimated:YES];
     }];*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
     UIBarButtonItem *addButton =
     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
     target:self action:@selector(add)];
     self.navigationItem.rightBarButtonItem = addButton;*/
    
    self.title = self.deck.name;
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
    return self.deck.cards.count;
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
    
    Card *card = [self.deck.cards.allObjects objectAtIndex:indexPath.row];
    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected");
    /*
    Card *card = [self.deck.cards.allObjects objectAtIndex:indexPath.row];
    [CardEditViewController editCard:card inNavigationController:self.navigationController completion:^(CardEditViewController *sender, BOOL canceled)
     {
         NSError *error;
         if (![self.deck.managedObjectContext save:&error])
         {
             NSLog(@"Error saving context: %@", error);
         }
         [self.tableView reloadData];
         [self.navigationController popViewControllerAnimated:YES];
     }];*/
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    EditCardViewController *vc = segue.destinationViewController;
    NSLog(@"%@", segue.identifier);

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
    //[self fetchDecks];
    //[self.deck.managedObjectContext refreshObject:self.deck mergeChanges:YES];
    [self.tableView reloadData];
}

#pragma mark - Core Data Helper

-(void)fetchCards
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Card"];
    NSString *cacheName = [@"Card" stringByAppendingString:@"Cache"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"question" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
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
