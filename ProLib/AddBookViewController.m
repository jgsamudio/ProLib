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

@interface AddBookViewController ()

@end

@implementation AddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"AddBookController: viewDidLoad");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneBook:(id)sender {
    NSLog(@"AddBookController: Done Pressed!");
    if(![self.titleField.text  isEqual: @""] || ![self.authorField.text  isEqual: @""]
       || ![self.publisherField.text  isEqual: @""]){
        
        UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Discard Information?"
                                                               message: @"Are you sure you want to discard your information?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [messageAlert show];
        
    }
    else{[self dismissViewControllerAnimated:YES completion:nil];}
}

//Handle AlertView Button Press
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

- (IBAction)submitBook:(id)sender {
    NSLog(@"AddBookController: Submit Pressed!");
    
    //Check if fields are blank
    if([self.titleField.text  isEqual: @""] || [self.authorField.text  isEqual: @""]
       || [self.publisherField.text  isEqual: @""]){
        
        UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Fields Left Blank!"
                                    message: @"Please fill in all fields!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [messageAlert show];
    }
    else {//Add Book to Library
        
        //PREP DICTIONARY CONTAINER
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:
                              self.titleField.text, @"title", self.publisherField.text, @"publisher",
                              @"Joe", @"lastCheckedOutBy", self.categoryField.text, @"categories",
                              self.authorField.text, @"author", nil];
        
        NSLog(@"DICT: %@", dict);
        
        //PREPARE JSON STRING
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        
        //REQUEST
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://prolific-interview.herokuapp.com/54bd1bd34fb6c2000805208a/books/"]];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        //HANDLE RESPONSE
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                NSLog(@"Error!");
            } else {
                NSString *responseText = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
                NSLog(@"Response: %@", responseText);
                
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSLog(@"Response DICT: %@", dictionary);
                
                //
            }
            
        }];
    }
}

@end
