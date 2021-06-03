//
//  NSString+calculaTiempo.m
//  drinking
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 06/06/14.
//  Copyright (c) 2014 Imagen Central. All rights reserved.
//

#import "NSString+calculaTiempo.h"

@implementation NSString (calculaTiempo)

-(NSString *)calculaElTiempo
{
    
   // NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    //long tzName = [timeZone secondsFromGMT];
    NSString *fecha;
    if(![self isEqualToString:@""])
    {
        NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [df setLocale:formatterLocale];
        int tiempoTranscurrido,minutos,horas,dias;
        
        tiempoTranscurrido = [[df dateFromString:[df stringFromDate:[NSDate date]]] timeIntervalSinceDate:[df dateFromString:self]];
        
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



-(NSString *)calculaElTiempoTimestamp
{
    NSDate *now = [[NSDate alloc] init];
    float segundosTranscurridos = [now timeIntervalSince1970]-1;
    float diferencia = (segundosTranscurridos-[self floatValue]/1000);
    int minutos,horas,dias;
    
    minutos = floor(diferencia / 60);
    horas = floor(diferencia / 3600);
    dias = floor(diferencia / 86400);
    
    
    NSString *devuelve = @"";
    if(minutos<0) devuelve = @"Hace menos de un minuto";
    else if(minutos==1) devuelve = @"Hace un minuto";
    else if(minutos<60) devuelve = [NSString stringWithFormat: @"Hace %d minutos",minutos];
    else if(horas==1) devuelve = @"Hace una hora";
    else if(dias<1) devuelve = [NSString stringWithFormat: @"Hace %d horas",horas];
    else if(dias==1) devuelve = @"Hace un día";
    else devuelve = [NSString stringWithFormat: @"Hace %d días",dias];
    return devuelve;
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
