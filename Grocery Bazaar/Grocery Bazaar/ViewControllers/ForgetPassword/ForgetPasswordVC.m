//
//  ForgetPasswordVC.m
//  ShreeAirlines
//
//  Created by NetprophetsMAC on 4/18/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "ForgetPasswordVC.h"

@interface ForgetPasswordVC ()
{
    
    __weak IBOutlet UIView *innerView;
    BOOL isEmail;
    __weak IBOutlet UITextField *txt_Username;
    LoderView *loderObj;
}
@end

@implementation ForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    isEmail = false;
//    txt_Username.text = @"ravimahajan1409@gmail.com";
    [CommonFunction setNavToController:self title:@"Forgot Password" isCrossBusston:true isAddRightButton:false];
    innerView.layer.cornerRadius = 5;
    [txt_Username becomeFirstResponder];
    //txt_Username.text = @"shgupta09@gmail.com";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


#pragma mark - btnActions

- (IBAction)btnAction_Send:(id)sender {
      [CommonFunction resignFirstResponderOfAView:self.view];
    if ([CommonFunction validateEmailWithString:[CommonFunction trimString:txt_Username.text]]){
        [self hitApiForForgotPassword];
    }else{
        NSString *errorString ;
        if ([CommonFunction trimString:txt_Username.text].length == 0) {
            errorString = @"We need an Email ID";
        }
        else{
            errorString = @"Oops! It seems that this is not a valid Email ID";
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:errorString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - other functions

-(void)backTapped{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(BOOL)checkEmailORMobile{
    NSString *userName = [CommonFunction trimString:txt_Username.text];
    if ([CommonFunction validateEmailWithString:userName] == false){
        if ([CommonFunction validateMobile:userName] == false) {
            return false;
        }else{
            isEmail = false;
            return true;
        }
    }else{
        isEmail = true;
        return true;
    }
    
}

#pragma mark - hit api to forgot password

-(void)hitApiForForgotPassword{
  
    //UIView *loderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
        [parameter setValue:[CommonFunction trimString:txt_Username.text] forKey:loginemail];
    
        if ([ CommonFunction reachability]) {
            [self addLoder];
            [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_RESET_PASSWORD_URL]  postResponse:[parameter mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
                if (error == nil) {
                     if ([[responseObj valueForKey:API_Status] integerValue] == 1){
                        [self removeloder];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"We have sent an email with link to reset your password, Please check your inbox!" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [CommonFunction resignFirstResponderOfAView:self.view];
                            [self dismissViewControllerAnimated:true completion:nil];
                            
                        }];
                        [alertController addAction:ok];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    else{
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }
                [self removeloder];
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
    loderObj.lbl_title.text = @"Please wait...";
    [self.view addSubview:loderObj];
    
}

-(void)removeloder{
    //    loderObj = nil;
    [loderObj removeFromSuperview];
    //                [loaderView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}




@end
