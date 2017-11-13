//
//  CartApiHit.m
//  Grocery Bazaar
//
//  Created by shubham gupta on 11/10/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "CartApiHit.h"

@implementation CartApiHit
-(void)hitApiForCartItemscompletetion:(void (^)())completion {
    if ([ CommonFunction reachability]) {
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_CART_ITEMS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:API_Status] isEqualToString:isValidHitGB ]){
                    [CommonFunction stroeBoolValueForKey:isCartApiHIt withBoolValue:true];
                    NSArray *tempAray = [responseObj valueForKey:@"cart"];
                    [[CartItem sharedInstance].myDataArray removeAllObjects];
                    [tempAray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        CartItem* productObj = [[CartItem alloc] init  ];
                        [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                            [productObj setValue:[CommonFunction checkForNull:obj] forKey:(NSString *)key];
                        }];
                        productObj.stock = @"5";
                        [[CartItem sharedInstance].myDataArray addObject:productObj];
                    }];
                    completion();
                }
            }
            
        }];
    }
}

@end
