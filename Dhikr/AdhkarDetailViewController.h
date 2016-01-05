//
//  AdhkarDetailViewController.h
//  Dhikr
//
//  Created by Umayah Abdennabi on 6/6/15.
//  Copyright (c) 2015 9qbd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdhkarItem;

@interface AdhkarDetailViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) AdhkarItem *item;

@end
