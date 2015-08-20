//
//  DetailViewController.h
//  ComicSearch
//
//  Created by Yago de la Fuente on 15/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

