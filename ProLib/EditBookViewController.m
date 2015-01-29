//
//  EditBookViewController.m
//  ProLib
//
//  Created by Jonathan Samudio on 1/26/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import "EditBookViewController.h"
#import "LibraryTableViewController.h"
#import "Library.h"

@interface EditBookViewController ()

@end

@implementation EditBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //INITIALIZE TEXTFIELDS WITH BOOK INFORMATION
    self.titleField.text = sharedBook.title;
    self.authorField.text = sharedBook.author;
    self.publisherField.text = sharedBook.publisher;
    self.categoriesField.text = sharedBook.categories;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneEditButton:(id)sender {
    
    //CHECK IF THE USER MADE ANY CHANGES
    if( ![sharedBook.title isEqual:self.titleField.text] ||
          ![sharedBook.author isEqual:self.authorField.text] ||
            ![sharedBook.publisher isEqual:self.publisherField.text] ||
              ![sharedBook.categories isEqual:self.categoriesField.text] ) {
    
        //APPLY CHANGES TO BOOK DETAIL VIEW
        sharedBook.title = self.titleField.text;
        sharedBook.author = self.authorField.text;
        sharedBook.publisher = self.publisherField.text;
        sharedBook.categories = self.categoriesField.text;
    
        //JSON DICTIONARY FOR BOOK UPDATE
        NSDictionary *jsonDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                              sharedBook.title, @"title", sharedBook.author, @"author",
                              sharedBook.publisher, @"publisher", sharedBook.categories, @"categories",nil];
        [sharedBook updateBook:jsonDict];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//DELETE BOOK BUTTON
// - Prompts the user if they wish to delete book
- (IBAction)deleteBook:(id)sender {
    NSLog(@"EditBookViewController: Delete Button Pressed!");
    UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Delete Book?"
                                                           message: @"Are you sure you want to delete this book?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [messageAlert show];
    
}

//HANDLE ALERTVIEW BUTTON PRESS
// - Segues to Library Table View
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        NSLog(@"EditBookViewController: Delete Button Pressed");
        [sharedBook deleteBook];
        [self performSegueWithIdentifier:@"exitToLibrarySegue" sender:self];
    }
    else{
        NSLog(@"EditBookViewController: Cancel Button Pressed");
    }
}

@end
