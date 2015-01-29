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
    
        //INITIALIZE PROPERTIES
        self.bookList = [[NSMutableArray alloc] init];
        self.sharedBook = [[Book alloc] init];
        
        //LOAD CATALOG FROM SERVER
        [self loadCatalog];
    }
    return self;
}

//PRINT CATALOG
// - Prints the objects from the bookList Array
- (void) printCatalog {
    for (int i = 0; i< [self.bookList count]; i++) {
        NSLog(@"%@", [self.bookList objectAtIndex:i]);
    }
}

//LOAD CATALOG
// - Retrives all books from server
// - Adds them to the library array
- (void) loadCatalog{
    
    //CHECK AND REMOVE DELETED BOOKS FROM ARRAY
    for(int i = 0; i < [self.bookList count]; i++){
        if([[[self.bookList objectAtIndex:i] title] isEqualToString:@""]){
           [self.bookList removeObjectAtIndex:i];
       }
    }
    
    @try{
        
        //REQUEST URL
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://prolific-interview.herokuapp.com/54bd1bd34fb6c2000805208a/books"]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
        NSURLResponse *requestResponse;
        NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    
        NSError *jsonError;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:requestHandler options:kNilOptions error:&jsonError];
    
        NSLog(@"JSON DICT: %@", dictionary);
    
        //SEPARATE RESULTS INTO ARRAYS
        NSArray *titleArray = [dictionary valueForKey:@"title"];
        NSArray *authorArray = [dictionary valueForKey:@"author"];
        NSArray *lastCheckedArray = [dictionary valueForKey:@"lastCheckedOut"];
        NSArray *lastCheckedByArray = [dictionary valueForKey:@"lastCheckedOutBy"];
        NSArray *pubArray = [dictionary valueForKey:@"publisher"];
        NSArray *urlArray = [dictionary valueForKey:@"url"];
        NSArray *catArray = [dictionary valueForKey:@"categories"];
        NSArray *idArray = [dictionary valueForKey:@"id"];
    
        //LOOP THROUGH ARRAYS TO ADD NEW BOOK TO LIBRARY ARRAY
        // - Checks if some fields are null
        for(int i = 0; i < [titleArray count]; i++){
    
            NSInteger tempId = [[idArray objectAtIndex:i]integerValue];
        
            if(![self isIdFound:tempId]) {
        
                Book* tempBook = [[Book alloc] init];
                tempBook.title = [titleArray objectAtIndex:i];
                tempBook.author = [authorArray objectAtIndex:i];
        
                if([pubArray objectAtIndex:i] != [NSNull null]){ tempBook.publisher = [pubArray objectAtIndex:i];}
                else { tempBook.publisher = @"None"; }
        
                if([lastCheckedArray objectAtIndex:i] != [NSNull null]){ tempBook.lastCheckedOut = [lastCheckedArray    objectAtIndex:i]; }
                else { tempBook.lastCheckedOut = @"Never"; }
            
                if([lastCheckedByArray objectAtIndex:i] != [NSNull null]){ tempBook.lastCheckedOutBy = [lastCheckedByArray  objectAtIndex:i]; }
                else { tempBook.lastCheckedOutBy = @"Never"; }
        
                tempBook.url = [urlArray objectAtIndex:i];
                tempBook.categories = [catArray objectAtIndex:i];
                tempBook.id = tempId;
                [self.bookList addObject:tempBook];
            }
        }
    }
    @catch (NSException *ex) {
        NSLog(@"Exception %@",ex);
    }
    
    //LOG CATALOG COUNT
    NSLog(@"CATALOG: %lu", self.bookList.count);
}

//ADD BOOK
// - Adds new book to local array
// - Sends new book information to server
- (void) addBook: (Book*) bk{
    
    //ADD BOOK TO MASTER LIBRARY ARRAY
    [self.bookList addObject:bk];
    
    //INITIALIZE JSON DICTIONARY CONTAINER
    NSDictionary *jsonDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                              bk.title , @"title", bk.publisher, @"publisher",
                              bk.lastCheckedOutBy, @"lastCheckedOutBy",
                              bk.categories, @"categories", bk.author, @"author", nil];
    
    NSLog(@"DICT: %@", jsonDict);
    
    //INITIALIZE JSON DATA
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
    
    //REQUEST URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://prolific-interview.herokuapp.com/54bd1bd34fb6c2000805208a/books/"]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    //HANDLE RESPONSE
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) { NSLog(@"Error!"); }
        else {
            //RESPONSE DICTIONARY
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"Response DICT: %@", dictionary);
            
            bk.id = [[dictionary valueForKey:@"id"] integerValue];
            bk.url = [dictionary valueForKey:@"url"];
        }
    }];
}

//CLEAR CATALOG
// - Deletes all books from the library array and server
- (void) clearCatalog{
    
    //CREATE A 
    self.bookList = [[NSMutableArray alloc] init];
    self.sharedBook = [[Book alloc] init];
    
    //REQUEST URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * url = @"http://prolific-interview.herokuapp.com/54bd1bd34fb6c2000805208a/clean";
    

    
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

//IS ID FOUND
// - Checks the library array if a book as matching ids
- (BOOL) isIdFound:(NSInteger) cmpId{
    
    for(int i = 0; i < [self.bookList count]; i++){
        if([[self.bookList objectAtIndex:i] id] == cmpId){ return TRUE; }
    }
    return FALSE;
}

+ (Library *) sharedSingleton{
    @synchronized(sharedLib){
        if( !sharedLib || sharedLib == NULL){
            sharedLib = [[Library alloc] init];
        }
    }
    return sharedLib;
}

@end
