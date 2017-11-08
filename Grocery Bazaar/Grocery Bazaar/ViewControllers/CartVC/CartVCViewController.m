//
//  CartVCViewController.m
//  Grocery Bazaar
//
//  Created by shubham gupta on 11/8/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "CartVCViewController.h"

@interface CartVCViewController (){
    LoderView *loderObj;
    NSMutableArray *cartItemArray;
}
@end

@implementation CartVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];

    // Do any additional setup after loading the view from its nib.
}
-(void)setData{
    
    [_tblView registerNib:[UINib nibWithNibName:@"CartCellTableViewCell" bundle:nil]forCellReuseIdentifier:@"CartCellTableViewCell"];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 100;
    _tblView.multipleTouchEnabled = NO;
    cartItemArray = [NSMutableArray new];
    cartItemArray = [[CartItem sharedInstance].myDataArray mutableCopy];
    [CommonFunction setNavToController:self title:@"Cart" isCrossBusston:false isAddRightButton:false];
}


#pragma mark -btnAction
-(void)backTapped{
    
    [self.navigationController popViewControllerAnimated:true];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Table Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return cartItemArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartCellTableViewCell *cell = [_tblView dequeueReusableCellWithIdentifier:@"CartCellTableViewCell"];
    CartItem *productObj = [cartItemArray objectAtIndex:indexPath.row];
    cell.lbl_Product_Name.text = productObj.product_name;
    cell.lbl_Product_Price.text = productObj.product_price;
    cell.lbl_Quantity.text = productObj.quantity;
//    [cell.imgView_Product sd_setImageWithURL:[NSURL URLWithString:productObj.product_cart_id]] ;
    
    
    cell.btnCross.tintColor = [UIColor lightGrayColor];
    UIImage * image = [UIImage imageNamed:@"NavigationCross"];
    [cell.btnCross setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [cell.btnCross addTarget:self action:@selector(crossBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnCross.tag = indexPath.row;
    
    
    cell.btnPlus.layer.cornerRadius = cell.btnPlus.frame.size.width/2;
    cell.btnPlus.clipsToBounds = true;
    cell.btnPlus.tintColor = [CommonFunction colorWithHexString:COLORCODE];
    image = [UIImage imageNamed:@"Cartadd2"];
    [cell.btnPlus setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [cell.btnPlus addTarget:self action:@selector(plusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnPlus.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.btnMinus.tintColor = [CommonFunction colorWithHexString:COLORCODE];
    cell.btnMinus.clipsToBounds = true;
    cell.btnMinus.layer.cornerRadius = cell.btnMinus.frame.size.width/2;
    image = [UIImage imageNamed:@"minus2"];
    [cell.btnMinus setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [cell.btnMinus addTarget:self action:@selector(minusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnMinus.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.viewToRound.clipsToBounds = true;
    cell.viewToRound.layer.cornerRadius = cell.btnMinus.frame.size.width/2;
    cell.viewToRound2.clipsToBounds = true;
    cell.viewToRound2.layer.cornerRadius = cell.btnMinus.frame.size.width/2;
    return cell;
    
}

-(void)crossBtnAction:(UIButton *)sender{
    [self hitApiForDeleteFromCart:[cartItemArray objectAtIndex:sender.tag]];
}

-(void)plusBtnAction:(UIButton *)sender{
    CartItem *cartItemObj = [cartItemArray objectAtIndex:sender.tag];
    
    
    
    
}

-(void)minusBtnAction:(UIButton *)sender{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    SubCategory *obj = [[AddressVC alloc]initWithNibName:@"AddressVC" bundle:nil];
    //    addressVCObj.isFromList = true;
    //    addressVCObj.addressObj = [listArray objectAtIndex:indexPath.row];
    //    [self.navigationController pushViewController:addressVCObj animated:true];
}

#pragma mark- Api Related
-(void)hitApiForDeleteFromCart:(CartItem *)cartItem{
    [self addLoder];
    if ([ CommonFunction reachability]) {
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
        [parameter setValue:cartItem.product_cart_id forKey:@"product_cart_id"];
        
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_DELETE_FROM_CART]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
                    [[CartItem sharedInstance].myDataArray removeObject:cartItem];
                    cartItemArray = [[CartItem sharedInstance].myDataArray mutableCopy];
                    [_tblView reloadData];
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
-(void)hitApiForAddToCart:(Product *)product{
    [self addLoder];
    if ([ CommonFunction reachability]) {
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
        [parameter setValue:product.product_id forKey:@"product_id"];
        
        [parameter setObject:@"1" forKey:@"quantity"];
        
        
        
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_ADD_TO_CART]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
                    [[CartItem sharedInstance].myDataArray addObject:product];
                    cartItemArray = [[CartItem sharedInstance].myDataArray mutableCopy];
                    [_tblView reloadData];
                    
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


@end
