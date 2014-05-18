//
//  EditCardViewController.m
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/18/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import "EditCardViewController.h"

#define kFirstAlertViewTag 1
#define kSecondAlertViewTag 2

@interface EditCardViewController ()

@end

@implementation EditCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.questionTextView.text = self.card.question;
    //self.questionImage.image = _card.qImage;
    self.solutionTextView.text = self.card.answer;
    //self.solutionImage.image = _card.aImage;
    self.difficulty.selectedSegmentIndex = [self.card.rating integerValue];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)cancelPressed:(id)sender {
    if ([self.questionTextView.text isEqualToString:@""] || [self.solutionTextView.text isEqualToString:@""] ) {
        UIAlertView * deletionAlert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                                 message:@"A question and answer is required.\n Press ok to proceed, or cancel to enter more information." delegate:self
                                                       cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        deletionAlert.alertViewStyle = UIAlertViewStyleDefault;
        deletionAlert.tag = kFirstAlertViewTag;
        [deletionAlert show];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (IBAction)savePressed:(id)sender {
    
    if ([self.questionTextView.text isEqualToString:@""] || [self.solutionTextView.text isEqualToString:@""] ) {
        UIAlertView * savingError = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                               message:@"A question and answer is required.\n" delegate:self
                                                     cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        savingError.alertViewStyle = UIAlertViewStyleDefault;
        [savingError show];
    }
    else{

        _card.question = self.questionTextView.text;
        _card.answer = self.solutionTextView.text;
        _card.rating = [NSNumber numberWithInteger:(self.difficulty.selectedSegmentIndex + 1)];
        
        NSError *error;
        if (![self.deck.managedObjectContext save:&error])
        {
            NSLog(@"Error in saved pressed with saving context: %@, %@", error, [error userInfo]);
        }

        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag) {
        case kFirstAlertViewTag:
            if (buttonIndex == 1) {
                [self deleteCard];
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
            
        default:
            break;
    }
}

-(void)deleteCard{
    [self.deck.managedObjectContext deleteObject:self.card];
}

@end
