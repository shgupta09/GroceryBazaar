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
    [CommonFunction setNavToController:self title:@"Address" isCrossBusston:false isAddRightButton:false];
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
                    if ([[responseObj valueForKey:API_Status] integerValue] == 1){
    
                        NSArray *tempAray = [responseObj valueForKey:@"product"];
                        [tempAray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            Product* c = [[Product alloc] init  ];
                            
                            [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                                [c setValue:obj forKey:(NSString *)key];
                            }];
                            
                            [arrProducts addObject:c];
                        }];
                        [_tblView reloadData];
                        if([[responseObj valueForKey:@"message"] isEqualToString:@"Product not found"]){
                            _tblView.hidden = true;
                            [CommonFunction addNoDataLabel:self.view];
                        }
                    }
                    else{
                        _tblView.hidden = true;
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
    Product *obj = [arrProducts objectAtIndex:indexPath.row];
    cell.lblHeading.text = obj.product_name;
    cell.lblPrice.text = obj.product_price;
    cell.lblStock.text = obj.stock;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:obj.product_thum]] ;
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    SubCategory *obj = [[AddressVC alloc]initWithNibName:@"AddressVC" bundle:nil];
    //    addressVCObj.isFromList = true;
    //    addressVCObj.addressObj = [listArray objectAtIndex:indexPath.row];
    //    [self.navigationController pushViewController:addressVCObj animated:true];
}



@end

