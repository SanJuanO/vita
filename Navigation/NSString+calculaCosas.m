//
//  NSString+calculaCosas.m
//  clubfuturama
//
//  Created by Guillermo on 28/02/15.
//  Copyright (c) 2015 Guillermo. All rights reserved.
//

#import "NSString+calculaCosas.h"
#import <UIKit/UIKit.h>
@implementation NSString (calculaCosas)
-(NSString *)calculaFechaTexto
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *fecha=[df dateFromString:self];
    [df setDateFormat:@"dd MMM"];
    return [df stringFromDate:fecha];
    
    
}
-(NSString *)calculaElTiempo
{
    
    
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    long tzName = [timeZone secondsFromGMT];
    NSString *fecha;
    if(![self isEqualToString:@""])
    {
        NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [df setLocale:formatterLocale];
        int tiempoTranscurrido,minutos,horas,dias;
        
        tiempoTranscurrido = [[df dateFromString:[df stringFromDate:[NSDate date]]] timeIntervalSinceDate:[df dateFromString:self]]-tzName;
        
        minutos = floor(tiempoTranscurrido / 60.0f);
        horas = floor(tiempoTranscurrido / 3600.0f);
        dias = floor(tiempoTranscurrido / 86400.0f);
        
        if(minutos<=0) fecha = @"Hace menos de un minuto";
        else if(minutos==1) fecha = @"Hace un minuto";
        else if(minutos<60) fecha = [NSString stringWithFormat: @"Hace %d minutos",minutos];
        else if(horas==1) fecha = @"Hace una hora";
        else if(dias<1) fecha = [NSString stringWithFormat: @"Hace %d horas",horas];
        else if(dias==1) fecha = NSLocalizedString(@"Hace un dia", );
        else fecha = [NSString stringWithFormat: @"Hace %d días",dias];
    }
    return fecha;
    
}

-(int)calculaAltura:(int)ancho conFuente:(NSString *)fuente conTamano:(int)tamano
{
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.font = [UIFont fontWithName:fuente size:tamano];
    CGSize maximumLabelSize = CGSizeMake(ancho, 9999);
    CGSize expectedSize;
    
    gettingSizeLabel.text = self;
    gettingSizeLabel.numberOfLines = 0;
    
    expectedSize=[gettingSizeLabel sizeThatFits:maximumLabelSize];
    
    return expectedSize.height;
}

-(int)calculaAnchura:(int)alto conFuente:(NSString *)fuente conTamano:(int)tamano
{
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.font = [UIFont fontWithName:fuente size:tamano];
    CGSize maximumLabelSize = CGSizeMake(9999,alto);
    CGSize expectedSize;
    
    gettingSizeLabel.text = self;
    gettingSizeLabel.numberOfLines = 0;
    
    expectedSize=[gettingSizeLabel sizeThatFits:maximumLabelSize];
    return expectedSize.width;
}

@end
