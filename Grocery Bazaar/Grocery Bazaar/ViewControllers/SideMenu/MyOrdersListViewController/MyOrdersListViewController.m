//
//  MyOrdersListViewController.m
//  Grocery Bazaar
//
//  Created by Shagun Verma on 22/11/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "MyOrdersListViewController.h"


@interface MyOrdersListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrMyOrders;
    LoderView *loderObj;
}


@end

@implementation MyOrdersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -btnAction
-(void)backTapped{
    [self.navigationController popViewControllerAnimated:true];
}


-(void)setData{
    [_tblView registerNib:[UINib nibWithNibName:@"MyOrdersTableViewCell" bundle:nil]forCellReuseIdentifier:@"MyOrdersTableViewCell"];
    
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 100;
    
    [CommonFunction setNavToController:self title:[NSString stringWithFormat:@"My Orders"] isCrossBusston:false isAddRightButton:false];
    arrMyOrders = [NSMutableArray new];
    [self hitApiForMyOrders];
    
}

#pragma mark - Api Related Methods
-(void)hitApiForMyOrders{
    if ([ CommonFunction reachability]) {
        arrMyOrders = [NSMutableArray new];
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
        
        [self addLoder];
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_MY_ORDERS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
                    
                    NSArray *tempAray = [responseObj valueForKey:@"order"];
                    [tempAray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        MyOrder *orderObj = [MyOrder new];
                        
                        [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            [orderObj setValue:obj forKey:key];
                        }];
                        
                        
                        NSArray *subAray = [obj valueForKey:@"order_products"];
                        orderObj.order_products = [NSMutableArray new];
                        [subAray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            MyOrderProducts *orderProduct = [MyOrderProducts new];
                            
                            [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                                [orderProduct setValue:obj forKey:key];
                            }];
                            
                            [orderObj.order_products addObject:orderProduct];
                        }];
                        
                        NSArray *shippingarr = [obj valueForKey:@"shipping_address"];
                        orderObj.shipping_address = [NSMutableArray new];
                        [shippingarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            Address *addressObj = [Address new];
                            
                            [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                                [addressObj setValue:obj forKey:key];
                            }];
                            
                            [orderObj.shipping_address addObject:addressObj];
                        }];

                        
                        [arrMyOrders addObject:orderObj];
                    }];
                    
                    
                    if (arrMyOrders.count== 0) {
                        _tblView.hidden = true;
                        [CommonFunction addNoDataLabel:self.view];
                    }else{
                        [_tblView reloadData];
                    }
                    
                }
                else
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
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


#pragma mark- Table Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (arrMyOrders.count>0) {
        _tblView.hidden = false;
    }else{
        _tblView.hidden = true;
    }
    return arrMyOrders.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrdersTableViewCell *cell = [_tblView dequeueReusableCellWithIdentifier:@"MyOrdersTableViewCell"];
    MyOrder *obj = [arrMyOrders objectAtIndex:indexPath.row];
//    cell.lblStatus.text = obj.order_id;
    cell.lblOrderId.text = [NSString stringWithFormat:@"Order Id: %@",obj.order_id];
    cell.lblOrderNo.text = [NSString stringWithFormat:@"Order No: %@",obj.order_number];
    cell.lblPlaceDate.text = [NSString stringWithFormat:@"Placed on %@",[CommonFunction convertStringToDate:obj.order_date] ];
//    cell.viewToClip.layer.cornerRadius = 10;
//    cityCell.viewToClip.clipsToBounds = true;
    UIImage *image = [UIImage imageNamed:@"edit"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MyOrderDetailsViewController *confirmObj = [[MyOrderDetailsViewController alloc]initWithNibName:@"MyOrderDetailsViewController" bundle:nil];
        confirmObj.orderObj = [arrMyOrders objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:confirmObj animated:true];
    
    
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


@end
