//
//  NSString+calculaTiempo.h
//  drinking
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 06/06/14.
//  Copyright (c) 2014 Imagen Central. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (calculaTiempo)
-(NSString *)calculaElTiempo;
-(NSString *)calculaElTiempoTimestamp;
-(int)calculaAltura:(int)ancho conFuente:(NSString *)fuente conTamano:(int)tamano;
-(int)calculaAnchura:(int)alto conFuente:(NSString *)fuente conTamano:(int)tamano;
@end
