//
//  ChangePasswordVC.m
//  Grocery Bazaar
//
//  Created by NetprophetsMAC on 11/7/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC (){
    LoderView *loderObj;

}

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _txt_password.text = @"Admin@12";
    _txt_ConfirmPassword.text = @"Admin@12";
    _txtNewPassword.text = @"Admin@12";
    [self setData];
    [CommonFunction setViewBackground:self.view withImage:[UIImage imageNamed:@"BackgroundGeneral.png"]];
}

-(void)setData{
    [CommonFunction setNavToController:self title:@"Change Password" isCrossBusston:false isAddRightButton:false rightImageName:@""];
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
#pragma mark -other


-(NSDictionary *)validateData{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
     if(![CommonFunction isValidPassword:[CommonFunction trimString:_txt_password.text]] ){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_password.text].length == 0) {
            [validationDict setValue:@"We need a Password" forKey:AlertKey];
        }
     } else if(![CommonFunction isValidPassword:[CommonFunction trimString:_txtNewPassword.text]] ){
         [validationDict setValue:@"0" forKey:BoolValueKey];
         if ([CommonFunction trimString:_txtNewPassword.text].length == 0) {
             [validationDict setValue:@"We need a Password" forKey:AlertKey];
         }
         else{
             [validationDict setValue:@"Incorrect Password. The correct password must have a minimum of 8 characters; with at least one character in upper case and at least one special character or number." forKey:AlertKey];
         }
     }
     else if(![CommonFunction isValidPassword:[CommonFunction trimString:_txt_ConfirmPassword.text]] ){
         [validationDict setValue:@"0" forKey:BoolValueKey];
         if ([CommonFunction trimString:_txt_ConfirmPassword.text].length == 0) {
             [validationDict setValue:@"We need a Password" forKey:AlertKey];
         }
         else{
             [validationDict setValue:@"Incorrect Password. The correct password must have a minimum of 8 characters; with at least one character in upper case and at least one special character or number." forKey:AlertKey];
         }
     }
     else if(![_txt_ConfirmPassword.text isEqualToString:_txtNewPassword.text] ){
         [validationDict setValue:@"0" forKey:BoolValueKey];
         [validationDict setValue:@"Missmatch Password. New Password and Confirm Password should be same." forKey:AlertKey];
         
     }else if(![[CommonFunction trimString:_txt_password.text]isEqualToString:[CommonFunction getValueFromDefaultWithKey:loginPassword]]){
         [validationDict setValue:@"0" forKey:BoolValueKey];
         [validationDict setValue:@"Old password is not correct." forKey:AlertKey];
     }
    return validationDict.mutableCopy;
    
}
#pragma mark - add loder

-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = @"Updating...";
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    //loderObj = nil;
    [loderObj removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}
#pragma mark -btnAction
-(void)backTapped{
    [self.navigationController popViewControllerAnimated:true];
    
}
- (IBAction)btnAction_ChangePassword:(id)sender {
    
    NSDictionary *dictForValidation = [self validateData];
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        NSLog(@"Successful");
        [CommonFunction resignFirstResponderOfAView:self.view];
        [self hitApiForChangePassword];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[dictForValidation valueForKey:AlertKey] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(void)hitApiForChangePassword{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    [parameterDict setValue:[CommonFunction trimString:_txtNewPassword.text] forKey:loginfirstname];
    [parameterDict setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_CHANGE_PASSWORD]   postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
               if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
                   [CommonFunction storeValueInDefault:[CommonFunction trimString:_txt_ConfirmPassword.text] andKey:loginPassword];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:true];
                    }];
                    [alertController addAction:ok];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                }
                else
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
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
@end
