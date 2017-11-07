//
//  ProfileVC.h
//  Grocery Bazaar
//
//  Created by NetprophetsMAC on 11/6/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileVC : UIViewController<UITextFieldDelegate,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet CustomTextField *txt_FirstName;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_LastName;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_DOB;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Gender;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Mobile;
@property (weak, nonatomic) IBOutlet UIButton *btnadd;
@property (weak, nonatomic) IBOutlet UIButton *btnDOB;
@property (weak, nonatomic) IBOutlet UIButton *btnGender;

@end

