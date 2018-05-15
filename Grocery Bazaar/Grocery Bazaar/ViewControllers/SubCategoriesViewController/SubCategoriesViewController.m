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
//     [CommonFunction addNoDataLabel:self.view];
    [CommonFunction setViewBackground:self.view withImage:[UIImage imageNamed:@"BackgroundGeneral.png"]];
}

-(void)cartBtnAction{
    CartVCViewController* vc = [[CartVCViewController alloc ] initWithNibName:@"CartVCViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:true];
}

-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    if (_arrSubCategories.count==0) {
        [CommonFunction addNoDataLabel:self.view];
    }
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
    [CommonFunction setNavToController:self title:_catObj.name isCrossBusston:false isAddRightButton:true rightImageName:@"Cart"];
}
#pragma mark - Api Related Methods
-(void)hitApiForAddressList{

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
    [loderObj removeFromSuperview];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arrSubCategories.count>0) {
        _tblView.hidden = false;
    }else{
        _tblView.hidden = true;
    }
    return _arrSubCategories.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryTableViewCell *cell = [_tblView dequeueReusableCellWithIdentifier:@"CategoryTableViewCell"];
    cell.viewToClip.layer.cornerRadius = 10;
    cell.viewToClip.clipsToBounds = true;
    SubCategory *obj = [_arrSubCategories objectAtIndex:indexPath.row];
    cell.lblHeading.text = obj.title;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:obj.subcat_icon]] ;
    cell.imgView.layer.cornerRadius = 10;
    cell.imgView.layer.borderWidth = 1.0;
    cell.imgView.layer.borderColor = [CommonFunction colorWithHexString:primary_Button_Color].CGColor;
    cell.imgView.clipsToBounds = true;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductListViewController *obj = [[ProductListViewController alloc]initWithNibName:@"ProductListViewController" bundle:nil];
    obj.subCategory = [_arrSubCategories objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:obj animated:true];
}

@end
