//
//  ViewController.h
//  ProLib
//
//  Created by Jonathan Samudio on 1/20/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate>

//URL ARRAY FOR GOOGLE IMAGES
@property NSMutableArray * googleReponseArray;

//IMAGE VIEW AND SHARE TO FACEBOOK BUTTON
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

//BOOK INFORMATION
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorTitle;
@property (weak, nonatomic) IBOutlet UILabel *pubLabel;
@property (weak, nonatomic) IBOutlet UILabel *catLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkedLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;

//CONTENT VIEW IN SCROLL VIEW
// - Used to add spinner to view
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSData *imageData;

//EDIT BUTTON FUNCTION
- (IBAction)editButton:(id)sender;

@end

