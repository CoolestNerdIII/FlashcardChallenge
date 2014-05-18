//
//  DeckViewController.m
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/16/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import "DeckViewController.h"
#import "CardsViewController.h"
#import "ModeSelectionViewController.h"

#define kFirstAlertViewTag 1
#define kSecondAlertViewTag 2

@interface DeckViewController ()

@end

@implementation DeckViewController

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.managedObjectContext = context;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIBarButtonItem *addButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.title = @"Decks";
    [self fetchDecks];
    
    // Preload with a "Test" Deck if empty
    if (self.fetchedResultsController.fetchedObjects.count == 0)
    {
        NSEntityDescription *deckEntityDescription = [NSEntityDescription entityForName:@"Deck"
                                                                 inManagedObjectContext:self.managedObjectContext];
        Deck *newDeck = (Deck *)[[NSManagedObject alloc] initWithEntity:deckEntityDescription
                                         insertIntoManagedObjectContext:self.managedObjectContext];
        newDeck.name = @"Deck 1";
        NSError *error;
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Error saving context: %@", error);
        }
        [self fetchDecks];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.fetchedResultsController.fetchedObjects.count;;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DeckCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Deck *deck = (Deck *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = deck.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%lu)", (unsigned long)deck.cards.count];
    return cell;
}





/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)
editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSManagedObject *deleted = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:deleted];
        
        NSError *error;
        BOOL success = [self.managedObjectContext save:&error];
        if (!success)
        {
            NSLog(@"Error saving context: %@", error);
        }
        [self fetchDecks];
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"modeSelectionSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Deck *deck = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        ModeSelectionViewController* detailViewController = [segue destinationViewController];
        detailViewController.deck = deck;
        
        //viewTaskController.managedObjectContext = self.managedObjectContext;
        //viewTaskController.managedTaskObject=taskObject;
        
        
        //Deck *deck = (Deck *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        //ModeSelectionViewController *detailViewController = [[ModeSelectionViewController alloc] initWithDeck:deck];
        //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        //[[segue destinationViewController] setDetailItem:object];
    }
}

/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 Deck *deck = (Deck *)[self.fetchedResultsController objectAtIndexPath:indexPath];
 ModeSelectionViewController *detailViewController = [[ModeSelectionViewController alloc] initWithDeck:deck];
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */
#pragma mark - Core Data Helper
-(void)fetchDecks
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Deck"];
    NSString *cacheName = [@"Deck" stringByAppendingString:@"Cache"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext
                                     sectionNameKeyPath:nil cacheName:cacheName];
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Fetch failed: %@", error);
    }
}

#pragma mark - Button Customization

- (void)add
{
    UIAlertView * inputAlert = [[UIAlertView alloc] initWithTitle:@"New Deck"
                                                          message:@"Enter a name for the new deck" delegate:self
                                                cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    inputAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    inputAlert.tag = kFirstAlertViewTag;
    [inputAlert show];
}

#pragma mark - Alert View

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kFirstAlertViewTag) {
        
        if (buttonIndex == 1)
        {
            NSEntityDescription *deckEntityDescription = [NSEntityDescription entityForName:@"Deck"
                                                                     inManagedObjectContext:self.managedObjectContext];
            
            Deck *newDeck = (Deck *)[[NSManagedObject alloc] initWithEntity:deckEntityDescription
                                             insertIntoManagedObjectContext:self.managedObjectContext];
            
            if ([[alertView textFieldAtIndex:0].text length] == 0) {
                UIAlertView * errorAlert = [[UIAlertView alloc]initWithTitle:@"LengthError" message:@"Name must have at least 1 character." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                errorAlert.alertViewStyle = UIAlertViewStyleDefault;
                errorAlert.tag = kSecondAlertViewTag;
                [errorAlert show];
            }
            else
            {
                newDeck.name  = [alertView textFieldAtIndex:0].text;
                newDeck.creationDate = [NSDate date];
                NSError *error;
                
                if (![self.managedObjectContext save:&error])
                {
                    NSLog(@"Error saving context: %@", error);
                }
                
                [self fetchDecks];
                [self.tableView reloadData];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self fetchDecks];
    [self.tableView reloadData];
}

@end
