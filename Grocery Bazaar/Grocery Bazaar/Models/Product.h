//
//  Product.h
//  Grocery Bazaar
//
//  Created by Shagun Verma on 01/11/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (strong,nonatomic) NSString* product_id;
@property (strong,nonatomic) NSString* cat_id;
@property (strong,nonatomic) NSString* subcat_id;
@property (strong,nonatomic) NSString* product_name;
@property (strong,nonatomic) NSString* product_thum;
@property (strong,nonatomic) NSString* product_image;
@property (strong,nonatomic) NSString* product_short_desc;
@property (strong,nonatomic) NSString* product_long_desc;
@property (strong,nonatomic) NSString* product_price;
@property (strong,nonatomic) NSString* brand_name;
@property (strong,nonatomic) NSString* stock;
@property (strong,nonatomic) NSString* publish_time;
@property (strong,nonatomic) NSString* offer_code;
@property (strong,nonatomic) NSString* selectedQuantity;
@property (strong,nonatomic) NSString* weight;
@property (strong,nonatomic) NSString* price;
@property (strong,nonatomic) NSString* variant_id;
@end
