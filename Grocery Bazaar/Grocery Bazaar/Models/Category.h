//
//  Category.h
//  Grocery Bazaar
//
//

#import <Foundation/Foundation.h>

@interface Category : NSObject

@property (strong,nonatomic) NSString* cat_id;
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSString* category_icon;
@property (strong,nonatomic) NSMutableArray* subcategories;


@end
