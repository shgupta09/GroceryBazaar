//
//  CartItem.h
//  Grocery Bazaar
//
//  Created by shubham gupta on 11/8/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartItem : NSObject
@property (strong,nonatomic) NSString* product_cart_id;
@property (strong,nonatomic) NSString* product_id;
@property (strong,nonatomic) NSString* product_name;
@property (strong,nonatomic) NSString* product_price;
@property (strong,nonatomic) NSString* product_image;
@property (strong,nonatomic) NSString* quantity;
@property (strong,nonatomic) NSString* created_at;
@property (strong,nonatomic) NSString* stock;
@property (strong,nonatomic) NSString* price;
@property (strong,nonatomic) NSString* weight;

@property (strong,nonatomic) NSString*product_variant_id;
@property(nonatomic, strong) NSMutableArray *myDataArray;



-(NSMutableArray*) myDataArray;
+(CartItem*) sharedInstance;

@end
