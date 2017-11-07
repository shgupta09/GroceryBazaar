//
//  RearViewController.m
//  TatabApp
//
//  Created by NetprophetsMAC on 10/3/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "RearViewController.h"
#import "RearCell.h"
@interface RearViewController ()
{
    NSArray *titleArray;
    SWRevealViewController *revealController;

}
@end

@implementation RearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     revealController = [self revealViewController];
    titleArray  = [[NSArray alloc]initWithObjects:@"Address",@"My Account",@"Change Password",@"Logout", nil];
     [_tbl_View registerNib:[UINib nibWithNibName:@"RearCell" bundle:nil]forCellReuseIdentifier:@"RearCell"];
  
    _round_View.layer.cornerRadius = _round_View.frame.size.height/2;
    _round_View.clipsToBounds = true;
   
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setData];
}

-(void)setData{
    _lbl_ShortName.text = [[NSString stringWithFormat:@"%@%@",[[CommonFunction getValueFromDefaultWithKey:loginfirstname] substringToIndex:1],[[CommonFunction getValueFromDefaultWithKey:loginlastname] substringToIndex:1]] uppercaseString];
    _lbl_Name.text = [[NSString stringWithFormat:@"%@ %@",[[CommonFunction getValueFromDefaultWithKey:loginfirstname] capitalizedString],[CommonFunction getValueFromDefaultWithKey:loginlastname]] capitalizedString];
    _lbl_number.text = [CommonFunction getValueFromDefaultWithKey:loginPrimarymobile];
    _lbl_address.text = [CommonFunction getValueFromDefaultWithKey:loginemail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RearCell *rearCell = [_tbl_View dequeueReusableCellWithIdentifier:@"RearCell"];
    rearCell.lbl_title.text = [titleArray objectAtIndex:indexPath.row];
    rearCell.imgView.tintColor = [CommonFunction colorWithHexString:COLORCODE];
    UIImage * image = [UIImage imageNamed:[titleArray objectAtIndex:indexPath.row]];
    [rearCell.imgView setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
  
    rearCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return rearCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [revealController revealToggle:nil];
   
        
        switch (indexPath.row) {
                
            case 0:{
                AddressList *addressVCObj = [[AddressList alloc]initWithNibName:@"AddressList" bundle:nil];
                [self.navigationController pushViewController:addressVCObj animated:true];
            }
                break;
            case 1 :{
                ProfileVC *addressVCObj = [[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil];
                [self.navigationController pushViewController:addressVCObj animated:true];
            }
                break;
            case 2 :{
                ChangePasswordVC *changeVCObj = [[ChangePasswordVC alloc]initWithNibName:@"ChangePasswordVC" bundle:nil];
                [self.navigationController pushViewController:changeVCObj animated:true];
            }
                break;
            case 3 :{
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Logout"
                                              message:@"Are you sure you want to Logout?"
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [_tbl_View reloadData];
                                         [CommonFunction stroeBoolValueForKey:isLoggedIn withBoolValue:false];
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         [[NSNotificationCenter defaultCenter]
                                          postNotificationName:@"LogoutNotification"
                                          object:self];
                                         
                                     }];
                UIAlertAction* cancel = [UIAlertAction
                                         actionWithTitle:@"Cancel"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             [[NSNotificationCenter defaultCenter]
                                              postNotificationName:@"CancelNotification"
                                              object:self];
                                             
                                         }];
                
                [alert addAction:ok];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }break;
            default:
                break;
        }
}
@end
