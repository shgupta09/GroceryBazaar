//
//  ConformationVCViewController.m
//  Grocery Bazaar
//
//  Created by shubham gupta on 11/11/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "ConformationVCViewController.h"

@interface ConformationVCViewController (){
    LoderView *loderObj;
}

@end

@implementation ConformationVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setData];
    // Do any additional setup after loading the view from its nib.
}
-(void)setData{
    [CommonFunction setResignTapGestureToView:self.view andsender:self];
    [CommonFunction setNavToController:self title:[NSString stringWithFormat:@"Confirm Order"] isCrossBusston:false isAddRightButton:false];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -btnAction
-(void)backTapped{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark -other methods

-(void)resignResponder{
    [CommonFunction resignFirstResponderOfAView:self.view];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
