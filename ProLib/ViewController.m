//
//  ViewController.m
//  ProLib
//
//  Created by Jonathan Samudio on 1/20/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import "ViewController.h"
#import "LibraryTableViewController.h"
#import "Library.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.googleReponseArray = [[NSMutableArray alloc] init];
    
    //INITIATE POSITION FOR LOAD SPINNER
    CGPoint centerOffset = self.view.center;
    centerOffset.y = 200;
    
    _spinner= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _spinner.layer.cornerRadius = 05;
    _spinner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    _spinner.center = centerOffset;
    _spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [self.contentView addSubview: _spinner];
    
    //QUERY AND SET BOOKS IMAGE
    [self getBookImagesForQuery];
    
    NSLog(@"Library Title: %@", sharedBook.title);
    
    //LOAD BOOK INFORMATION TO LABELS
    self.titleLabel.text = sharedBook.title;
    self.authorTitle.text = sharedBook.author;
    self.pubLabel.text = sharedBook.publisher;
    self.catLabel.text = sharedBook.categories;
    self.checkedLabel.text = [sharedBook getLastCheckOutTime];
    
}

//RELOAD LABELS ON VIEW APPEAR
-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"ViewController: viewDidAppear");
    self.titleLabel.text = sharedBook.title;
    self.authorTitle.text = sharedBook.author;
    self.pubLabel.text = sharedBook.publisher;
    self.catLabel.text = sharedBook.categories;
}

//QUERY AND SET FIRST GOOGLE IMAGE TO UIMAGE
// - Process in background thread
- (void)getBookImagesForQuery
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSLog(@"BACKGROUND THREAD");
        
        [_spinner startAnimating];
        
        //PREPARE SEARCH QUERY STRING
        // - Removes spaces and commas
        NSString * title = [sharedBook.title stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSString * author = [sharedBook.author stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        author = [author stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        NSString * query = [NSString stringWithFormat:@"%@+%@+%@", title, @"book+cover", author];
        NSLog(@"SEARCH QUERY: %@", query);
        
        @try{
            
            int firstImageNumber = 1;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:
                                               @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=6&q=%@&start=%i&&imgsz=medium",query, firstImageNumber]];
            NSLog(@"url is %@",url);
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            NSError *error;
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData: responseData options:kNilOptions error:&error];
            
            //RETRIEVE RESPONSE ARRAY
            NSArray *resultArray = [[[responseDic objectForKey:@"responseData"] objectForKey:@"results"] valueForKey:@"url"];
            
            NSURL * imageURL = [NSURL URLWithString:[resultArray objectAtIndex:0]];
            NSLog(@"Request is %@",imageURL);
            
            //SEARCH RESULTS FOR IMAGE THAT IS NOT NULL
            for(int i = 0; i < [resultArray count]; i++){
                _imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[resultArray objectAtIndex:i]]];
                NSLog(@"URL INDEX: %d", i);
                if(_imageData != NULL) {break;}
            }
        }
        @catch (NSException *ex) {
            NSLog(@"Exception %@",ex);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_imageData != NULL){ self.bookImage.image = [UIImage imageWithData:_imageData]; }
            else { self.bookImage.image =[UIImage imageNamed:@"PlaceholderBook.png"]; }
            [_spinner stopAnimating];
        });
    });
}

//ALERT MESSAGE FOR USER NAME
- (IBAction)checkOutAction:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter your name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Checkout", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.placeholder = @"Enter your name";
    [alert show];
}

//HANDLE ALERTVIEW BUTTON PRESS
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0){NSLog(@"ViewController: Cancel Button Pressed");}
    else{
        NSLog(@"ViewController: Checkout Button Pressed");
    
        //RETREIVE NAME AND UPDATE TO SERVER
        NSLog(@"View Book Controller: Checkout Book");
        NSString * name = [[alertView textFieldAtIndex:0] text];
        NSLog(@"Name: %@", name);
    
        //UPDATE LAST CHECKOUT TIME AND SEND TO SERVER
        [sharedBook updateLastCheckOutTime:name];
        
        //UPDATE "LAST CHECKED OUT BY" TEXTFIELD
        self.checkedLabel.text = [sharedBook getLastCheckOutTime];
    }
}

//SHARE WITH ACTIVITIES: EMAIL, FACEBOOK, ETC
- (IBAction)showActivityView:(id)sender {
    
    NSString * shareText = [NSString stringWithFormat:@"I'm reading %@ by %@!", sharedBook.title, sharedBook.author];
    NSArray *itemsToShare = @[shareText];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//EDIT BUTTON
// - Prep singleton and launch segue
- (IBAction)editButton:(id)sender {
    Library *sharedLib = [Library sharedSingleton];
    sharedLib.sharedBook = sharedBook;
    
    [self performSegueWithIdentifier: @"editBookSegue" sender:sender];
}


@end
