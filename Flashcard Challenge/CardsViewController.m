//
//  CardsViewController.m
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/16/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import "CardsViewController.h"
#import "CardEditViewController.h"

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
    
    NSEntityDescription *wordEntityDescription = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:self.deck.managedObjectContext];
    Card *newCard = (Card *)[[NSManagedObject alloc] initWithEntity:wordEntityDescription
                             insertIntoManagedObjectContext:self.deck.managedObjectContext];
    
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
    
    }];
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *addButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = addButton;
    
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
    // Return the number of sections.
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Card *card = [self.deck.cards.allObjects objectAtIndex:indexPath.row];
    
    cell.textLabel.text = card.question;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
