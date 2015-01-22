//
//  LibraryTableViewController.m
//  ProLib
//
//  Created by Jonathan Samudio on 1/21/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import "LibraryTableViewController.h"

@interface LibraryTableViewController ()

@end

@implementation LibraryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"LibraryTableViewController: viewDidLoad");
    
    //Initialize Library Object
    self.catalog = [[Library alloc] init];
    
    //Display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {return 70;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.catalog.bookList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LibraryCellIdentifier = @"LibraryCell";
    
    LibraryCell *cell = (LibraryCell *)[tableView dequeueReusableCellWithIdentifier:LibraryCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LibraryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Book * bk = [self.catalog.bookList objectAtIndex:indexPath.row];
    
    cell.bookTitle.text = bk.title;
    cell.bookAuthors.text = bk.author;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath");
    /*UIAlertView *messageAlert = [[UIAlertView alloc]
     initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];*/
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Row Selected" message: @"Clicked Message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display the Hello World Message
    [messageAlert show];
    
    // Checked the selected row
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   // cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
