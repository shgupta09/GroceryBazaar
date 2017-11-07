//
//  ChangePasswordVC.h
//  Grocery Bazaar
//
//  Created by NetprophetsMAC on 11/7/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordVC : UIViewController
@property (weak, nonatomic) IBOutlet CustomTextField *txt_password;
@property (weak, nonatomic) IBOutlet CustomTextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_ConfirmPassword;
@end
