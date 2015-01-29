//
//  Book.m
//  ProLib
//
//  Created by Jonathan Samudio on 1/21/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import "Book.h"

@implementation Book

//DATE AND TIME FORMATS
NSString * dateServerFormat = @"yyyy-MM-dd HH:mm:ss";
NSString * dateUIFormat = @"MMMM dd, yyyy";
NSString * timeUIFormat = @"h:mm a";

-(id)init
{
    _title = @"";
    _author = @"";
    _lastCheckedOut = @"";
    _lastCheckedOutBy = @"";
    _publisher = @"";
    _url = @"";
    _categories = @"";
    _id = -1;
    return self;
}

//UPDATE BOOK
// - Send new information to server
// - Checks if there is an error with the request
- (void) updateBook: (NSDictionary*) jsonDict{

    NSLog(@"UPDATE BOOK DICT: %@", jsonDict);
    
    //PREPARE JSON DATA
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
    
    //REQUEST URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * url = [NSString stringWithFormat:@"%@%@", @"http://prolific-interview.herokuapp.com/54bd1bd34fb6c2000805208a", self.url];
    
    NSLog(@"UPDATE BOOK URL: %@", url);
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    //HANDLE RESPONSE
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) { NSLog(@"ERROR!"); }
        else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"UPDATE BOOK RESPONSE: %@", responseDict);
        }
    }];
}

//DELETE BOOK
// - Assigns Book title to empty string ("") to delete from library book array

- (void) deleteBook{
    
    //DELETE BOOK IDENTIFICATION
    self.title = @"";
    
    //REQUEST URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * url = [NSString stringWithFormat:@"%@%@", @"http://prolific-interview.herokuapp.com/54bd1bd34fb6c2000805208a", self.url];
    
    NSLog(@"DELETE BOOK URL: %@", url);
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"DELETE"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //HANDLE RESPONSE
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) { NSLog(@"Error!"); }
        else {
            NSLog(@"SUCCESSFUL DELETE");
        }
    }];
}

//GET LAST CHECKOUT TIME
// - Checks if the book has never been checked out before
// - Converts the server time string with timezone "UTC" to View String with system timezone
- (NSString *) getLastCheckOutTime{
    
    if([self.lastCheckedOutBy  isEqual: @"Never"] || [self.lastCheckedOutBy isEqual:@""]){ return @"Never"; }
    else{
    
        //INITALIZE DATE FORMATTER WITH SERVER FORMAT
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateServerFormat];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        
        //RETRIVE DATE WITH SERVER TIME STRING
        NSDate *date = [dateFormatter dateFromString: self.lastCheckedOut];
        
        //RESET DATE FORMATTER WITH TIME FORMAT
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:timeUIFormat];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        NSString *timeUIString = [dateFormatter stringFromDate:date];
    
        //RESET DATE FORMATTER WITH DATE FORMAT
        [dateFormatter setDateFormat:dateUIFormat];
        NSString *dateUIString = [dateFormatter stringFromDate:date];
    
        //GENERATE STRING TO VIEW
        NSString * convertedString = [NSString stringWithFormat:@"%@ at %@ on %@",
                                  self.lastCheckedOutBy, timeUIString, dateUIString];
    
        NSLog(@"LastCheckedOutBy : %@",convertedString);
        return convertedString;
    }
}

//UPDATE LAST CHECKOUT TIME
// - Updates local and server time when the book was checked out
- (void) updateLastCheckOutTime:(NSString*) name {
    
    //RETRIEVE SERVER TIME
    NSString * serverTime = [self getDateString:dateServerFormat];
    
    //UPDATE BOOK VARIABLES
    self.lastCheckedOut = serverTime;
    self.lastCheckedOutBy = name;
    
    //PREP JSON DICTIONARY CONTAINER
    NSDictionary *jsonDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                              name, @"lastCheckedOutBy", serverTime, @"lastCheckedOut", nil];
    
    //UPDATE BOOK ON SERVER
    [self updateBook:jsonDict];
}

//GET DATE STRING
// - Retrieves the date and time with a given format
- (NSString *) getDateString:(NSString*) dateFormatString{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:dateFormatString];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSLog(@"date: %@", dateString);
    return dateString;
}

@end
