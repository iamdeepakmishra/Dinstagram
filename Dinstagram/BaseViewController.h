//
//  BaseViewController.h
//  Dinstagram
//
//  Created by deepak mishra on 13/3/13.
//  Copyright (c) 2013 deepak mishra. All rights reserved.
//

/****************************

 This BaseviewController is for instagram reference.
 Subclass it whenever use. 
 ****************************/

#import <UIKit/UIKit.h>
#import "Instagram.h"

@interface BaseViewController : UIViewController<IGSessionDelegate, IGRequestDelegate>
@property(assign) Instagram *dInstagram;
@property(nonatomic, retain) NSMutableArray *data;
@property(nonatomic, retain) NSDictionary *dataDict;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
