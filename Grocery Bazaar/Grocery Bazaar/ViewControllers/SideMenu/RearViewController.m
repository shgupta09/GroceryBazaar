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
    titleArray  = [[NSArray alloc]initWithObjects:@"Abc",@"Awareness",@"Logout", nil];
     [_tbl_View registerNib:[UINib nibWithNibName:@"RearCell" bundle:nil]forCellReuseIdentifier:@"RearCell"];
    _lbl_ShortName.text = [[NSString stringWithFormat:@"%@%@",[[CommonFunction getValueFromDefaultWithKey:loginfirstname] substringToIndex:1],[[CommonFunction getValueFromDefaultWithKey:loginlastname] substringToIndex:1]] uppercaseString];
    _round_View.layer.cornerRadius = _round_View.frame.size.height/2;
    _round_View.clipsToBounds = true;
    _lbl_Name.text = [NSString stringWithFormat:@"%@ %@",[CommonFunction getValueFromDefaultWithKey:loginfirstname],[CommonFunction getValueFromDefaultWithKey:loginlastname]];
    _lbl_number.text = [CommonFunction getValueFromDefaultWithKey:loginPrimarymobile];
    _lbl_address.text = [CommonFunction getValueFromDefaultWithKey:loginemail];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RearCell *rearCell = [_tbl_View dequeueReusableCellWithIdentifier:@"RearCell"];
    rearCell.lbl_title.text = [titleArray objectAtIndex:indexPath.row];
    rearCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return rearCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [revealController revealToggle:nil];
   
        
        switch (indexPath.row) {
                
            case 0:{
                
            }
                break;
            case 1 :{
             
            }
                
                break;
            case 2 :{
                
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
