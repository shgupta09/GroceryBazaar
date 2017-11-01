//
//  SubCategoriesViewController.m
//  Grocery Bazaar
//
//

#import "SubCategoriesViewController.h"

@interface SubCategoriesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    LoderView *loderObj;

}
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation SubCategoriesViewController

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
    [_tblView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil]forCellReuseIdentifier:@"CategoryTableViewCell"];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 100;
    _tblView.multipleTouchEnabled = NO;
    [_tblView reloadData];
    [CommonFunction setNavToController:self title:@"Address" isCrossBusston:false isAddRightButton:true];
}
#pragma mark - Api Related Methods
-(void)hitApiForAddressList{
//    if ([ CommonFunction reachability]) {
//        listArray = [NSMutableArray new];
//        
//        NSMutableDictionary *parameter = [NSMutableDictionary new];
//        
//        [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
//        
//        [self addLoder];
//        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
//        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_ADDRESS_LIST]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
//            if (error == nil) {
//                if ([[responseObj valueForKey:API_Status] integerValue] == 1){
//                    
//                    NSArray *tempAray = [responseObj valueForKey:@"addresses"];
//                    [tempAray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                        Address *addressObj = [Address new];
//                        addressObj.address_id= [obj valueForKey:@"address_id"];
//                        addressObj.address_line1= [obj valueForKey:@"address_line1"];
//                        addressObj.address_line2= [obj valueForKey:@"address_line2"];
//                        addressObj.city= [obj valueForKey:@"city"];
//                        addressObj.country= [obj valueForKey:@"country"];
//                        addressObj.pincode= [obj valueForKey:@"pincode"];
//                        addressObj.state= [obj valueForKey:@"state"];
//                        
//                        addressObj.landmark= [obj valueForKey:@"landmark"];
//                        [listArray addObject:addressObj];
//                    }];
//                    [_tbl_List reloadData];
//                    
//                }
//                else{
//                    _tbl_List.hidden = true;
//                    [CommonFunction addNoDataLabel:self.view];
//                }
//                [self removeloder];
//                
//            }
//            else {
//                [self removeloder];
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//                [alertController addAction:ok];
//                [self presentViewController:alertController animated:YES completion:nil];
//            }
//        }];
//    } else {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:ok];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
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
    
    if (_arrSubCategories.count>0) {
        _tblView.hidden = false;
    }else{
        _tblView.hidden = true;
    }
    return _arrSubCategories.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryTableViewCell *cell = [_tblView dequeueReusableCellWithIdentifier:@"CategoryTableViewCell"];
    SubCategory *obj = [_arrSubCategories objectAtIndex:indexPath.row];
    cell.lblHeading.text = obj.title;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:obj.subcat_icon]] ;
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductListViewController *obj = [[ProductListViewController alloc]initWithNibName:@"ProductListViewController" bundle:nil];
    obj.subCategory = [_arrSubCategories objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:obj animated:true];
}

@end
