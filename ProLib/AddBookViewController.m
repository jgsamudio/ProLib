//
//  AddBookViewController.m
//  ProLib
//
//  Created by Jonathan Samudio on 1/21/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import "AddBookViewController.h"

@interface AddBookViewController ()

@end

@implementation AddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"AddBookController: viewDidLoad");
    
    // setup some frames
    UITextField* text = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
    
    text.placeholder = [NSString stringWithFormat:@"Enter data in field" ];
    
    [self.tagView addSubview:text];
    
  
    
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
    if([self.titleField.text  isEqual: @""] && [self.authorField.text  isEqual: @""]
       && [self.publisherField.text  isEqual: @""]){
        
        UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Fields Left Blank!"
                                    message: @"Please fill in all fields!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [messageAlert show];
    }
    else {//Add Book to Library
        
    }
}

@end
