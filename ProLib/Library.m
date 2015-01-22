//
//  Library.m
//  ProLib
//
//  Created by Jonathan Samudio on 1/21/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import "Library.h"

@implementation Library

-(id) init{
    self = [super init];
    NSLog(@"Library Init");
    
    self.bookList = [[NSMutableArray alloc] init];
    
    [self loadCatalog];

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
    NSArray *idArray = [dictionary valueForKey:@"id"];
    
    for(int i = 0; i < [titleArray count]; i++){
    
        Book* tempBook = [[Book alloc] init];
        NSString * title = [titleArray objectAtIndex:i];
        NSString * author = [authorArray objectAtIndex:i];
        tempBook.title = title;
        tempBook.author = author;
        
        [self.bookList addObject:tempBook];
    }
    
    //NSLog(@"Inner: %@", [titleArray objectAtIndex:0]);
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
