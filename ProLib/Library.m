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
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://prolific-interview.herokuapp.com/54bd1bd34fb6c2000805208a/books"]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    NSLog(@"requestReply: %@", requestReply);
    
    
    NSError *jsonError;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:requestHandler options:kNilOptions error:&jsonError];
    
    NSLog(@"JSON DIct: %@", dictionary);
    
    NSArray *titleArray = [dictionary valueForKey:@"title"];
    NSArray *authorArray = [dictionary valueForKey:@"author"];
    NSArray *lastCheckedArray = [dictionary valueForKey:@"lastCheckedOut"];
    NSArray *lastCheckedByArray = [dictionary valueForKey:@"lastCheckedOutBy"];
    NSArray *pubArray = [dictionary valueForKey:@"publisher"];
    NSArray *urlArray = [dictionary valueForKey:@"url"];
    NSArray *catArray = [dictionary valueForKey:@"categories"];
    //NSArray *idArray = [dictionary valueForKey:@"id"];
    
     NSLog(@"JSON DIct: %@", pubArray);
    NSLog(@"JSON DIct: %@", NULL);
    for(int i = 0; i < [titleArray count]; i++){
    
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
        //tempBook.id = (NSInteger)[idArray objectAtIndex:i];
        
        [self.bookList addObject:tempBook];
    }
    
    //NSLog(@"Inner: %@", [titleArray objectAtIndex:0]);
}


+ (Library *) sharedSingleton{
    @synchronized(sharedLib){
        if( !sharedLib || sharedLib == NULL){
            sharedLib = [[Library alloc] init];
        }
    }
    return sharedLib;
}


- (NSInteger*) addBook: (Book*) bk{
    NSInteger* status = 0;
    return status;
}

- (Book*) getBook: (NSInteger*) bkPos{
    Book* takeBook;
    return takeBook;
}

- (NSInteger*) updateBook: (Book*) bk{
    NSInteger* status = 0;
    return status;
}

- (NSInteger*) removeBook: (NSInteger*) bkPos{
    NSInteger* status = 0;
    return status;
}

- (NSInteger*) clearCatalog{
    NSInteger* status = 0;
    return status;
}

@end
