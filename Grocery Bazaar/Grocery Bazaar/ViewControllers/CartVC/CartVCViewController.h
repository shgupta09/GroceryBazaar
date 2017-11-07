//
//  CartVCViewController.h
//  Grocery Bazaar
//
//  Created by shubham gupta on 11/8/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartVCViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@end
