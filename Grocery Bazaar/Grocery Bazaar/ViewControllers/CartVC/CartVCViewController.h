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
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIView *viewToRemovePopUP;

@property (weak, nonatomic) IBOutlet UILabel *lbl_productName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_price;

@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (weak, nonatomic) IBOutlet UIButton *btnMinus;
@property (weak, nonatomic) IBOutlet UIView *VIEWTOCLIP;
@property (weak, nonatomic) IBOutlet UIView *checkOutView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_price_checkout;
@property (weak, nonatomic) IBOutlet UIButton *btn_CheckOut;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Quantity;
@property (weak, nonatomic) IBOutlet UIView *viewToRound;
@property (weak, nonatomic) IBOutlet UIButton *btn_done;
@property (weak, nonatomic) IBOutlet UIView *viewToRound2;
@end
