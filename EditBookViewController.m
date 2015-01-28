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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Initialize textfields of book for edit
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
    
    //Check if the user made any changes
    if( ![sharedBook.title isEqual:self.titleField.text] ||
          ![sharedBook.author isEqual:self.authorField.text] ||
            ![sharedBook.publisher isEqual:self.publisherField.text] ||
              ![sharedBook.categories isEqual:self.authorField.text] ) {
    
        sharedBook.title = self.titleField.text;
        sharedBook.author = self.authorField.text;
        sharedBook.publisher = self.publisherField.text;
        sharedBook.categories = self.categoriesField.text;
    
        //JSON Dictionary for book update
        NSDictionary *jsonDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                              sharedBook.title, @"title", sharedBook.author, @"author",
                              sharedBook.publisher, @"publisher", sharedBook.categories, @"categories",nil];
        [sharedBook updateBook:jsonDict];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteBook:(id)sender {
    NSLog(@"EditBookViewController: Delete Button Pressed!");
    UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Delete Book?"
                                                           message: @"Are you sure you want to delete this book?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [messageAlert show];
    
}

//Handle AlertView Button Press
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
