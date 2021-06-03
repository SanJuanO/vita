//
//  timelineCeldaAviso.m
//  centrovita
//
//  Created by Guillermo on 30/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaAviso.h"

@implementation timelineCeldaAviso

#import "color.h"
#import "globales.h"

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    self.aviso.font = [self.aviso.font fontWithSize:17*multiplicadorFuente];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
