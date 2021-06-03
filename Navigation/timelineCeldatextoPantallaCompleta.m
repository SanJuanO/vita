//
//  timelineCeldatextoPantallaCompleta.m
//  centrovita
//
//  Created by Laura Fernández on 05/03/16.
//  Copyright © 2016 Tammy L Coron. All rights reserved.
//

#import "timelineCeldatextoPantallaCompleta.h"

@implementation timelineCeldatextoPantallaCompleta
#import "globales.h"
#import "color.h"
- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo1"] withAlpha:1.0]];
    [self.texto setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorPantallaCompleta"] withAlpha:1.0]];
    self.texto.font = [self.texto.font fontWithSize:50*multiplicadorFuente];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
