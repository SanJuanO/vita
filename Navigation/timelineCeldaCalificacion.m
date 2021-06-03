//
//  timelineCeldaCalificacion.m
//  micartelera
//
//  Created by Guillermo on 07/10/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaCalificacion.h"

@implementation timelineCeldaCalificacion
@synthesize stara0=_stara0;
@synthesize stara1=_stara1;
@synthesize stara2=_stara2;
@synthesize stara3=_stara3;
@synthesize stara4=_stara4;
#import "color.h"
#import "globales.h"


- (void)awakeFromNib {
    [self.stara0 setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.stara1 setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.stara2 setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.stara3 setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.stara4 setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoRenglon"] withAlpha:1.0]];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)pintaCalificacion:(NSString *)valorProceso
{
    long valor=[valorProceso integerValue];
    
    [self.stara0 setImage:[UIImage imageNamed:@"star0"]];
    [self.stara1 setImage:[UIImage imageNamed:@"star0"]];
    [self.stara2 setImage:[UIImage imageNamed:@"star0"]];
    [self.stara3 setImage:[UIImage imageNamed:@"star0"]];
    [self.stara4 setImage:[UIImage imageNamed:@"star0"]];
    
    if(valor>=1)
        [self.stara0 setImage:[UIImage imageNamed:@"star1"]];
    if(valor>=2)
        [self.stara1 setImage:[UIImage imageNamed:@"star1"]];
    if(valor>=3)
        [self.stara2 setImage:[UIImage imageNamed:@"star1"]];
    if(valor>=4)
        [self.stara3 setImage:[UIImage imageNamed:@"star1"]];
    if(valor>=5)
        [self.stara4 setImage:[UIImage imageNamed:@"star1"]];
}
- (IBAction)pinta1:(id)sender {
    [self.delegate califica:self.tag conCalificacion:@"1"];
    [self pintaCalificacion:@"1"];
}
- (IBAction)pinta2:(id)sender {
    [self.delegate califica:self.tag conCalificacion:@"2"];
    [self pintaCalificacion:@"2"];
}
- (IBAction)pinta3:(id)sender {
    [self.delegate califica:self.tag conCalificacion:@"3"];
    [self pintaCalificacion:@"3"];
}
- (IBAction)pinta4:(id)sender {
    [self.delegate califica:self.tag conCalificacion:@"4"];
    [self pintaCalificacion:@"4"];
}
- (IBAction)pinta5:(id)sender {
    [self.delegate califica:self.tag conCalificacion:@"5"];
    [self pintaCalificacion:@"5"];
}
@end
