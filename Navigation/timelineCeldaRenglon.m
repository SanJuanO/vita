//
//  timelineCeldaRenglon.m
//  micartelera
//
//  Created by Guillermo on 05/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaRenglon.h"

@implementation timelineCeldaRenglon
@synthesize texto=_texto;
#import "globales.h"
#import "color.h"

- (void)awakeFromNib {
    [self pintaNormal];
    // Initialization code
}

-(void)pintaNormal
{
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoRenglon"] withAlpha:1]];
    [self.texto setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTexto"] withAlpha:1.0]];
    self.texto.font = [self.texto.font fontWithSize:14*multiplicadorFuente];

    
}

-(void)pintaInvertido
{
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoRenglon"] withAlpha:1]];
    [self.texto setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTexto"] withAlpha:1.0]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
