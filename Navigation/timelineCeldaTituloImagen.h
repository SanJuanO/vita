//
//  timelineCeldaTituloImagen.h
//  cut
//
//  Created by Guillermo on 17/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timelineCeldaTituloImagen : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UIImageView *imagen;
@property (weak, nonatomic) IBOutlet UILabel *intro;
@property (weak, nonatomic) IBOutlet UIView *vistaFecha;
@property (weak, nonatomic) IBOutlet UILabel *dia;
@property (weak, nonatomic) IBOutlet UILabel *mes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posicionTitulo;
@property (weak, nonatomic) IBOutlet UILabel *costo;
@property (weak, nonatomic) IBOutlet UIView *costoFonto;
@property (weak, nonatomic) IBOutlet UIView *vistaPrincipal;
@property (weak, nonatomic) IBOutlet UIView *vistaSecundaria;
@property (weak, nonatomic) IBOutlet UIView *linea;

@end
