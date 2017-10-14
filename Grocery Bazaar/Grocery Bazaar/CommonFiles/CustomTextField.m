//
//  CustomTextField.m
//  ShreeAirlines
//
//  Created by NetprophetsMAC on 4/19/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        self.delegate = self;
        self.tintColor = [CommonFunction colorWithHexString:Primary_Text_Color];
//        self.layer.cornerRadius = self.bounds.size.height/2;
        self.clipsToBounds = YES;
       self.leftViewMode = UITextFieldViewModeAlways;
        CALayer* lowerLayer = [CALayer layer];
        lowerLayer.frame = CGRectMake(0,40,self.frame.size.width,2);
        lowerLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
//        lowerLayer.borderWidth = 2;
        [self.layer addSublayer:lowerLayer];
        self.layer.masksToBounds = true;
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        self.textColor = [CommonFunction colorWithHexString:primary_Button_Color];
        [self reloadInputViews];
        //        self.backgroundColor = [CommonFunction colorWithHexString:@"#00b1dd"];

        
    }
    return self;
}



@end
