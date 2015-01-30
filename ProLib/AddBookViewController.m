//
//  AddBookViewController.m
//  ProLib
//
//  Created by Jonathan Samudio on 1/21/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import "AddBookViewController.h"
#import "LibraryTableViewController.h"
#import "Library.h"

@interface AddBookViewController () <UITextFieldDelegate>

@end

@implementation AddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"AddBookController: viewDidLoad");
    
    [self.titleField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//DONE BUTTON ACTION
// - Checks if any fields have text
// - Prompts the user if there is text
// - Dismiss to LibraryTableView Controller
- (IBAction)doneBook:(id)sender {
    NSLog(@"AddBookController: Done Pressed!");
    if(![self.titleField.text  isEqual: @""] || ![self.authorField.text  isEqual: @""]
       || ![self.publisherField.text  isEqual: @""] || ![self.categoryField.text isEqual:@""]){
        
        UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Discard Information?"
                                                               message: @"Are you sure you want to discard your information?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [messageAlert show];
        
    }
    else{[self dismissViewControllerAnimated:YES completion:nil];}
}

//HANDLE ALERTVIEW BUTTON PRESS
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        NSLog(@"AddBookController: OK Button Pressed");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        NSLog(@"AddBookController: Cancel Button Pressed");
    }
}

//SUBMIT BOOK BUTTON
- (IBAction)submitBook:(id)sender {
    NSLog(@"AddBookController: Submit Pressed!");
    
    //CHECKS IF ANY FIELDS ARE BLANK
    if([self.titleField.text  isEqual: @""] || [self.authorField.text  isEqual: @""]
       || [self.publisherField.text isEqual: @""] || [self.categoryField.text isEqual: @""]){
        
        UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Fields Left Blank!"
                                    message: @"Please fill in all fields!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [messageAlert show];
    }
    else {
        
        //CREATE A NEW BOOK TO ADD TO LIBRARY
        Book * bookToAdd = [[Book alloc] init];
        bookToAdd.author = self.authorField.text;
        bookToAdd.categories = self.categoryField.text;
        bookToAdd.lastCheckedOutBy = @"";
        bookToAdd.publisher = self.publisherField.text;
        bookToAdd.title = self.titleField.text;
        
        Library *sharedLib = [Library sharedSingleton];
        [sharedLib addBook:bookToAdd];
        
        //GO BACK TO LIBRARY TABLE VIEW
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([textField isEqual:self.titleField]) {  [self.authorField becomeFirstResponder]; }
    else if([textField isEqual:self.authorField]) {  [self.publisherField becomeFirstResponder]; }
    else if([textField isEqual:self.publisherField]) {  [self.categoryField becomeFirstResponder]; }
    else if([textField isEqual:self.categoryField]) {
        [self submitBook:self];
    }
    
    NSLog(@"ABVC: RETURN PRESSED!");
    return true;
}

@end
