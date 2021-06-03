//
//  calificador.h
//  kiwilimon
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 17/05/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface calificador : UIView
{
    BOOL activoInterno;
}
@property (weak, nonatomic) IBOutlet UIButton *estrella1;
@property (weak, nonatomic) IBOutlet UIButton *estrella2;
@property (weak, nonatomic) IBOutlet UIButton *estrella3;
@property (weak, nonatomic) IBOutlet UIButton *estrella4;
@property (weak, nonatomic) IBOutlet UIButton *estrella5;

@property (nonatomic,strong) IBOutlet UIView *view;
-(void)califica:(int)calificacion conActivo:(BOOL)activo;
@end
