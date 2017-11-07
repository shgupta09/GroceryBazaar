//
//  AddressVC.m
//  Grocery Bazaar
//
//  Created by NetprophetsMAC on 10/26/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "AddressVC.h"

@interface AddressVC ()
{
    LoderView *loderObj;
    BOOL isEdit;
}
@end

@implementation AddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    // Do any additional setup after loading the view from its nib.
}


-(void)setData{
 
    if (_isFromList) {
        isEdit = false;
        _txt_address1.text = _addressObj.address_line1;
        _txt_address2.text = _addressObj.address_line2;
        _txt_city.text = _addressObj.city;
        _txt_State.text = _addressObj.state;
        _txt_Pincode.text = _addressObj.pincode;
        _txt_Landmark.text = _addressObj.landmark;
        _txt_Country.text = _addressObj.country;
        [self textFieldEdit:false];
        [_btnadd setTitle:@"Edit" forState:UIControlStateNormal];
        [CommonFunction setResignTapGestureToView:self.view andsender:self];
        [CommonFunction setNavToController:self title:@"Update Address" isCrossBusston:false isAddRightButton:false];
    }
    else{
        [CommonFunction setNavToController:self title:@"Address" isCrossBusston:false isAddRightButton:false];
        [_btnadd setTitle:@"Add" forState:UIControlStateNormal];
    }
}

-(void)textFieldEdit:(BOOL)boolValue{
    _txt_address1.userInteractionEnabled = boolValue;
    _txt_address2.userInteractionEnabled = boolValue;
    _txt_Pincode.userInteractionEnabled = boolValue;
    _txt_Landmark.userInteractionEnabled = boolValue;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate
//! for change the current first responder
//! @param: TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIResponder *nextResponder = [self.view viewWithTag:textField.tag+1];
    if(nextResponder){
        [nextResponder becomeFirstResponder];   //next responder found
    } else {
        [CommonFunction resignFirstResponderOfAView:self.view];
    }
    return NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if (textField.tag == 3) {
        
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        _txt_Country.text = @"";
        _txt_State.text = @"";
        _txt_city.text = @"";
        return newLength <= 6;
    }
    return true;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 3 && textField.text.length == 6) {
        [self hitApiForAddress];
    }
}
#pragma mark - Api Related Methods
-(void)hitApiForAddress{
    if ([ CommonFunction reachability]) {
        [self addLoder];
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_FOR_ADDRESS,_txt_Pincode.text]  postResponse:nil postImage:nil requestType:Get tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if (![[responseObj valueForKey:@"Status"] isEqualToString:@"Error"]){
                    
                    _txt_city.text = [[[responseObj valueForKey:@"PostOffice"] objectAtIndex:0]valueForKey:@"Circle"];
                    _txt_State.text = [[[responseObj valueForKey:@"PostOffice"] objectAtIndex:0]valueForKey:@"State"];
                    _txt_Country.text = [[[responseObj valueForKey:@"PostOffice"] objectAtIndex:0]valueForKey:@"Country"];
                    
                    [self removeloder];
                }
                else
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter a valid PinCode"preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    _txt_Pincode.text = @"";
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                }
            }
            
            else {
                [self removeloder];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}



#pragma mark - add loder

-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = @"Fetching Data...";
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    //loderObj = nil;
    [loderObj removeFromSuperview];
    //[loaderView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}
#pragma mark -btnAction
-(void)backTapped{
    [self.navigationController popViewControllerAnimated:true];

}
- (IBAction)add_BtnAction:(id)sender {
    if (_isFromList) {
        if (!isEdit) {
            [_btnadd setTitle:@"Update" forState:UIControlStateNormal];
            isEdit = true;
            [self textFieldEdit:true];
        }else{
            [self checkForDataForadd:false];
        }
    }else{
        [self checkForDataForadd:true];
    }
   
}

-(void)checkForDataForadd:(BOOL)isAdd{
    NSDictionary *dictForValidation = [self validateData];
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        NSLog(@"Successful");
            [self addressApiIsAdd:isAdd];
        [CommonFunction resignFirstResponderOfAView:self.view];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[dictForValidation valueForKey:AlertKey] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - api related
-(void) addressApiIsAdd:(BOOL)isadd{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    [parameterDict setValue:[CommonFunction trimString:_txt_address1.text] forKey:@"address_line1"];
    [parameterDict setValue:[CommonFunction trimString:_txt_address2.text] forKey:@"address_line2"];
    [parameterDict setValue:[CommonFunction trimString:_txt_city.text] forKey:@"city"];
    [parameterDict setValue:[CommonFunction trimString:_txt_State.text] forKey:@"state"];
    [parameterDict setValue:[CommonFunction trimString:_txt_Pincode.text] forKey:@"pincode"];
    [parameterDict setValue:[CommonFunction trimString:_txt_Landmark.text] forKey:@"landmark"];
    [parameterDict setValue:[CommonFunction trimString:_txt_Country.text] forKey:@"country"];
    [parameterDict setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"user_id"];
    [parameterDict setValue:_addressObj.address_id forKey:@"address_id"];

    
    NSString *urlstring;
    if (isadd) {
        urlstring = API_FOR_CREATE_ADDRESS;
    }else{
        urlstring = API_FOR_Update_ADDRESS;
    }
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,urlstring]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
             if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
                    
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:true];
                    }];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];

                    [self removeloder];
                }
                else
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}

#pragma mark -other


-(NSDictionary *)validateData{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    if (![CommonFunction validateAddress:_txt_address1.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_address1.text].length == 0){
            [validationDict setValue:@"We need a Address Line1" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Address Line1." forKey:AlertKey];
        }
        
    }
    
    else if (![CommonFunction validateAddress:_txt_address2.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_address2.text].length == 0){
            [validationDict setValue:@"We need a Address Line2" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Address Line2." forKey:AlertKey];
        }
    }
    else if (![CommonFunction validateAddress:_txt_Landmark.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_Landmark.text].length == 0){
            [validationDict setValue:@"We need a LandMark" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid LandMark." forKey:AlertKey];
        }
    }
    else if (![CommonFunction validateAddress:_txt_Landmark.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_Landmark.text].length == 0){
            [validationDict setValue:@"We need a LandMark" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid LandMark." forKey:AlertKey];
        }
    }
    else if (![CommonFunction validatePinCode:_txt_Pincode.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_Pincode.text].length == 0){
            [validationDict setValue:@"We need a PinCode" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid PinCode." forKey:AlertKey];
        }
    }
    return validationDict.mutableCopy;
}


@end
