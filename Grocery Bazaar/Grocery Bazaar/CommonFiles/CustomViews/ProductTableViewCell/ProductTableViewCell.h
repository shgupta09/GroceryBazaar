//
//  ProductTableViewCell.h
//  Grocery Bazaar
//
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblStock;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblHeading;
@property (weak, nonatomic) IBOutlet UIButton *btn_AddToCart;

@end
