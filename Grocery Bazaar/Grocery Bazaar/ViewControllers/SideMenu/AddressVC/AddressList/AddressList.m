//
//  AddressList.m
//  Grocery Bazaar
//
//  Created by shubham gupta on 10/31/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "AddressList.h"
#import "AddessListCell.h"
@interface AddressList ()
{
    LoderView *loderObj;
    NSMutableArray *listArray;
}

@end

@implementation AddressList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hitApiForAddressList];

}

-(void)setData{
    [_tbl_List registerNib:[UINib nibWithNibName:@"AddessListCell" bundle:nil]forCellReuseIdentifier:@"AddessListCell"];
    _tbl_List.rowHeight = UITableViewAutomaticDimension;
    _tbl_List.estimatedRowHeight = 100;
    _tbl_List.multipleTouchEnabled = NO;
    [CommonFunction setNavToController:self title:@"Address" isCrossBusston:false isAddRightButton:true];
}
#pragma mark - Api Related Methods
-(void)hitApiForAddressList{
    if ([ CommonFunction reachability]) {
        listArray = [NSMutableArray new];

        NSMutableDictionary *parameter = [NSMutableDictionary new];
                                          
        [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];

        [self addLoder];
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_ADDRESS_LIST]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
               if ([[responseObj valueForKey:API_Status] integerValue] == 1){
                    
                   NSArray *tempAray = [responseObj valueForKey:@"addresses"];
                   [tempAray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                       Address *addressObj = [Address new];
                       addressObj.address_id= [obj valueForKey:@"address_id"];
                       addressObj.address_line1= [obj valueForKey:@"address_line1"];
                       addressObj.address_line2= [obj valueForKey:@"address_line2"];
                       addressObj.city= [obj valueForKey:@"city"];
                       addressObj.country= [obj valueForKey:@"country"];
                       addressObj.pincode= [obj valueForKey:@"pincode"];
                       addressObj.state= [obj valueForKey:@"state"];
                       
                       addressObj.landmark= [obj valueForKey:@"landmark"];
                       [listArray addObject:addressObj];
                   }];
                   [_tbl_List reloadData];
                   
                }
               else{
                   _tbl_List.hidden = true;
                   [CommonFunction addNoDataLabel:self.view];
               }
                [self removeloder];
                
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
-(void)addAddress{
    AddressVC *addressVCObj = [[AddressVC alloc]initWithNibName:@"AddressVC" bundle:nil];
    [self.navigationController pushViewController:addressVCObj animated:true];
    
    
}


#pragma mark- Table Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (listArray.count>0) {
        _tbl_List.hidden = false;
    }else{
        _tbl_List.hidden = true;
    }
    return listArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddessListCell *cityCell = [_tbl_List dequeueReusableCellWithIdentifier:@"AddessListCell"];
    Address *obj = [listArray objectAtIndex:indexPath.row];
    cityCell.lbl_title.text = obj.address_line1;
    cityCell.lbl_subTitle.text = obj.landmark;
    cityCell.lbl_state.text = obj.state;
    
    
    cityCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cityCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressVC *addressVCObj = [[AddressVC alloc]initWithNibName:@"AddressVC" bundle:nil];
    addressVCObj.isFromList = true;
    addressVCObj.addressObj = [listArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:addressVCObj animated:true];
}


@end
