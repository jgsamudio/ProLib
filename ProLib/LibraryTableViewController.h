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

extern Book *sharedBook;
extern NSMutableArray *sharedLibrary;

@interface LibraryTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property Library *catalog;

@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@end
