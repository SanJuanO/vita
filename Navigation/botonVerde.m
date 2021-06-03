//
//  botonVerde.m
//  kiwilimon
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 18/05/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "botonVerde.h"
#import <QuartzCore/QuartzCore.h>

@implementation botonVerde
#import "color.h"
#import "globales.h"

-(void)awakeFromNib
{
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    [self setBackgroundColor:[self colorDesdeString:cBase withAlpha:1.0]];
    [self setTitleColor:[self colorDesdeString:@"#FFFFFF" withAlpha:1.0] forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
