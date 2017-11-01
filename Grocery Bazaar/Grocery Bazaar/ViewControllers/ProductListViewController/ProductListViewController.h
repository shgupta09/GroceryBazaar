//
//  ProductListViewController.h
//  Grocery Bazaar
//
//

#import <UIKit/UIKit.h>

@interface ProductListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong,nonatomic) SubCategory* subCategory;
@end
