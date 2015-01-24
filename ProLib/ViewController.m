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
    
}

- (NSString*) titleToURLString:(NSString *) title{

    
    return title;
}


- (void)getGoogleImagesForQuery:(NSString*)query withPage:(int)page
{
    @try{
        
        int firstImageNumber = page * 6;
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
        
        UIImage * image = [UIImage imageWithData:imageData];
        self.bookImage.image = image;
        //[self.bookImage setImage:image];
        
    }
    @catch (NSException *ex) {
        NSLog(@"Exception %@",ex);
    }
}
- (IBAction)showActivityView:(id)sender {
    
    NSString * shareText = @"HELLO";
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
