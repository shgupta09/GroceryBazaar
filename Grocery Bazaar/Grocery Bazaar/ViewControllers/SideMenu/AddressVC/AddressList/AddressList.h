//
//  AddressList.h
//  Grocery Bazaar
//
//  Created by shubham gupta on 10/31/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressList : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbl_List;
@property( nonatomic) BOOL isFromCheckout;

@end
