//
//  OfferView.m
//  Grocery Bazaar
//
//  Created by Shagun Verma on 26/10/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "OfferView.h"
@implementation OfferView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
  
    if (self) {
        // Initialization code

        _offerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, frame.size.height-20)];
        _offerImageView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [self addSubview:_offerImageView];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OfferTapped)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

-(void) OfferTapped{
    
    NSLog(@"%@", _offerDetails.offerName);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
}
*/

@end
