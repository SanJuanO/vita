//
//  timelineCeldaBotones.m
//  micartelera
//
//  Created by Guillermo on 06/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaBotones.h"

@implementation timelineCeldaBotones
@synthesize linea=_linea;
@synthesize botonTelefono1=_botonTelefono1;
@synthesize botonTelefono2=_botonTelefono2;
@synthesize delegate=_delegate;

#import "globales.h"
#import "color.h"

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo2"] withAlpha:1.0]];
    [self.linea setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorLineas"] withAlpha:1.0]];
    
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)pintaBotones
{
    self.botonTelefono2.enabled=false;
    self.botonTelefono1.enabled=false;
    telefono1=[self getStringJSON:self.diccionario withKey:@"telefono1" widthDefValue:@""];
    telefono2=[self getStringJSON:self.diccionario withKey:@"telefono2" widthDefValue:@""];
    if(![telefono1 isEqualToString:@""]) self.botonTelefono1.enabled=true;
    if(![telefono2 isEqualToString:@""]) self.botonTelefono2.enabled=true;
    
}

-(NSString *)getStringJSON:(id)dictionary withKey:(NSString *)key widthDefValue:(NSString *)defValue
{
    NSString *newString=@"";
    @try {
        newString  = [dictionary objectForKey:key];
    }
    @catch (NSException *exception) {
        newString = defValue;
    }
    @finally {
        if(newString==NULL || [newString isEqual: [NSNull null]] || newString==nil)
            newString = defValue;
    }
    newString=[NSString stringWithFormat:@"%@",newString];
    return newString;
}
- (IBAction)tel1:(id)sender {
    [self.delegate abreBotones:telefono1 conModo:@"telefono"];
}
- (IBAction)tel2:(id)sender {
    [self.delegate abreBotones:telefono2 conModo:@"telefono"];
}

@end
