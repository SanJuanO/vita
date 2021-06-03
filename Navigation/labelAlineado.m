//
//  labelAlineado.m
//  voluntariosapp
//
//  Created by Guillermo on 16/07/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "labelAlineado.h"

@implementation labelAlineado
- (void)drawTextInRect:(CGRect)rect
{
    CGSize sizeThatFits = [self sizeThatFits:rect.size];
    
    if (self.contentMode == UIViewContentModeTop) {
        rect.size.height = MIN(rect.size.height, sizeThatFits.height);
    }
    else if (self.contentMode == UIViewContentModeBottom) {
        rect.origin.y = MAX(0, rect.size.height - sizeThatFits.height);
        rect.size.height = MIN(rect.size.height, sizeThatFits.height);
    }
    
    [super drawTextInRect:rect];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
