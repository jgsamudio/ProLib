//
//  LibraryTableViewController.m
//  ProLib
//
//  Created by Jonathan Samudio on 1/21/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import "LibraryTableViewController.h"
#import "ViewController.h"
#import "Library.h"

//GLOBAL VARIABLES
Book *sharedBook;
NSMutableArray *sharedLibrary;

@interface LibraryTableViewController ()

@end

@implementation LibraryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"LibraryTableViewController: viewDidLoad");
    
    //INITIALIZE LIBRARY OBJECT
    self.catalog = [[Library alloc] init];

    //SET REFRESH CONTROL SELECTOR FUNCTION
    [self.refreshControl addTarget:self
                           action:@selector(refreshInvoked)
                  forControlEvents:UIControlEventValueChanged];
    
    //INITIALIZE SPINNER AND ADD TO VIEW
    CGPoint centerOffset = self.view.center;
    centerOffset.y -= 50;
    
    _spinner= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _spinner.layer.cornerRadius = 05;
    _spinner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    _spinner.center = centerOffset;
    _spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [self.view addSubview: _spinner];
}

//RELOAD TABLE DATE ON VIEW APPEAR
-(void)viewDidAppear:(BOOL)animated { [self.tableView reloadData]; }

//PULL TO REFRESH
- (void)refreshInvoked
{
    NSLog(@"LibraryTableViewController: Refresh Invoked");
    [self.catalog loadCatalog];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//DEFAULT TABLE CELL HEIGHT
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {return 70;}

//NUMBER OF ROWS
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ return [self.catalog.bookList count]; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LibraryCellIdentifier = @"LibraryCell";
    
    LibraryCell *cell = (LibraryCell *)[tableView dequeueReusableCellWithIdentifier:LibraryCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LibraryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //SET TITLE AND AUTHOR FOR CELL
    Book * bk = [self.catalog.bookList objectAtIndex:indexPath.row];
    cell.bookTitle.text = bk.title;
    cell.bookAuthors.text = bk.author;
    
    return cell;
}

//ADD A BOOK TO THE LIBRARY
- (IBAction)addBook:(id)sender {
    
    sharedLibrary = self.catalog.bookList;
    
    Library *sharedLib = [Library sharedSingleton];
    sharedLib.bookList = sharedLibrary;
    
    [self performSegueWithIdentifier: @"addBookSegue" sender:sender];
}

//ON TABLE CELL BOOK SELECT
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    
    //ASSIGN THE SINGLETON VARIABLE
    sharedBook = [self.catalog.bookList objectAtIndex:indexPath.row];
    
    Library *sharedLib = [Library sharedSingleton];
    sharedLib.sharedBook = sharedBook;
    
    [self performSegueWithIdentifier: @"ViewBook" sender:tableView];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//ON CLEAR LIBRARY CLICK
// - Prompts the user if they are sure they want to clear
- (IBAction)clearAllBooks:(id)sender {
    
    UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Clear Library?"
                                                           message: @"Warning! This action can't be undone" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Clear", nil];
    [messageAlert show];
}

//HANDLE ALERTVIEW BUTTON PRESS
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        NSLog(@"LibraryTableViewController: Clear Button Pressed");
        [self.catalog clearCatalog];
        [self.tableView reloadData];
    }
    else{
        NSLog(@"LibraryTableViewController: Cancel Button Pressed");
    }
}

//ON UNWIND TO ROOT VIEW
// - Used by other views to pop back to the top root view
// - Reloads catalog and tableview 
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    [_spinner startAnimating];
    
    NSLog(@"LibraryTableViewController: prepareForUnwind");
    [self.catalog loadCatalog];
    NSLog(@"LibraryTableViewController: %lu", (unsigned long)self.catalog.bookList.count);
    [self.tableView reloadData];
    
    [_spinner stopAnimating];
}

@end
