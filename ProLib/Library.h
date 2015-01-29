//
//  Library.h
//  ProLib
//
//  Created by Jonathan Samudio on 1/21/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@interface Library : NSObject

//MASTER LIBRARY ARRAY
@property NSMutableArray *bookList;

//BOOK PROPERTY TO SHARE BETWEEN VIEWS
@property Book * sharedBook;

//LIBRARY CATALOG FUNCTIONS
- (void) printCatalog;
- (void) loadCatalog;
- (void) addBook:(Book*) bk;
- (void) clearCatalog;
- (BOOL) isIdFound:(NSInteger) cmpId;

//SHARED SINGLETON
+ (Library *) sharedSingleton;

@end
