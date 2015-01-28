//
//  Book.h
//  ProLib
//
//  Created by Jonathan Samudio on 1/21/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject {
    
}

@property NSString *title;
@property NSString *author;
@property NSString *lastCheckedOut;
@property NSString *lastCheckedOutBy;
@property NSString *publisher;
@property NSString *url;
@property NSString *categories;
@property NSInteger id;

- (void) updateBook: (NSDictionary*) jsonDict;
- (void) deleteBook;

- (NSString *) getLastCheckOutTime;
- (void) updateLastCheckOutTime: (NSString*) name;
- (NSString *) getDateString:(NSString*) dateFormatString;

@end
