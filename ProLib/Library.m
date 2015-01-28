//
//  Library.m
//  ProLib
//
//  Created by Jonathan Samudio on 1/21/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import "Library.h"

@implementation Library

static Library *sharedLib = NULL;

-(id) init{
    if (self = [super init]) {
        NSLog(@"Library Init");
    
        self.bookList = [[NSMutableArray alloc] init];
        self.sharedBook = [[Book alloc] init];
        [self loadCatalog];
    }
    return self;
}

- (void) printCatalog {
    for (int i = 0; i< [self.bookList count]; i++) {
        NSLog(@"%@", [self.bookList objectAtIndex:i]);
    }
}

- (void) loadCatalog{
    
    //Check for deleted books
    for(int i = 0; i < [self.bookList count]; i++){
        if([[[self.bookList objectAtIndex:i] title] isEqualToString:@""]){
           [self.bookList removeObjectAtIndex:i];
       }
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://prolific-interview.herokuapp.com/54bd1bd34fb6c2000805208a/books"]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    
    NSError *jsonError;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:requestHandler options:kNilOptions error:&jsonError];
    
    NSLog(@"JSON DICT: %@", dictionary);
    
    NSArray *titleArray = [dictionary valueForKey:@"title"];
    NSArray *authorArray = [dictionary valueForKey:@"author"];
    NSArray *lastCheckedArray = [dictionary valueForKey:@"lastCheckedOut"];
    NSArray *lastCheckedByArray = [dictionary valueForKey:@"lastCheckedOutBy"];
    NSArray *pubArray = [dictionary valueForKey:@"publisher"];
    NSArray *urlArray = [dictionary valueForKey:@"url"];
    NSArray *catArray = [dictionary valueForKey:@"categories"];
    NSArray *idArray = [dictionary valueForKey:@"id"];
    
    for(int i = 0; i < [titleArray count]; i++){
    
        NSInteger tempId = [[idArray objectAtIndex:i]integerValue];
        
        if(![self isIdFound:tempId]) {
        
            Book* tempBook = [[Book alloc] init];
            tempBook.title = [titleArray objectAtIndex:i];
            tempBook.author = [authorArray objectAtIndex:i];
        
            if([pubArray objectAtIndex:i] != [NSNull null]){ tempBook.publisher = [pubArray objectAtIndex:i];}
            else { tempBook.publisher = @"None"; }
        
            if([lastCheckedArray objectAtIndex:i] != [NSNull null]){ tempBook.lastCheckedOut = [lastCheckedArray objectAtIndex:i]; }
            else { tempBook.lastCheckedOut = @"Never"; }
            
            if([lastCheckedByArray objectAtIndex:i] != [NSNull null]){ tempBook.lastCheckedOutBy = [lastCheckedByArray objectAtIndex:i]; }
            else { tempBook.lastCheckedOutBy = @"Never"; }
        
            tempBook.url = [urlArray objectAtIndex:i];
            tempBook.categories = [catArray objectAtIndex:i];
            tempBook.id = tempId;
            [self.bookList addObject:tempBook];
        }
    }
    
    NSLog(@"CATALOG: %lu", self.bookList.count);
}

+ (Library *) sharedSingleton{
    @synchronized(sharedLib){
        if( !sharedLib || sharedLib == NULL){
            sharedLib = [[Library alloc] init];
        }
    }
    return sharedLib;
}


- (void) addBook: (Book*) bk{
    
    [self.bookList addObject:bk];
    //PREP DICTIONARY CONTAINER
 
    NSDictionary *jsonDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                              bk.title , @"title", bk.publisher, @"publisher",
                              bk.lastCheckedOutBy, @"lastCheckedOutBy",
                              bk.categories, @"categories", bk.author, @"author", nil];
    
    NSLog(@"DICT: %@", jsonDict);
    
    //PREPARE JSON DATA
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
    
    //REQUEST
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://prolific-interview.herokuapp.com/54bd1bd34fb6c2000805208a/books/"]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    //HANDLE RESPONSE
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error!");
        } else {
            NSString *responseText = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
            NSLog(@"Response: %@", responseText);
            
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"Response DICT: %@", dictionary);
            
            bk.id = [[dictionary valueForKey:@"id"] integerValue];
            bk.url = [dictionary valueForKey:@"url"];
        }
    }];
}

- (void) clearCatalog{
    //REQUEST
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * url = @"http://prolific-interview.herokuapp.com/54bd1bd34fb6c2000805208a/clean";
    
    self.bookList = [[NSMutableArray alloc] init];
    self.sharedBook = [[Book alloc] init];
    
    
    NSLog(@"DELETE URL: %@", url);
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"DELETE"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //HANDLE RESPONSE
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error!");
        } else {
            NSLog(@"SUCCESSFUL DELETE");
        }
    }];
}

- (BOOL) isIdFound:(NSInteger) cmpId{
    
    for(int i = 0; i < [self.bookList count]; i++){
        if([[self.bookList objectAtIndex:i] id] == cmpId){ return TRUE; }
    }
    return FALSE;
}

@end
