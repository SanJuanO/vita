//
//  timelineCeldaSubtitulo.m
//  centrovita
//
//  Created by Guillermo on 09/06/17.
//  Copyright © 2017 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaSubtitulo.h"

@implementation timelineCeldaSubtitulo
#import "globales.h"
#import "color.h"
- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    [self.subtitulo setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
    

    
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
