//
//  CardEditViewController.m
//  Flashcard Challenge
//
//  Created by Paul Wilson on 5/16/14.
//  Copyright (c) 2014 Paul Wilson. All rights reserved.
//

#import "CardEditViewController.h"

@interface CardEditViewController ()

@end

@implementation CardEditViewController

+ (void)editCard:(Card *)card inNavigationController:(UINavigationController *)navigationController completion:(CardEditViewControllerCompletionHandler)completionHandler
{
    CardEditViewController *editViewController = [[CardEditViewController alloc] initWithCard:card completion:completionHandler];
    [navigationController pushViewController:editViewController animated:YES];
}

- (id)initWithCard:(Card *)card completion:(CardEditViewControllerCompletionHandler)completionHandler{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _completionHandler = completionHandler;
        _card = card;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.questionTextView.text = _card.question;
    //self.questionImage.image = _card.qImage;
    self.solutionTextView.text = _card.answer;
    //self.solutionImage.image = _card.aImage;
    self.difficulty.selectedSegmentIndex = [_card.rating integerValue];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self action:@selector(cancel)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel
{
    _completionHandler(self, YES);
}


/*- (IBAction)segmentSwitch:(id)sender {

    switch(self.difficulty.selectedSegmentIndex)
    {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
            
    }
    
}
*/

- (void)done
{

    _card.question = self.questionTextView.text;
    _card.answer = self.solutionTextView.text;
    _card.rating = [NSNumber numberWithInteger:self.difficulty.selectedSegmentIndex];
    
    //ToDO
    //_card.qImage = ...
    //_card.aImage = ...
    _completionHandler(self, NO);
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

- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

@end
