//
//  usuariosHerramientas.h
//  kiwilimontest
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 24/05/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#ifndef kiwilimontest_usuariosHerramientas_h
#define kiwilimontest_usuariosHerramientas_h
-(BOOL)validaFirmado
{
    if(![tokenFirmado isEqualToString:@""])
        return true;
    else
    {
        [self firmarUsuario];
        return false;
    }
}

// esto ira en un delegate
-(void)firmarUsuario
{
    NSLog(@"firmate ya");
}

#endif
