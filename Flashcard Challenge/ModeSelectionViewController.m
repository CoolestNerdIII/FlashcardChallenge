//
//  ModeSelectionViewController.m
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/16/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import "ModeSelectionViewController.h"
#import "CardsViewController.h"

@interface ModeSelectionViewController (){
    NSArray * section1;
    NSArray * section1Subtitles;
    NSArray * section2;
}

@end

@implementation ModeSelectionViewController


- (id)initWithDeck:(Deck *)deck
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.deck = deck;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //NSString *Title = @"Information for ";
    //Title = [NSString stringWithFormat:@"%@%@", Title, self.deck.name];
    //self.title = Title;
    self.title = self.deck.name;
    
    section1 = [[NSArray alloc] initWithObjects:@"Traditional", @"Quiz", @"Challenge", nil];
    section1Subtitles = [[NSArray alloc] initWithObjects:@"See Question, Flip for Answer", @"Test your knowledge", @"Test your knowledge with friends", nil];
    section2 = [[NSArray alloc] initWithObjects:@"Number of Cards", @"View Deck", @"Knowledge Update", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 // Return the number of sections.
 return 2;
 }

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 // Return the number of rows in the section.
 switch (section) {
 case 0:
 return [section1 count];
 break;
 case 1:
 return [section2 count];
 default:
 break;
 }
 return 0;
 }
 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
     switch (indexPath.section) {
     case 0:
     cell.textLabel.text = [section1 objectAtIndex:indexPath.row];
     cell.detailTextLabel.text = [section1Subtitles objectAtIndex:indexPath.row];
     break;
     case 1:
     if (indexPath.row == 0){
     cell.textLabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)self.deck.cards.count, @"cards in this deck"];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }
     
     else
     cell.textLabel.text = [section2 objectAtIndex:indexPath.row];
     default:
     break;
     }
    if (indexPath.row == 0 && indexPath.section == 1){
        cell.textLabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)self.deck.cards.count, @"cards in this deck"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
 
 */
/*
 -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 if (section == 0)
 return @"Available Modes";
 else if(section == 1)
 return @"Deck Information";
 else
 return @"";
 }
 
 -(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
 return @" ";
 }
*/

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            
            break;
        case 1:
            if (indexPath.row == 1) {
                CardsViewController *detailViewController = [[CardsViewController alloc] initWithDeck:self.deck];
                [self.navigationController pushViewController:detailViewController animated:YES];
            }
            
            break;
        default:
            break;
    }
    
}*/

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString:@"viewDeckSegue"])
    {
        if (indexPath.section == 1 && indexPath.row == 1) {
           
            CardsViewController *detailViewController = segue.destinationViewController;
            detailViewController.deck = self.deck;
        }
    }
}




@end
