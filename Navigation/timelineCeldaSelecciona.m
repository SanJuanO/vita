//
//  timelineCeldaSelecciona.m
//  cut
//
//  Created by Guillermo on 15/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaSelecciona.h"
#import <QuartzCore/QuartzCore.h>
#import <sqlite3.h>
@implementation timelineCeldaSelecciona
#import "color.h"
#import "databaseOperations.h"
#import "globales.h"

- (void)awakeFromNib {
    [self setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    //[self.titulo setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
    //[self.subtitulo setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorSubtitulo"] withAlpha:1.0]];
    [self.linea setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorLineas"] withAlpha:1.0]];
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoRenglon"] withAlpha:1.0]];

    self.titulo.font = [self.titulo.font fontWithSize:14*multiplicadorFuente];
    self.subtitulo.font = [self.subtitulo.font fontWithSize:12*multiplicadorFuente];
    
    self.imagen2.layer.cornerRadius=18;
     self.imagen2.clipsToBounds=true;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
