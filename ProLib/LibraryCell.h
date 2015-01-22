//
//  LibraryCell.h
//  ProLib
//
//  Created by Jonathan Samudio on 1/21/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *bookTitle;
@property (nonatomic, weak) IBOutlet UILabel *bookAuthors;

@end
