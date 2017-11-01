//
//  Address.h
//  Grocery Bazaar
//
//  Created by shubham gupta on 10/31/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject
@property (strong,nonatomic) NSString* address_id;
@property (strong,nonatomic) NSString* address_line1;
@property (strong,nonatomic) NSString* address_line2;
@property (strong,nonatomic) NSString* landmark;
@property (strong,nonatomic) NSString* pincode;
@property (strong,nonatomic) NSString* city;
@property (strong,nonatomic) NSString* state;
@property (strong,nonatomic) NSString* country;




@end
