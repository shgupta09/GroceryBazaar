//
//  OfferView.h
//  Grocery Bazaar
//
//  Created by Shagun Verma on 26/10/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface OfferView : UIView

@property (strong,nonatomic) UIImageView* offerImageView;
@property (strong,nonatomic) Offer* offerDetails;


@end
