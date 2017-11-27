//
//  MyOrdersTableViewCell.h
//  Grocery Bazaar
//
//  Created by Shagun Verma on 22/11/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrdersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblOrderId;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderNo;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@end
