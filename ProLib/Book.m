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
NSString * dateServerFormat = @"yyyy-MM-dd HH:mm:ss";
NSString * dateUIFormat = @"MMMM dd, yyyy";
NSString * timeUIFormat = @"h:mm a";

-(id)init
{
    return self;
}


- (void) updateBook: (NSDictionary*) jsonDict{

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
        }
    }];
}

- (void) deleteBook{
    
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
}

- (NSString *) getLastCheckOutTime{
    
    if([self.lastCheckedOutBy  isEqual: @"Never"] || [self.lastCheckedOutBy isEqual:@""]){ return @"Never"; }
    else{
    
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateServerFormat];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        
        NSDate *date = [dateFormatter dateFromString: self.lastCheckedOut];
    
        dateFormatter = [[NSDateFormatter alloc] init];
    
        [dateFormatter setDateFormat:timeUIFormat];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
        NSString *timeUIString = [dateFormatter stringFromDate:date];
    
        [dateFormatter setDateFormat:dateUIFormat];
        NSString *dateUIString = [dateFormatter stringFromDate:date];
    
        NSString * convertedString = [NSString stringWithFormat:@"%@ at %@ on %@",
                                  self.lastCheckedOutBy, timeUIString, dateUIString];
    
        NSLog(@"LastCheckedOutBy : %@",convertedString);
        return convertedString;
    }
}

- (void) updateLastCheckOutTime:(NSString*) name {
    
    //CALC SERVER TIME
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
