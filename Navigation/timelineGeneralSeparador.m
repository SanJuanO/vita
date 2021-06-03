//
//  timelineGeneralSeparador.m
//  cut
//
//  Created by Guillermo on 11/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "timelineGeneralSeparador.h"

@implementation timelineGeneralSeparador
#import "color.h"
#import "globales.h"

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    [self.linea setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorLineas"] withAlpha:1.0]];
    // Initialization code
}

-(void)pintaFondo:(NSString *)color
{
    if([color isEqualToString:@""])
        [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    else
        [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:color] withAlpha:1.0]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
