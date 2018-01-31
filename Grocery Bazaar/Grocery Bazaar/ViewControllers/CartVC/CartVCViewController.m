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
    CartItem *proDuctObjToAddCArt;
}
@end

@implementation CartVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [CommonFunction setViewBackground:self.view withImage:[UIImage imageNamed:@"BackgroundGeneral.png"]];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    if (cartItemArray.count==0) {
        for (UIView *i in self.view.subviews){
            if([i isKindOfClass:[UILabel class]]){
                UILabel *newLbl = (UILabel *)i;
                if(newLbl.tag == 500){
                    [i removeFromSuperview];
                    /// Write your code
                }
            }
        }
        [CommonFunction addNoDataLabel:self.view];
    }
}
-(void)setData{
    
    [_tblView registerNib:[UINib nibWithNibName:@"CartCellTableViewCell" bundle:nil]forCellReuseIdentifier:@"CartCellTableViewCell"];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 100;
    _tblView.multipleTouchEnabled = NO;
    cartItemArray = [NSMutableArray new];
    cartItemArray = [[CartItem sharedInstance].myDataArray mutableCopy];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removePopUP)];
    
    [_viewToRemovePopUP addGestureRecognizer:singleTap];
    _tblView.hidden = false;
    _checkOutView.hidden = false;
    _btn_CheckOut.tintColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"CheckOut"];
    [_btn_CheckOut setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    if (cartItemArray.count>1) {
        [CommonFunction setNavToController:self title:[NSString stringWithFormat:@"Cart (%d items)",cartItemArray.count] isCrossBusston:false isAddRightButton:false];
        __block int priceCheckout = 0;
        [cartItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            priceCheckout += ([((CartItem *)obj).product_price intValue] * [((CartItem *)obj).quantity integerValue]);
        }];
        _lbl_price_checkout.text = [NSString stringWithFormat:@"₹ %d",priceCheckout];
    }else if(cartItemArray.count == 1){
        __block int priceCheckout = 0;
        [cartItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            priceCheckout += [((CartItem *)obj).product_price intValue]* [((CartItem *)obj).quantity integerValue];
        }];
        _lbl_price_checkout.text = [NSString stringWithFormat:@"₹ %d",priceCheckout];
        [CommonFunction setNavToController:self title:[NSString stringWithFormat:@"Cart (1 item)"] isCrossBusston:false isAddRightButton:false];

    }else{
        _checkOutView.hidden = true;
        [CommonFunction setNavToController:self title:[NSString stringWithFormat:@"Cart"] isCrossBusston:false isAddRightButton:false];
        _tblView.hidden = true;
        [self viewDidLayoutSubviews];
    }
    _VIEWTOCLIP.layer.cornerRadius = 5;
    _VIEWTOCLIP.clipsToBounds = true;
    if (![CommonFunction getBoolValueFromDefaultWithKey:isCartApiHIt]) {
        CartApiHit *cartObj = [CartApiHit new];
        [cartObj hitApiForCartItemscompletetion:^() {
            [self setData];
            [self removePopUP];
            [_tblView reloadData];
        }];
    }
}


#pragma mark -btnAction
-(void)backTapped{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark -other methods


-(void)removePopUP{
    if ([_popUpView isDescendantOfView:self.view]) {
        [_popUpView removeFromSuperview];
    }
}

- (IBAction)btnAction_CheckOut:(id)sender {
    AddressList *addressListObj = [[AddressList alloc]initWithNibName:@"AddressList" bundle:nil];
    addressListObj.isFromCheckout = true;
    [self.navigationController pushViewController:addressListObj animated:true];
}

-(void)editBtnAction:(UIButton *)sender{
    proDuctObjToAddCArt = [CartItem new];
    proDuctObjToAddCArt.product_cart_id =   ((CartItem *)[cartItemArray objectAtIndex:sender.tag]).product_cart_id;
    proDuctObjToAddCArt.product_id =   ((CartItem *)[cartItemArray objectAtIndex:sender.tag]). product_id;
    proDuctObjToAddCArt.quantity =   ((CartItem *)[cartItemArray objectAtIndex:sender.tag]). quantity;
    proDuctObjToAddCArt.product_name =   ((CartItem *)[cartItemArray objectAtIndex:sender.tag]).product_name;
    proDuctObjToAddCArt.product_price =   ((CartItem *)[cartItemArray objectAtIndex:sender.tag]).product_price;
    proDuctObjToAddCArt.created_at =   ((CartItem *)[cartItemArray objectAtIndex:sender.tag]).created_at;
    proDuctObjToAddCArt.stock =   ((CartItem *)[cartItemArray objectAtIndex:sender.tag]).stock;
    _lbl_productName.text = proDuctObjToAddCArt.product_name;
    _lbl_price.text = proDuctObjToAddCArt.product_price;
    _lbl_Quantity.text = proDuctObjToAddCArt.quantity;
    _btnPlus.layer.cornerRadius = _btnPlus.frame.size.width/2;
    _btnPlus.clipsToBounds = true;
    _btnPlus.tintColor = [CommonFunction colorWithHexString:COLORCODE];
    UIImage *image = [UIImage imageNamed:@"Cartadd2"];
    [_btnPlus setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_btnPlus addTarget:self action:@selector(plusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnPlus.tag = sender.tag;
    _btnMinus.tintColor = [CommonFunction colorWithHexString:COLORCODE];
    _btnMinus.clipsToBounds = true;
    _btnMinus.layer.cornerRadius = _btnMinus.frame.size.width/2;
    image = [UIImage imageNamed:@"minus2"];
    [_btnMinus setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_btnMinus addTarget:self action:@selector(minusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnMinus.tag = sender.tag;
    _viewToRound.clipsToBounds = true;
    _viewToRound.layer.cornerRadius = _btnPlus.frame.size.width/2;
    _viewToRound2.clipsToBounds = true;
    _viewToRound2.layer.cornerRadius = _btnPlus.frame.size.width/2;
    _btn_done.tag = ((UIButton *)sender).tag;
    
    [[self popUpView] setAutoresizesSubviews:true];
    [[self popUpView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
    frame.origin.y = 0.0f;
    self.popUpView.center = CGPointMake(self.view.center.x, self.view.center.y);
    [[self popUpView] setFrame:frame];
    
    
 
    [self.view addSubview:_popUpView];
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
    cell.lbl_CartQuantity.text = productObj.quantity;
    [cell.imgView_Product sd_setImageWithURL:[NSURL URLWithString:productObj.product_image]] ;

    cell.viewToClip.layer.cornerRadius = 10;
    cell.viewToClip.clipsToBounds = true;
    cell.btnCross.tintColor = [UIColor lightGrayColor];
    UIImage * image = [UIImage imageNamed:@"RemoveFromCart"];
    [cell.btnCross setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [cell.btnCross addTarget:self action:@selector(crossBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnCross.tag = indexPath.row;
    
    cell.btnEdit.tintColor = [UIColor lightGrayColor];
    image = [UIImage imageNamed:@"edit"];
    [cell.btnEdit setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [cell.btnEdit addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnEdit.tag = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)crossBtnAction:(UIButton *)sender{
    [self hitApiForDeleteFromCart:[cartItemArray objectAtIndex:sender.tag]];
}

-(void)plusBtnAction:(UIButton *)sender{
    
    
    if ([proDuctObjToAddCArt.quantity integerValue]<[((CartItem *)[cartItemArray objectAtIndex:sender.tag]).stock integerValue]) {
        
        
        proDuctObjToAddCArt.quantity = [NSString stringWithFormat:@"%d", ([proDuctObjToAddCArt.quantity integerValue]+1)];
        _lbl_Quantity.text = proDuctObjToAddCArt.quantity;
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Upper limit reached" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}

-(void)minusBtnAction:(UIButton *)sender{
    
    if ([proDuctObjToAddCArt.quantity integerValue]>1) {
        NSString *str =[NSString stringWithFormat:@"%d", ([proDuctObjToAddCArt.quantity integerValue]-1)];
        proDuctObjToAddCArt.quantity  = str;
        _lbl_Quantity.text = proDuctObjToAddCArt.quantity;
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Lower limit reached" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (IBAction)doneBtnAction:(id)sender {
    if (![proDuctObjToAddCArt.quantity isEqualToString:(((CartItem *)[cartItemArray objectAtIndex:((UIButton *)sender).tag])).quantity]) {
        [self hitApiForAddToCart:proDuctObjToAddCArt];

    }else{
        [self removePopUP];
    }
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
                    [self setData];
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
-(void)hitApiForAddToCart:(CartItem *)product{
    [self addLoder];
    if ([ CommonFunction reachability]) {
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
        [parameter setValue:product.product_id forKey:@"product_id"];
        
        [parameter setObject:proDuctObjToAddCArt.quantity forKey:@"quantity"];
        
        
        
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_ADD_TO_CART]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
                    [[CartItem sharedInstance].myDataArray addObject:product];
                    cartItemArray = [[CartItem sharedInstance].myDataArray mutableCopy];
                    CartApiHit *cartObj = [CartApiHit new];
                    [cartObj hitApiForCartItemscompletetion:^() {
                        [self setData];
                        [self removePopUP];
                        [_tblView reloadData];
                    }];
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
