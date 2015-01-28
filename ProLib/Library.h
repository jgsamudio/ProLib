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

- (void) printCatalog;
- (void) loadCatalog;

- (void) addBook:(Book*) bk;
- (void) clearCatalog;

@property NSMutableArray *bookList;
@property Book * sharedBook;

+ (Library *) sharedSingleton;

@end
