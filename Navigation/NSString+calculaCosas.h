//
//  NSString+calculaCosas.h
//  clubfuturama
//
//  Created by Guillermo on 28/02/15.
//  Copyright (c) 2015 Guillermo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (calculaCosas)
-(NSString *)calculaElTiempo;
-(int)calculaAltura:(int)ancho conFuente:(NSString *)fuente conTamano:(int)tamano;
-(int)calculaAnchura:(int)alto conFuente:(NSString *)fuente conTamano:(int)tamano;
-(NSString *)calculaFechaTexto;
@end
