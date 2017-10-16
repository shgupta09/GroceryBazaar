//
//  ForgetPasswordVC.h
//  ShreeAirlines
//
//  Created by NetprophetsMAC on 4/18/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordVC : UIViewController
@property(nonatomic)BOOL isEticket;
@property(nonatomic,strong) NSString *orderId;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;

@end
