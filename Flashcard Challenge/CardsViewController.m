//
//  CardsViewController.m
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/16/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import "CardsViewController.h"
#import "EditCardViewController.h"
#import "CardsTableViewCell.h"


#define kCardsTableSortQuestion 0
#define kCardsTableSortNickname 1
#define kCardsTableSortDifficulty 2
#define kCardsTableSortSolution 3

@interface CardsViewController (){
    NSString * sortKey;
    NSString * keyPath;
}

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
    sortKey = @"question";
    keyPath = sortKey;
    
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
    //return 1;
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return self.deck.cards.count;
    //return self.fetchedResultsController.fetchedObjects.count;
    
    id <NSFetchedResultsSectionInfo> sectionInfo;
    sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CardCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CardsTableViewCell *cell = (CardsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[CardsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    cell.cardName.text = card.nickname;
    cell.questionDetails.text = card.question;
    switch ([card.rating integerValue]) {
        case 1:
            cell.difficultyName.text = @"Easy";
            cell.difficultColor.backgroundColor = [UIColor greenColor];
            break;
        case 2:
            cell.difficultyName.text = @"Medium";
            cell.difficultColor.backgroundColor = [UIColor yellowColor];
            cell.difficultyName.textColor = [UIColor purpleColor];

            break;
        case 3:
            cell.difficultyName.text = @"Hard";
            cell.difficultColor.backgroundColor = [UIColor redColor];

            break;
    }
    if (card.qImage != nil) {
        cell.cardImage.image = [UIImage imageWithData:card.qImage];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo;
    sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
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
                                    [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES], nil];
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest managedObjectContext:self.deck.managedObjectContext
                                     sectionNameKeyPath:keyPath cacheName:cacheName];
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Fetch failed: %@", error);
    }
    [self.tableView reloadData];
}


- (IBAction)cardSortChanged:(id)sender {
    
    switch (self.cardSortControl.selectedSegmentIndex)
    {
        case kCardsTableSortQuestion:
            sortKey = @"question";
            keyPath = sortKey;
            break;
        case kCardsTableSortNickname:
            sortKey = @"nickname";
            keyPath = sortKey;
            break;
        case kCardsTableSortDifficulty:
            sortKey = @"rating";
            keyPath = sortKey;
            break;
        case kCardsTableSortSolution:
            sortKey = @"answer";
            keyPath = sortKey;
            break;
        default:
            sortKey = @"question";
            keyPath = sortKey;
            break;
    }
    [self fetchCards];
    
}
@end
