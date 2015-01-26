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
    
    NSString * title = [sharedBook.title stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    [self getGoogleImagesForQuery:title withPage:1];
    
    NSLog(@"Library Title: %@", sharedBook.title);
    
    self.titleLabel.text = sharedBook.title;
    self.authorTitle.text = sharedBook.author;
    self.pubLabel.text = sharedBook.publisher;
    self.catLabel.text = sharedBook.categories;
    
    if([sharedBook.lastCheckedOutBy  isEqual: @"Never"]){self.checkedLabel.text = @"Never";}
    else
    {self.checkedLabel.text = [NSString stringWithFormat:@"%@ at %@", sharedBook.lastCheckedOutBy, sharedBook.lastCheckedOut];}
}

//Query and set first Google Image to UImage
- (void)getGoogleImagesForQuery:(NSString*)query withPage:(int)page
{
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
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        if(imageData != NULL){
            UIImage * image = [UIImage imageWithData:imageData];
            self.bookImage.image = image;
        }
    }
    @catch (NSException *ex) {
        NSLog(@"Exception %@",ex);
    }
}

//Alert Message to User Name
- (IBAction)checkOutAction:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter your name:" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.placeholder = @"Enter your name";
    [alert show];
}


//Handle AlertView Button Press
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"View Book Controller: Checkout Book");
    NSString * name = [[alertView textFieldAtIndex:0] text];
    NSLog(@"Name: %@", name);
    
    
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

@end
