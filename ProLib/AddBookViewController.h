//
//  AddBookViewController.h
//  ProLib
//
//  Created by Jonathan Samudio on 1/21/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBookViewController : UITableViewController <UIAlertViewDelegate>

//NEW BOOK PROPERTIES
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *authorField;
@property (weak, nonatomic) IBOutlet UITextField *publisherField;
@property (weak, nonatomic) IBOutlet UITextField *categoryField;

//DONE BUTTON
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

//SUBMIT BUTTON
// - Add new book to library
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
