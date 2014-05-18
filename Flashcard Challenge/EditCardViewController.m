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
#define kFirstActionViewTag 1
#define kSecondActionViewTag 2

@interface EditCardViewController ()
{
    NSString * questionPlaceholder;
    NSString * solutionPlaceholder;
    UIImage * qImage;
    UIImage * sImage;
    UIImage * placeholderImage;
}

@property (strong, nonatomic) IBOutlet UITextView *activeField;
@end

@implementation EditCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    qImage = [UIImage imageWithData:self.card.qImage];
    sImage = [UIImage imageWithData:self.card.aImage];
    placeholderImage = [UIImage imageNamed:@"imagePlaceholder.png"];
    
    if (qImage == nil) {
        qImage = placeholderImage;
    }
    
    if (sImage == nil) {
        sImage = placeholderImage;
    }
    
    [self hideKeyboardWhenBackgroundIsTapped];
    
    self.questionTextView.text = self.card.question;
    self.questionImage.image = qImage;
    self.solutionTextView.text = self.card.answer;
    self.solutionImage.image = sImage;
    self.difficulty.selectedSegmentIndex = [self.card.rating integerValue]-1;
    self.nicknameField.text = self.card.nickname;
    
    
    questionPlaceholder = @"Enter Question Here";
    solutionPlaceholder = @"Enter Answer Here";
    
    if ([self.questionTextView.text isEqualToString:questionPlaceholder] )
        self.questionTextView.textColor = [UIColor lightGrayColor];
    
    if ([self.solutionTextView.text isEqualToString:solutionPlaceholder] )
        self.solutionTextView.textColor = [UIColor lightGrayColor];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{

    // Register for keyboard notifications while the view is visible.
    [[NSNotificationCenter defaultCenter] addObserver:self
selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification
object:self.view.window]; [[NSNotificationCenter defaultCenter] addObserver:self
                                                                   selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification
                                                                     object:self.view.window];
}

-(void)viewWillDisappear:(BOOL)animated{
    // Unregister for keyboard notifications while the view is not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - Handle Core Data

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
        self.card.nickname = self.nicknameField.text;

        //Save Image if Image is set and not the placeholder
        if (self.questionImage.image != placeholderImage)
            self.card.qImage = UIImagePNGRepresentation(self.questionImage.image);
        if (self.solutionImage.image != placeholderImage)
            self.card.aImage = UIImagePNGRepresentation(self.solutionImage.image);

        
        NSError *error;
        if (![self.deck.managedObjectContext save:&error])
        {
            NSLog(@"Error in saved pressed with saving context: %@, %@", error, [error userInfo]);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)deleteCard{
    [self.deck.managedObjectContext deleteObject:self.card];
    
    NSError *error;
    BOOL success = [self.deck.managedObjectContext save:&error];
    if (!success)
        NSLog(@"Error saving context: %@", error);
    

}

#pragma mark - AlertView Delegate

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

#pragma mark - Keyboard Interaction

- (void)hideKeyboardWhenBackgroundIsTapped
{
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tgr];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)keyboardDidShow:(NSNotification *)n {
    // Find top of keyboard input view (i.e. picker)
    CGRect keyboardRect = [[[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil]; CGFloat keyboardTop = keyboardRect.origin.y;
    // Resize scroll view
    CGRect newScrollViewFrame = CGRectMake(0, 0, self.view.bounds.size.width, keyboardTop);
    newScrollViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    [self.scrollView setFrame:newScrollViewFrame];
    // Scroll to the active Text-Field
    [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES]; }

- (void)keyboardWillHide:(NSNotification *)n {
    CGRect defaultFrame = CGRectMake(self.scrollView.frame.origin.x,
                                     self.scrollView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    // Reset Scrollview to the same size as the containing view
    [self.scrollView setFrame:defaultFrame];
    // Scroll to the top again
    [self.scrollView scrollRectToVisible:self.questionTextView.frame
                                animated:YES];
}

#pragma mark - Textview Delegates
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == self.questionTextView) {
        if ([textView.text isEqualToString:questionPlaceholder]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor]; //optional
        }
    }
    else if (textView == self.solutionTextView){
        if ([textView.text isEqualToString:solutionPlaceholder]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor]; //optional
        }
    }
    _activeField =textView;
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
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
    _activeField = nil;
    [textView resignFirstResponder];
}

#pragma mark - Add image touch functionality

-(IBAction)editQImage:(id)sender{
    UIActionSheet *qActionScheet = [[UIActionSheet alloc] initWithTitle:@"Upload Image From: " delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    qActionScheet.tag = kFirstActionViewTag;
    [qActionScheet showInView:self.view];
}

-(IBAction)editSImage:(id)sender{
    UIActionSheet *sActionScheet = [[UIActionSheet alloc] initWithTitle:@"Upload Image From: " delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    sActionScheet.tag = kSecondActionViewTag;
    [sActionScheet showInView:self.view];
}

#pragma mark - Delegates for UIImagePicker

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 2) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.view.tag = (actionSheet.tag ==kFirstActionViewTag ? kFirstActionViewTag :kSecondActionViewTag);
        imagePicker.allowsEditing = NO;
        
        switch (buttonIndex) {
            case 0:
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
                
            default:
                break;
        }

        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (picker.view.tag) {
        case kFirstActionViewTag:
            qImage = info[UIImagePickerControllerOriginalImage];
            [self.questionImage setImage:qImage];
            break;
        case kSecondActionViewTag:
            sImage = info[UIImagePickerControllerOriginalImage];
            self.solutionImage.image = sImage;
            [self.solutionImage setImage:sImage];
            break;
            
        default:
            break;
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
