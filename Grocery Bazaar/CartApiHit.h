//
//  CartApiHit.h
//  Grocery Bazaar
//
//  Created by shubham gupta on 11/10/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartApiHit : NSObject
-(void)hitApiForCartItemscompletetion:(void (^)())completion;
@end
