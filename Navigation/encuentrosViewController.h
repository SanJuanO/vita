//
//  encuentrosViewController.h
//  centrovita
//
//  Created by Guillermo on 22/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import "baseVentanaViewController.h"
#import <UIKit/UIKit.h>
#import "timeline.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface encuentrosViewController : baseVentanaViewController<timelineProtocol>
{
    BOOL primeraVez,cargarInfinite;
    long posicionTimeline;
    long pasos;
    long seleccionMaximo,seleccionMinimo;
    BOOL editando;
    BOOL yacargado;
    long distancia;
    NSTimer *timerX;
    NSString *enCalendario,*ventanaActualCalendario;
    NSDictionary *diccionarioCalendario;
    BOOL operaEncuentro;
}
@property (weak, nonatomic) IBOutlet timeline *timeline;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timelineDistancia;
@property (nonatomic) long pasoActual;

@property (nonatomic,strong) IBOutlet UIView *vistaHeader;
@property (weak, nonatomic) IBOutlet UIButton *botonAnterior;
@property (weak, nonatomic) IBOutlet UIButton *botonSiguiente;
@property (weak, nonatomic) IBOutlet UILabel *tituloPrincipal;
-(void)detieneAudio:(BOOL)cerrar;
@property (nonatomic,strong) NSString *audioArchivo;

@end

