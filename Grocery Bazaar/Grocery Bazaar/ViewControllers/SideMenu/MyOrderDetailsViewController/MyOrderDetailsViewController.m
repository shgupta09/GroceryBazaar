//
//  MyOrderDetailsViewController.m
//  Grocery Bazaar
//
//  Created by Shagun Verma on 22/11/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "MyOrderDetailsViewController.h"

@interface MyOrderDetailsViewController ()

@end

@implementation MyOrderDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [CommonFunction setViewBackground:self.view withImage:[UIImage imageNamed:@"BackgroundGeneral.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setData{
    [_tblView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil]forCellReuseIdentifier:@"ProductCell"];
    [_tblView registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil]forCellReuseIdentifier:@"AddressCell"];
    [_tblView registerNib:[UINib nibWithNibName:@"PaymentModeCell" bundle:nil]forCellReuseIdentifier:@"PaymentModeCell"];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 100;
    
    [CommonFunction setNavToController:self title:[NSString stringWithFormat:@"Confirm Order"] isCrossBusston:false isAddRightButton:false rightImageName:@""];
    
}
#pragma mark -btnAction
-(void)backTapped{
    [self.navigationController popViewControllerAnimated:true];
}



#pragma mark- Table Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderObj.order_products.count+3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentModeCell *paymentCell;
    AddressCell *addressCell;
    ProductCell *productCell;
    
    if (indexPath.row<_orderObj.order_products.count) {
        productCell = [_tblView dequeueReusableCellWithIdentifier:@"ProductCell"];
        MyOrderProducts *obj = [_orderObj.order_products objectAtIndex:indexPath.row];
        productCell.lblName.text = obj.product_name;
        productCell.lbl_Price.text = obj.price;
        productCell.lbl_Quantity.text = obj.product_quantity;
        productCell.imgView.layer.borderWidth = 1.0;
        productCell.imgView.layer.borderColor = [CommonFunction colorWithHexString:primary_Button_Color].CGColor;
//        [productCell.imgView sd_setImageWithURL:[NSURL URLWithString:obj.]];
        productCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return productCell;
    }else if (indexPath.row == _orderObj.order_products.count){
        addressCell = [_tblView dequeueReusableCellWithIdentifier:@"AddressCell"];
        Address* address = [Address new];
        address = [_orderObj.shipping_address objectAtIndex:0];
        addressCell.lbl_Name.text = [NSString stringWithFormat:@"%@ %@",[[CommonFunction getValueFromDefaultWithKey:loginfirstname] capitalizedString],[[CommonFunction getValueFromDefaultWithKey:loginlastname] capitalizedString]];
            addressCell.lbl_address.text = [NSString stringWithFormat:@"%@%@,%@,%@\n%@,%@",
                                                address.address_line1,
                                                address.address_line2,
                                                address.landmark,
                                                address.pincode,
                                                address.city,
                                                address.state];
        
        addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return addressCell;
        
        
    }else if (indexPath.row > _orderObj.order_products.count){
        paymentCell = [_tblView dequeueReusableCellWithIdentifier:@"PaymentModeCell"];
        paymentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return paymentCell;
    }
    
    
    return paymentCell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}



@end
