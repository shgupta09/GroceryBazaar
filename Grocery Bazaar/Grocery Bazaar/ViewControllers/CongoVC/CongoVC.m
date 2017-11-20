//
//  CongoVC.m
//  Grocery Bazaar
//
//  Created by NetprophetsMAC on 11/20/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "CongoVC.h"

@interface CongoVC ()

@end

@implementation CongoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    // Do any additional setup after loading the view from its nib.
}
-(void)setData{
    _viewToClip.layer.cornerRadius = 5;
    _viewToClip.clipsToBounds = true;
    [CommonFunction setNavToController:self title:@"" isCrossBusston:true isAddRightButton:false];
}
#pragma mark -btn Actions
-(void)backTapped{
   [self setVC];
    
}
- (IBAction)btnAction_Continue:(id)sender {
    [self setVC];
}

-(void)setVC{
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[SWRevealViewController class]]) {
            [self.navigationController popToViewController:aViewController animated:NO];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
