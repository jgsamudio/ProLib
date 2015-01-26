//
//  ViewController.h
//  ProLib
//
//  Created by Jonathan Samudio on 1/20/15.
//  Copyright (c) 2015 Jonathan Samudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property NSMutableArray * googleReponseArray;

@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorTitle;
@property (weak, nonatomic) IBOutlet UILabel *pubLabel;
@property (weak, nonatomic) IBOutlet UILabel *catLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkedLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;

@end

