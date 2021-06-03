//
//  noticiaDetalleViewController.h
//  cut
//
//  Created by Guillermo on 26/07/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "baseVentanaViewController.h"
#import "baseVentanaViewController.h"
#import <UIKit/UIKit.h>
#import "timeline.h"
#import "barraSocial.h"

@interface noticiaDetalleViewController : baseVentanaViewController<timelineProtocol,barraSocialProtocol>


@property (weak, nonatomic) IBOutlet headerPrincipal *headerPrincipal;
@property (weak, nonatomic) IBOutlet timeline *timeline;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timelineDistancia;
@property (weak, nonatomic) IBOutlet barraSocial *barraSocial;
-(void)detieneAudio:(BOOL)cerrar;
@end
