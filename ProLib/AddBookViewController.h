//
//  AddBookViewController.h
//  ProLib
//
//  Created by Jonathan Samudio on 1/21/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBookViewController : UITableViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UITextField *titleField;

@property (weak, nonatomic) IBOutlet UITextField *authorField;

@property (weak, nonatomic) IBOutlet UITextField *publisherField;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UIView *tagView;

@property (strong, nonatomic) IBOutlet UITableView *addTable;

@property (weak, nonatomic) IBOutlet UITextField *categoryField;

@end
