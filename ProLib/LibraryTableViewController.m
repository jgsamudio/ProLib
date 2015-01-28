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

Book *sharedBook;//global variable
NSMutableArray *sharedLibrary;

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

    [self.refreshControl addTarget:self
                           action:@selector(refreshInvoked)
                  forControlEvents:UIControlEventValueChanged];
    
    CGPoint centerOffset = self.view.center;
    centerOffset.y -= 50;
    
    _spinner= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _spinner.layer.cornerRadius = 05;
    _spinner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    _spinner.center = centerOffset;
    _spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [self.view addSubview: _spinner];

}

-(void)viewDidAppear:(BOOL)animated {

    [_spinner startAnimating];
    
    NSLog(@"LibraryTableViewController: viewDidAppear");
    [self.catalog loadCatalog];
    NSLog(@"LibraryTableViewController: %lu", self.catalog.bookList.count);
    [self.tableView reloadData];
    
    [_spinner stopAnimating];
}

- (void)refreshInvoked
{
    //Refresh Invoked
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

- (IBAction)addBook:(id)sender {
    
    sharedLibrary = self.catalog.bookList;
    
    Library *sharedLib = [Library sharedSingleton];
    sharedLib.bookList = sharedLibrary;
    
    [self performSegueWithIdentifier: @"addBookSegue" sender:sender];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    
    //Assign the singleton variable value
    sharedBook = [self.catalog.bookList objectAtIndex:indexPath.row];
    
    Library *sharedLib = [Library sharedSingleton];
    sharedLib.sharedBook = sharedBook;
    
    
    
    [self performSegueWithIdentifier: @"ViewBook" sender:tableView];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

@end
