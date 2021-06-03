//
//  noticiasViewController.h
//  cut
//
//  Created by Guillermo on 26/07/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "baseVentanaViewController.h"
#import <UIKit/UIKit.h>
#import "timeline.h"


@interface noticiasViewController : baseVentanaViewController<timelineProtocol,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet headerPrincipal *headerPrincipal;
@property (weak, nonatomic) IBOutlet UIView *contenedorSelector;
@property (weak, nonatomic) IBOutlet timeline *timeline;
@property (weak, nonatomic) IBOutlet timeline *timelineBuscador;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timelineDistancia;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contenedorSelectorAltura;
@property (weak, nonatomic) IBOutlet UIView *vistaBuscador;
@property (weak, nonatomic) IBOutlet UITextField *textoBuscador;
-(void)detieneAudio:(BOOL)cerrar;
@end
