//
//  HomeViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
     SWRevealViewController *revealController;
     BOOL isOpen;
     UIView *tempView;
    UITapGestureRecognizer *singleFingerTap;
    __weak IBOutlet UIScrollView *scrlViewOffers;
    __weak IBOutlet UICollectionView *collectionView;
    __weak IBOutlet UIPageControl *pageControl;
    LoderView *loderObj;
    NSMutableArray* arrCategories;

}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _btn_Home.tintColor = [CommonFunction colorWithHexString:COLORCODE];
    UIImage * image = [UIImage imageNamed:@"Icon---Menu"];
    [_btn_Home setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
   
     isOpen = false;
    revealController = [self revealViewController];
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleSingleTap:)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification)
                                                 name:@"LogoutNotification"
                                               object:nil];
    [collectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCollectionViewCell"];

    arrCategories = [[NSMutableArray alloc] init];
    
    [self hitApiForCategories];
    
    
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    self.navigationController.navigationBar.hidden = true;
     isOpen = false;
}

-(void) viewDidAppear:(BOOL)animated{
    [self setOffersView];

}

-(void) setOffersView{


    int noOfPages = 5;
    
    for (int i = 0; i<5; i++){
        
        OfferView* ofrView = [[OfferView alloc] initWithFrame:CGRectMake((i*self.view.bounds.size.width), 10, scrlViewOffers.frame.size.width, scrlViewOffers.frame.size.height-20)];
        Offer* offer = [[Offer alloc] init] ;
                        
        offer.offerName = [NSString stringWithFormat:@"Offer No. %d tapped",i ];
        ofrView.offerDetails = offer;
        [ofrView.offerImageView sd_setImageWithURL:[NSURL URLWithString:@"https://static.pexels.com/photos/248797/pexels-photo-248797.jpeg"]] ;
        [scrlViewOffers addSubview:ofrView];

        
    }
    
    [scrlViewOffers setContentSize:CGSizeMake((noOfPages*self.view.bounds.size.width) , scrlViewOffers.frame.size.height)];
    
    
}


//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    self.navigationController.navigationBar.userInteractionEnabled = true;
    if (isOpen){
        [revealController revealToggle:nil];
        [tempView removeGestureRecognizer:singleFingerTap];
        [tempView removeFromSuperview];
        isOpen = false;
    }
    
}

#pragma mark- SWRevealViewController

- (IBAction)revealAction:(id)sender {
    //    self.view.userInteractionEnabled = false;
    self.navigationController.navigationBar.userInteractionEnabled = true;
    
    
    if (isOpen) {
        
        [revealController revealToggle:nil];
        
        [tempView removeGestureRecognizer:singleFingerTap];
        [tempView removeFromSuperview];
        isOpen = false;
    }
    else{
        
        [revealController revealToggle:nil];
        tempView.frame  =CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
        [tempView addGestureRecognizer:singleFingerTap];
        [self.view addSubview:tempView];
        isOpen = true;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveNotification{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Logout Successfully" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [CommonFunction stroeBoolValueForKey:isLoggedIn withBoolValue:false];
                LoginViewController* vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                [self presentViewController:vc animated:YES completion:nil];
            }];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    int noOfPages = 5;
    float fraction = scrlViewOffers.contentOffset.x/scrlViewOffers.frame.size.width;
    pageControl.currentPage = roundf(fraction);
    
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return arrCategories.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryCollectionViewCell *cell = (CategoryCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionViewCell" forIndexPath:indexPath];
//    [cell setFrame:CGRectMake(0, 0, 200, 2000)];
//    cell.contentView.layer.cornerRadius = cell.frame.size.height/2;
//    cell.contentView.layer.masksToBounds = true;
    
    Category* obj = [[Category alloc] init];
    obj = [arrCategories objectAtIndex:indexPath.row];
    
    CAShapeLayer* layering = [CAShapeLayer layer];
    [layering setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, cell.frame.size.width-20, cell.frame.size.height-20)] CGPath ]];

    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:obj.category_icon]];
    cell.lblName.text = obj.name;
    
//    [[cell.contentView layer] addSublayer:layering];
//    [[cell.contentView layer] setMask:layering];

    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.0 ; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    
    return size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SubCategoriesViewController* vc = [[SubCategoriesViewController alloc ] initWithNibName:@"SubCategoriesViewController" bundle:nil];
    
    vc.arrSubCategories = [[arrCategories objectAtIndex:indexPath.row] subcategories];
    vc.catObj = [arrCategories objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:true];
    
    
    
}

#pragma mark - Api Related Methods
-(void)hitApiForCategories{
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
               //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_CATEGORIES]  postResponse:nil postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
                    
                    NSArray *tempAray = [responseObj valueForKey:@"categories"];
                    [tempAray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        Category *categoryObj = [Category new];
                        
                        [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            [categoryObj setValue:obj forKey:key];
                        }];
                        
                        
                        NSArray *subAray = [obj valueForKey:@"subcategories"];
                        categoryObj.subcategories = [NSMutableArray new];
                        [subAray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            SubCategory *subobj = [SubCategory new];
                            
                            [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                                [subobj setValue:obj forKey:key];
                            }];
                           
                            subobj.catId = categoryObj.cat_id;
                            [categoryObj.subcategories addObject:subobj];
                        }];
                        
                        [arrCategories addObject:categoryObj];
                    }];
                    if (arrCategories.count== 0) {
                        collectionView.hidden = true;
                        [CommonFunction addNoDataLabel:self.view];
                    }else{
                    [collectionView reloadData];
                    }
                    
                    
                    
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




@end
