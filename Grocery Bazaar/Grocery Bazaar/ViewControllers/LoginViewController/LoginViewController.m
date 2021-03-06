//
//  LoginViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 20/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet CustomTextField *txtUsername;
@property (weak, nonatomic) IBOutlet CustomTextField *txtPassword;

@end

@implementation LoginViewController{

    LoderView *loderObj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [CommonFunction setResignTapGestureToView:self.view andsender:self];
    _btn_Register.layer.borderWidth = 2;
    _btn_Register.layer.borderColor = [CommonFunction colorWithHexString:primary_Button_Color].CGColor;

    _txtPassword.text = @"Gupta@123";
    _txtUsername.text = @"shgupta09@gmail.com";

    [CommonFunction setViewBackground:self.view withImage:[UIImage imageNamed:@"BackgroundGeneral.png"]];

    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)resignResponder{
    [CommonFunction resignFirstResponderOfAView:self.view];
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
#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)btnRegisterClicked:(id)sender {

    
    RegisterViewController *objVC = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
   
    [self presentViewController:objVC animated:true completion:nil];
    
}
- (IBAction)btnAction_ForgotPassword:(id)sender {
    ForgetPasswordVC *vc = [[ForgetPasswordVC alloc] initWithNibName:@"ForgetPasswordVC" bundle:nil];
    [self presentViewController:vc animated:true completion:nil];
    
}

- (IBAction)btnAction_Login:(id)sender {
   
    NSDictionary *dictForValidation = [self validateData];
    
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
       [self loginFunction];
    }
    else{
        [self removeloder];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[dictForValidation valueForKey:AlertKey] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

-(void) loginFunction {
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    [parameterDict setValue:[CommonFunction trimString:_txtUsername.text] forKey:loginemail];
    [parameterDict setValue:[CommonFunction trimString:_txtPassword.text] forKey:loginPassword];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_LOGIN_URL]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
             if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
                   
                    
                    [self performBlock:^{
                        
                        
                        [CommonFunction stroeBoolValueForKey:isLoggedIn withBoolValue:true];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginfirstname] andKey:loginfirstname];
                        [CommonFunction storeValueInDefault:[CommonFunction trimString:_txtPassword.text] andKey:loginPassword];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:@"id"] andKey:loginuserId];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserGender] andKey:loginuserGender];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginemail] andKey:loginemail];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginlastname] andKey:loginlastname];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginPrimarymobile] andKey:loginPrimarymobile];
                         [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:@"dob"] andKey:loginDob];
                        RearViewController *rearViewController = [[RearViewController alloc]initWithNibName:@"RearViewController" bundle:nil];
                        SWRevealViewController *mainRevealController;

                        HomeViewController *frontViewController = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        mainRevealController = [[SWRevealViewController alloc]initWithRearViewController:rearViewController frontViewController:frontViewController];
                        mainRevealController.delegate = self;
                        mainRevealController.view.backgroundColor = [UIColor blackColor];
                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainRevealController];
                        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = nav;
                        [self resignResponder];
                    } afterDelay:.2];
                    
                    [self removeloder];
                }
                else{
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

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}


#pragma mark - add loder

-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = @"Logging In...";
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    [loderObj removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}
-(NSDictionary *)validateData{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    if (![CommonFunction validateEmailWithString:[CommonFunction trimString:_txtUsername.text]]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtUsername.text].length == 0){
            [validationDict setValue:@"We need an Email ID" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Email ID." forKey:AlertKey];
        }
    }
    else if([CommonFunction trimString:_txtPassword.text].length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:@"We need a Password" forKey:AlertKey];
    }
    return validationDict.mutableCopy;
}



@end
