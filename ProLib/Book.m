//
//  Book.m
//  ProLib
//
//  Created by Jonathan Samudio on 1/21/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import "Book.h"

@implementation Book

NSInteger status = 0;

-(id)init
{
    return self;
}


- (NSInteger) updateBook: (NSDictionary*) jsonDict{

    NSLog(@"DICT: %@", jsonDict);
    
    //PREPARE JSON DATA
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
    
    //REQUEST
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * url = [NSString stringWithFormat:@"%@%@", @"http://prolific-interview.herokuapp.com/54bd1bd34fb6c2000805208a", self.url];
    
    NSLog(@"PUT URL: %@", url);
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    //HANDLE RESPONSE
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error!");
            status = 1;
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"ResponseDict: %@", responseDict);
            
            //UPDATE BOOK VARIABLES FROM RESPONSE
            self.author = [responseDict valueForKey:@"author"];
            self.categories = [responseDict valueForKey:@"categories"];
            self.id = [[responseDict valueForKey:@"id"]integerValue];
            self.lastCheckedOut = [responseDict valueForKey:@"lastCheckedOut"];
            self.lastCheckedOutBy = [responseDict valueForKey:@"lastCheckedOutBy"];
            self.publisher = [responseDict valueForKey:@"publisher"];
            self.title = [responseDict valueForKey:@"title"];
            self.url = [responseDict valueForKey:@"url"];
        }
    }];
    
    return status;
}

- (NSInteger) deleteBook{
    
    //REQUEST
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * url = [NSString stringWithFormat:@"%@%@", @"http://prolific-interview.herokuapp.com/54bd1bd34fb6c2000805208a", self.url];
    
    NSLog(@"DELETE URL: %@", url);
    
    self.title = @"";
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"DELETE"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //HANDLE RESPONSE
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error!");
            status = 1;
        } else {
            NSLog(@"SUCCESSFUL DELETE");
        }
    }];
    
    
    return status;
}



@end
