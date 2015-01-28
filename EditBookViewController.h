//
//  EditBookViewController.h
//  ProLib
//
//  Created by Jonathan Samudio on 1/26/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditBookViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *authorField;
@property (weak, nonatomic) IBOutlet UITextField *publisherField;
@property (weak, nonatomic) IBOutlet UITextField *categoriesField;

- (IBAction)doneEditButton:(id)sender;
- (IBAction)deleteBook:(id)sender;

@end
