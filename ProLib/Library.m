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
    self.catalog = [[NSMutableArray alloc] init];
    [self loadCatalog];
    return self;
}

- (void) printCatalog {
    for (int i = 0; i< [self.catalog count]; i++) {
        NSLog(@"%@", [self.catalog objectAtIndex:i]);
    }
}

- (void) loadCatalog{
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
