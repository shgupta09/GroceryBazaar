//
//  AddressVC.h
//  Grocery Bazaar
//
//  Created by NetprophetsMAC on 10/26/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressVC : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet CustomTextField *txt_address1;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_address2;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Landmark;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Pincode;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_city;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_State;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Country;
@end
