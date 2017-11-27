//
//  MyOrderProducts.h
//  Grocery Bazaar
//
//  Created by Shagun Verma on 22/11/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderProducts : NSObject

@property (strong,nonatomic) NSString* order_number;
@property (strong,nonatomic) NSString* product_name;
@property (strong,nonatomic) NSString* after_discount_product_price;
@property (strong,nonatomic) NSString* product_quantity;
@property (strong,nonatomic) NSString* discount_amount;
@property (strong,nonatomic) NSString* product_price;


@end
