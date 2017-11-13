//
//  ConformationVCViewController.h
//  Grocery Bazaar
//
//  Created by shubham gupta on 11/11/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConformationVCViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@end
