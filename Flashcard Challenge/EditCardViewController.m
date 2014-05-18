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
{
    NSString * questionPlaceholder;
    NSString * solutionPlaceholder;
    UIImage * qImage;
    UIImage * sImage;
    
}
@end

@implementation EditCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    qImage = [UIImage imageWithData:self.card.qImage];
    sImage = [UIImage imageWithData:self.card.aImage];
    
    if (qImage == nil) {
        qImage = [UIImage imageNamed:@"Small_Question_Mark@2x.png"];
    }
    
    if (sImage == nil) {
        sImage = [UIImage imageNamed:@"Small_Question_Mark.png"];
    }
    
    [self hideKeyboardWhenBackgroundIsTapped];
    
    self.questionTextView.text = self.card.question;
    self.questionImage.image = qImage;
    self.solutionTextView.text = self.card.answer;
    self.solutionImage.image = sImage;
    self.difficulty.selectedSegmentIndex = [self.card.rating integerValue];
    
    
    questionPlaceholder = @"Enter Question Here";
    solutionPlaceholder = @"Enter Answer Here";
    
    if ([self.questionTextView.text isEqualToString:questionPlaceholder] )
        self.questionTextView.textColor = [UIColor lightGrayColor];
    
    if ([self.solutionTextView.text isEqualToString:solutionPlaceholder] )
        self.solutionTextView.textColor = [UIColor lightGrayColor];
    
    //Add ability to tap to edit picture
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editQImage:)];
    [tapRecognizer setNumberOfTapsRequired:1];

    [self.questionImage addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editSImage:)];
    [tapRecognizer2 setNumberOfTapsRequired:1];
    [self.solutionImage addGestureRecognizer:tapRecognizer2];
    
    
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
    [self hideKeyboard];
    if ([self.questionTextView.text isEqualToString:@""] || [self.solutionTextView.text isEqualToString:@""] ||
        [self.questionTextView.text isEqualToString:questionPlaceholder] || [self.solutionTextView.text isEqualToString:solutionPlaceholder]) {
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
    [self hideKeyboard];
    
    if ([self.questionTextView.text isEqualToString:@""] || [self.solutionTextView.text isEqualToString:@""] ||
        [self.questionTextView.text isEqualToString:questionPlaceholder] || [self.solutionTextView.text isEqualToString:solutionPlaceholder]) {
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
        self.card.qImage = UIImagePNGRepresentation(self.questionImage.image);
        self.card.aImage = UIImagePNGRepresentation(self.solutionImage.image);
        
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

#pragma mark - INTERACTION

- (void)hideKeyboardWhenBackgroundIsTapped
{
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tgr];
}
- (void)hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Textview classes
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"Began Editting");
    NSLog(@"%@", textView);
    if (textView == self.questionTextView) {
        if ([textView.text isEqualToString:questionPlaceholder]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor]; //optional
            NSLog(@"Yeah");
        }
    }
    else if (textView == self.solutionTextView){
        if ([textView.text isEqualToString:solutionPlaceholder]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor]; //optional
        }
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"End Editting");
    if (textView == self.questionTextView) {
        if ([textView.text isEqualToString:@""]) {
            textView.text = questionPlaceholder;
            textView.textColor = [UIColor lightGrayColor]; //optional
        }
    }
    else if (textView == self.solutionTextView){
        if ([textView.text isEqualToString:@""]) {
            textView.text = solutionPlaceholder;
            textView.textColor = [UIColor lightGrayColor]; //optional
        }
    }
    
    [textView resignFirstResponder];
}

#pragma mark - Add image touch functionality

-(IBAction)editQImage:(id)sender{
    NSLog(@"Touch Registered");
    
}

-(IBAction)editSImage:(id)sender{}

@end