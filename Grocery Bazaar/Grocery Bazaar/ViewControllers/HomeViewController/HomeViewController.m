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
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     isOpen = false;
    revealController = [self revealViewController];
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleSingleTap:)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification)
                                                 name:@"LogoutNotification"
                                               object:nil];
    [collectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCollectionViewCell"];

    
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
    
    return 10;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryCollectionViewCell *cell = (CategoryCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionViewCell" forIndexPath:indexPath];
//    [cell setFrame:CGRectMake(0, 0, 200, 2000)];
//    cell.contentView.layer.cornerRadius = cell.frame.size.height/2;
//    cell.contentView.layer.masksToBounds = true;
    
    CAShapeLayer* layering = [CAShapeLayer layer];
    [layering setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, cell.frame.size.width-20, cell.frame.size.height-20)] CGPath ]];

    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:@"http://dataheadstudio.com/bazar/assets/uploads/product_subcategory/e8364-atta.jpg"]];
    
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


@end
