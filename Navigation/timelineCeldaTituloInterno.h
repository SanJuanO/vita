//
//  timelineCeldaTituloInterno.h
//  centrovita
//
//  Created by Guillermo on 26/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timelineCeldaTituloInterno : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UIView *vistaFecha;
@property (weak, nonatomic) IBOutlet UILabel *dia;
@property (weak, nonatomic) IBOutlet UILabel *mes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posicionTitulo;
@property (weak, nonatomic) IBOutlet UIView *vistaPrincipal;

@end
