//
//  MyOrderDetailsViewController.h
//  Grocery Bazaar
//
//  Created by Shagun Verma on 22/11/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong,nonatomic) MyOrder* orderObj;

@end
