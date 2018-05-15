//
//  CartCellTableViewCell.h
//  Grocery Bazaar
//
//  Created by shubham gupta on 11/8/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView_Product;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Product_Name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Product_Price;
@property (weak, nonatomic) IBOutlet UIButton *btnCross;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@property (weak, nonatomic) IBOutlet UILabel *lbl_CartQuantity;
@property (weak, nonatomic) IBOutlet UIView *viewToClip;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Weight;



@end
