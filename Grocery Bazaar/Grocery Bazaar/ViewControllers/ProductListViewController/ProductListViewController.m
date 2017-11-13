//
//  ProductListViewController.m
//  Grocery Bazaar
//
//

#import "ProductListViewController.h"

@interface ProductListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    LoderView *loderObj;
    NSMutableArray* arrProducts;
    NSMutableArray* cartItemArray;
}
@end

@implementation ProductListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    [self setData];
    if (![CommonFunction getBoolValueFromDefaultWithKey:isCartApiHIt]) {
        cartItemArray = [NSMutableArray new];
        cartItemArray = [[CartItem sharedInstance].myDataArray mutableCopy];
        [self hitApiForProductList];
    }else{
        cartItemArray = [[CartItem sharedInstance].myDataArray mutableCopy];
        [self hitApiForProductList];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setData{
    [_tblView registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:nil]forCellReuseIdentifier:@"ProductTableViewCell"];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 100;
    _tblView.multipleTouchEnabled = NO;
    arrProducts = [[NSMutableArray alloc] init];
    
    [CommonFunction setNavToController:self title:@"Products" isCrossBusston:false isAddRightButton:false];
}
#pragma mark - Api Related Methods
-(void)hitApiForProductList{
        if ([ CommonFunction reachability]) {
           
    
            NSMutableDictionary *parameter = [NSMutableDictionary new];
    
            [parameter setValue:_subCategory.catId forKey:productCategory_id];
            [parameter setValue:_subCategory.subcat_id forKey:productsubcategory_id];
            
            [self addLoder];
            //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
            [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_PRODUCTLIST]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
                if (error == nil) {
                    if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
    
                        NSArray *tempAray = [responseObj valueForKey:@"product"];
                        arrProducts = [NSMutableArray new];
                        [tempAray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            Product* c = [[Product alloc] init ];
                            c.selectedQuantity = @"1";
                            [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                                [CommonFunction checkForNull:obj] ;
                                [c setValue:[CommonFunction checkForNull:obj] forKey:(NSString *)key];
                                
                            }];
                            
                            [arrProducts addObject:c];
                        }];
                        
                        [arrProducts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSLog(@"%@", ((Product*)obj).product_id);
                            [cartItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                                NSLog(@"%@",((CartItem *)obj2).product_id);

                                if ([((CartItem *)obj2).product_cart_id isEqualToString:((Product*)obj).product_id]) {
                                    Product *productObj = obj;
                                    productObj.selectedQuantity = ((CartItem *)obj2).quantity;
                                    [arrProducts replaceObjectAtIndex:idx withObject:productObj];
                                }
                            }];
                        }];
                        [_tblView reloadData];
                        
                        if(arrProducts.count == 0){
                            _tblView.hidden = true;
                            [CommonFunction addNoDataLabel:self.view];
                        }
                        [self removeloder];
                    }
                    else{
                        _tblView.hidden = true;
                        [CommonFunction addNoDataLabel:self.view];
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



-(void)hitApiForAddToCart:(Product *)product{
    [self addLoder];
    if ([ CommonFunction reachability]) {
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
        [parameter setValue:product.product_id forKey:@"product_id"];
        [parameter setObject:product.selectedQuantity forKey:@"quantity"];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_ADD_TO_CART]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
                    [CommonFunction stroeBoolValueForKey:isCartApiHIt withBoolValue:false];
                    CartApiHit *cartObj = [CartApiHit new];
                    [cartObj hitApiForCartItemscompletetion:^() {
                        cartItemArray = [NSMutableArray new];
                        cartItemArray = [[CartItem sharedInstance].myDataArray mutableCopy];
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
    
    if (arrProducts.count>0) {
        _tblView.hidden = false;
    }else{
        _tblView.hidden = true;
    }
    return arrProducts.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductTableViewCell *cell = [_tblView dequeueReusableCellWithIdentifier:@"ProductTableViewCell"];
    Product *productObj = [arrProducts objectAtIndex:indexPath.row];
    cell.lblHeading.text = productObj.product_name;
    cell.lblPrice.text = productObj.product_price;
    cell.viewToClip.layer.cornerRadius = 10;
    cell.viewToClip.clipsToBounds = true;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:productObj.product_thum]] ;
    cell.imgView.layer.cornerRadius = 20;
    cell.imgView.clipsToBounds =true;
     UIImage * image = [UIImage imageNamed:@"addButton"];
    
    if ([self isItemFromCart:productObj.product_id]) {
        cell.btn_AddToCart.tintColor = [CommonFunction colorWithHexString:COLORCODE];

        cell.btn_AddToCart.userInteractionEnabled = false;
        image = [UIImage imageNamed:@"Cart"];
        [cell.btn_AddToCart setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        CartItem *tempObj = ((CartItem *)[self getItemFromCart:productObj.product_id]);
        cell.lbl_Quantity.text = tempObj.quantity;
        productObj.selectedQuantity = tempObj.quantity;
        

    }else{
        
        cell.btn_AddToCart.tintColor = [CommonFunction colorWithHexString:COLORCODE];
        image = [UIImage imageNamed:@"AddToCartIcon"];
        [cell.btn_AddToCart setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [cell.btn_AddToCart addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_AddToCart.tag = indexPath.row;
        cell.btn_AddToCart.userInteractionEnabled = true;

        cell.lbl_Quantity.text = productObj.selectedQuantity;
        
    }
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
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}
-(BOOL)isItemFromCart:(NSString *)productId{
   
    for (int i = 0; i<cartItemArray.count; i++) {
        CartItem *obj = [cartItemArray objectAtIndex:i];
        if ([productId isEqualToString:obj.product_id]) {
            return true;
        }
    }

            return false;
}

-(CartItem *)getItemFromCart:(NSString *)productId{
    CartItem *obj;
    for (int i = 0; i<cartItemArray.count; i++) {
        obj = [cartItemArray objectAtIndex:i];
        if ([productId isEqualToString:obj.product_id]) {
            return obj;
        }
    }
    
    return obj;
}

-(void)plusBtnAction:(UIButton *)sender{
    
    
    if ([((Product *)[arrProducts objectAtIndex:sender.tag]).selectedQuantity integerValue]<[((Product *)[arrProducts objectAtIndex:sender.tag]).stock integerValue]) {
         Product *proDuctObj = [arrProducts objectAtIndex:sender.tag];
        
        
        proDuctObj.selectedQuantity = [NSString stringWithFormat:@"%d", ([((Product *)[arrProducts objectAtIndex:sender.tag]).selectedQuantity integerValue]+1)];
       
        [cartItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([((CartItem *)(obj)).product_id isEqualToString:proDuctObj.product_id]) {
                [cartItemArray removeObject:obj];
            }
        }];

        [_tblView reloadData];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Upper limit reached" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    
    }
    
    
    
    
}

-(void)minusBtnAction:(UIButton *)sender{
    
    if ([((Product *)[arrProducts objectAtIndex:sender.tag]).selectedQuantity integerValue]>1) {
        Product *proDuctObj = [arrProducts objectAtIndex:sender.tag];
        
        
        proDuctObj.selectedQuantity = [NSString stringWithFormat:@"%d", ([((Product *)[arrProducts objectAtIndex:sender.tag]).selectedQuantity integerValue]-1)];
        
        [cartItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([((CartItem *)(obj)).product_id isEqualToString:proDuctObj.product_id]) {
                [cartItemArray removeObject:obj];
            }
        }];
        
        [_tblView reloadData];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Lower limit reached" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

-(void)addToCart:(UIButton *)sender{
    
    [self hitApiForAddToCart:[arrProducts objectAtIndex:sender.tag]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    SubCategory *obj = [[AddressVC alloc]initWithNibName:@"AddressVC" bundle:nil];
    //    addressVCObj.isFromList = true;
    //    addressVCObj.addressObj = [listArray objectAtIndex:indexPath.row];
    //    [self.navigationController pushViewController:addressVCObj animated:true];
}



@end

