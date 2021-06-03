//
//  selectorClase.h
//  cut
//
//  Created by Guillermo on 24/07/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "HMSegmentedControl.h"

@interface selectorClase : HMSegmentedControl
{
    UIColor *colortemp;
}
-(void)inicializa:(UIView *)contenedor conAltura:(long)altura;
-(void)inicializa2:(UIView *)contenedor conPosicion:(long)posicion conAltura:(long)altura
;
@end
