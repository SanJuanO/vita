//
//  timelineGeneralFoto.m
//  cut
//
//  Created by Guillermo on 12/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "timelineGeneralFoto.h"

@implementation timelineGeneralFoto

#import "globales.h"
#import "color.h"

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoRenglon"] withAlpha:1.0]];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
