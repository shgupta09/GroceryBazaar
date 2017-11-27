//
//  MyOrder.h
//  Grocery Bazaar
//
//  Created by Shagun Verma on 22/11/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrder : NSObject

@property (strong,nonatomic) NSString* order_id;
@property (strong,nonatomic) NSString* order_number;
@property (strong,nonatomic) NSString* payment_type;
@property (strong,nonatomic) NSString* offer_code;
@property (strong,nonatomic) NSString* order_date;
@property(nonatomic, strong) NSMutableArray *shipping_address;
@property(nonatomic, strong) NSMutableArray *order_products;

@end
