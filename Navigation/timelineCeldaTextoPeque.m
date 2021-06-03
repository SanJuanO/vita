//
//  timelineCeldaTextoPeque.m
//  cut
//
//  Created by Guillermo on 26/07/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaTextoPeque.h"

@implementation timelineCeldaTextoPeque

#import "globales.h"
#import "color.h"

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    [self.texto setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
    self.texto.font = [self.texto.font fontWithSize:12*multiplicadorFuente];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
