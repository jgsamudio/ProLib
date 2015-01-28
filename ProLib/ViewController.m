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
    // Do any additional setup after loading the view, typically from a nib.
    self.googleReponseArray = [[NSMutableArray alloc] init];
    
    CGPoint centerOffset = self.view.center;
    centerOffset.y = 200;
    
    _spinner= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _spinner.layer.cornerRadius = 05;
    _spinner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    _spinner.center = centerOffset;
    _spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [self.view addSubview: _spinner];
    
    //QUERY AND SET BOOKS IMAGE
    [self getBookImagesForQuery];
    
    NSLog(@"Library Title: %@", sharedBook.title);
    
    self.titleLabel.text = sharedBook.title;
    self.authorTitle.text = sharedBook.author;
    self.pubLabel.text = sharedBook.publisher;
    self.catLabel.text = sharedBook.categories;
    
    if([sharedBook.lastCheckedOutBy  isEqual: @"Never"]){self.checkedLabel.text = @"Never";}
    else
    {self.checkedLabel.text = [NSString stringWithFormat:@"%@ at %@", sharedBook.lastCheckedOutBy, sharedBook.lastCheckedOut];}
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"ViewController: viewDidAppear");
    self.titleLabel.text = sharedBook.title;
    self.authorTitle.text = sharedBook.author;
    self.pubLabel.text = sharedBook.publisher;
    self.catLabel.text = sharedBook.categories;
}

//Query and set first Google Image to UImage
- (void)getBookImagesForQuery
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        //Do EXTREME PROCESSING!!!
        NSLog(@"BACKGROUND THREAD");
        [_spinner startAnimating];
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
            NSLog(@"Request is %@",request);
            
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSError *error;
            
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData: responseData options:kNilOptions error:&error];
            
            NSLog(@"JSON DIct: %@", responseDic);
            
            NSArray *resultArray = [[[responseDic objectForKey:@"responseData"] objectForKey:@"results"] valueForKey:@"url"];
            NSLog(@"JSON URL: %@", resultArray);
            
            
            NSURL * imageURL = [NSURL URLWithString:[resultArray objectAtIndex:0]];
            NSLog(@"Request is %@",imageURL);
            
            
            
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

//Alert Message to User Name
- (IBAction)checkOutAction:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter your name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Checkout", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.placeholder = @"Enter your name";
    [alert show];
}

//Handle AlertView Button Press
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0){NSLog(@"ViewController: Cancel Button Pressed");}
    else{
        NSLog(@"ViewController: Checkout Button Pressed");
    
        //RETREIVE NAME AND UPDATE TO SERVER
        NSLog(@"View Book Controller: Checkout Book");
        NSString * name = [[alertView textFieldAtIndex:0] text];
        NSLog(@"Name: %@", name);
    
        //PREP JSON DICTIONARY CONTAINER
        NSDictionary *jsonDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                          name, @"lastCheckedOutBy",nil];
    
        if([sharedBook updateBook:jsonDict] == 0){
            //UPDATE "LAST CHECKED OUT BY" TEXTFIELD
            NSLog(@"UPDATE COMPLETE");
            self.checkedLabel.text = [NSString stringWithFormat:@"%@ at %@",
                                  sharedBook.lastCheckedOutBy, sharedBook.lastCheckedOut];
        }
    
        [self performSegueWithIdentifier:@"exitToLibrarySegue" sender:self];
    }
}

//Share with Activities: Facebook, Twitter, Email, etc
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

- (IBAction)editButton:(id)sender {
    
    Library *sharedLib = [Library sharedSingleton];
    sharedLib.sharedBook = sharedBook;
    
    [self performSegueWithIdentifier: @"editBookSegue" sender:sender];
}


@end
