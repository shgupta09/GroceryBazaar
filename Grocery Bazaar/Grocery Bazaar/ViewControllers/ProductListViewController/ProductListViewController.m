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
    
    arrProducts = [[NSMutableArray alloc] init];
    
    [self setData];
    [self hitApiForProductList];
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
    [_tblView reloadData];
    [CommonFunction setNavToController:self title:@"Products" isCrossBusston:false isAddRightButton:false];
}
#pragma mark - Api Related Methods
-(void)hitApiForProductList{
        if ([ CommonFunction reachability]) {
            arrProducts = [NSMutableArray new];
    
            NSMutableDictionary *parameter = [NSMutableDictionary new];
    
            [parameter setValue:_subCategory.catId forKey:productCategory_id];
            [parameter setValue:_subCategory.subcat_id forKey:productsubcategory_id];
            
            [self addLoder];
            //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
            [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_PRODUCTLIST]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
                if (error == nil) {
                    if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
    
                        NSArray *tempAray = [responseObj valueForKey:@"product"];
                        [tempAray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            Product* c = [[Product alloc] init  ];
                            
                            [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                                [CommonFunction checkForNull:obj] ;
                                [c setValue:[CommonFunction checkForNull:obj] forKey:(NSString *)key];
                            }];
                            
                            [arrProducts addObject:c];
                        }];
                        [_tblView reloadData];
                        
                        if(arrProducts.count == 0){
                            _tblView.hidden = true;
                            [CommonFunction addNoDataLabel:self.view];
                        }
                    }
                    else{
                        _tblView.hidden = true;
                        [CommonFunction addNoDataLabel:self.view];
                    }
                    [self hitApiForCartItems];
    
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

-(void)hitApiForCartItems{
    if ([ CommonFunction reachability]) {
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
        
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_CART_ITEMS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
                    
                    NSArray *tempAray = [responseObj valueForKey:@"cart"];
                    [tempAray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        CartItem* productObj = [[CartItem alloc] init  ];
                        
                        [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                            [productObj setValue:[CommonFunction checkForNull:obj] forKey:(NSString *)key];
                        }];
                        
                        [[CartItem sharedInstance].myDataArray addObject:productObj];
                    }];
                    cartItemArray = [NSMutableArray new];
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
    cell.lblStock.text = productObj.stock;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:productObj.product_thum]] ;
    
    
    cell.btn_AddToCart.tintColor = [CommonFunction colorWithHexString:COLORCODE];
    UIImage * image = [UIImage imageNamed:@"addButton"];
    [cell.btn_AddToCart setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [cell.btn_AddToCart addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_AddToCart.tag = indexPath.row;
    
    [cartItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([((CartItem *)obj).product_id isEqualToString:productObj.product_id]) {
            cell.btn_AddToCart.userInteractionEnabled = false;
            UIImage * image = [UIImage imageNamed:@"check_active"];
            [cell.btn_AddToCart setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        }
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
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

