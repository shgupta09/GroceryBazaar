//
//  OrderListVC.m
//  Grocery Bazaar
//
//  Created by NetprophetsMAC on 11/7/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "OrderListVC.h"
#import "ProductCell.h"
#import "AddressCell.h"
#import "PaymentModeCell.h"

@interface OrderListVC (){
  NSMutableArray *cartArray;
    LoderView *loderObj;
__block int priceCheckout ;

}
@end

@implementation OrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setData{
    priceCheckout = 0;
    [_tblView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil]forCellReuseIdentifier:@"ProductCell"];
    [_tblView registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil]forCellReuseIdentifier:@"AddressCell"];
    [_tblView registerNib:[UINib nibWithNibName:@"PaymentModeCell" bundle:nil]forCellReuseIdentifier:@"PaymentModeCell"];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 100;
    
    [CommonFunction setResignTapGestureToView:self.view andsender:self];
    [CommonFunction setNavToController:self title:[NSString stringWithFormat:@"Confirm Order"] isCrossBusston:false isAddRightButton:false];
    cartArray = [NSMutableArray new];
    cartArray = [CartItem sharedInstance].myDataArray;
    
    [cartArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        priceCheckout += ([((CartItem *)obj).product_price intValue] * [((CartItem *)obj).quantity integerValue]);
    }];
//    _lbl_TotalPrice.text = [NSString stringWithFormat:@"₹ %d",priceCheckout];
    
}
#pragma mark -btnAction
-(void)backTapped{
    [self.navigationController popViewControllerAnimated:true];
}



#pragma mark- Table Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cartArray.count+2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentModeCell *paymentCell;
    AddressCell *addressCell;
    ProductCell *productCell;
    
    if (indexPath.row<cartArray.count) {
        productCell = [_tblView dequeueReusableCellWithIdentifier:@"ProductCell"];
        CartItem *obj = [cartArray objectAtIndex:indexPath.row];
        productCell.lblName.text = obj.product_name;
        productCell.lbl_Price.text = obj.product_price;
        productCell.lbl_Quantity.text = obj.quantity;
        [productCell.imgView sd_setImageWithURL:[NSURL URLWithString:obj.product_image]];
        productCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return productCell;
    }else if (indexPath.row == cartArray.count){
        addressCell = [_tblView dequeueReusableCellWithIdentifier:@"AddressCell"];
        
        addressCell.lbl_Name.text = [NSString stringWithFormat:@"%@ %@",[[CommonFunction getValueFromDefaultWithKey:loginfirstname] capitalizedString],[[CommonFunction getValueFromDefaultWithKey:loginlastname] capitalizedString]];
//        addressCell.lbl_address.text = [NSString stringWithFormat:@"%@%@,%@,%@\n%@,%@",
//                                        _selectedAdderss.address_line1,
//                                        _selectedAdderss.address_line2,
//                                        _selectedAdderss.landmark,
//                                        _selectedAdderss.pincode,
//                                        _selectedAdderss.city,
//                                        _selectedAdderss.state];
        
        addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return addressCell;
        
        
    }else if (indexPath.row > cartArray.count){
        paymentCell = [_tblView dequeueReusableCellWithIdentifier:@"PaymentModeCell"];
        paymentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return paymentCell;
    }
    
    
    return paymentCell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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


-(void)hitApiForPlaceOrder{
    
    if ([ CommonFunction reachability]) {
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
//        [parameter setValue:_selectedAdderss.address_id forKey:@"address_id"];
        NSMutableArray *productIdArray = [NSMutableArray new];
        [cartArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [productIdArray addObject:((CartItem *)obj).product_id];
        }];
        [parameter setValue:productIdArray forKey:@"product"];
        [parameter setValue:[NSString stringWithFormat:@"%d",priceCheckout] forKey:@"total_amount"];
        [parameter setValue:@"OFFER" forKey:@"offer_code"];
        [parameter setValue:@"CASH" forKey:@"payment_type"];
        [self addLoder];
        
        
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_PLACE_ORDER]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
//                    CongoVC *congoVCObj = [[CongoVC alloc]initWithNibName:@"CongoVC" bundle:nil];
//                    [self.navigationController pushViewController:congoVCObj animated:true];
                }
                else{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
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
            [self removeloder];
        }];
        
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}




@end
