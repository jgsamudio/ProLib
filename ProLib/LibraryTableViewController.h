//
//  LibraryTableViewController.h
//  ProLib
//
//  Created by Jonathan Samudio on 1/21/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Library.h"
#import "LibraryCell.h"

//GLOBALS TO SHARE WITH OTHER VIEWS
extern Book *sharedBook;
extern NSMutableArray *sharedLibrary;

@interface LibraryTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

//OBJECT TO CONTAIN THE ENTIRE LIBRARY
@property Library *catalog;

//SPINNER VARIABLE
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

//DELETE ALL BOOKS
- (IBAction)clearAllBooks:(id)sender;

@end
