//
//  barraSocial.h
//  cut
//
//  Created by Guillermo on 06/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "iwantooAPIConnection.h"

@protocol barraSocialProtocol <NSObject>

@optional
-(void)compartirBoton;
-(void)abreFirma;
-(void)abreVentanacomentarios:(NSString *)idregistro conTabla:(NSString *)tabla conModo:(NSString *)modo conRow:(long)row;
-(void)subirFoto;
-(void)subirVideo;
@end

@interface barraSocial : UIView<APIConnectionDelegate>
{
    iwantooAPIConnection *APIConnection;
    id<barraSocialProtocol> delegate;
    NSString *modoInterno;
    NSString *channelActual;
    NSString *idrealInterno;
    long totalGusta;
    long totalComentarios;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *izquierdaGusta;
@property (nonatomic,strong) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *botonNotificacion;
@property (weak, nonatomic) IBOutlet UIButton *botonGusta;
@property (weak, nonatomic) IBOutlet UIButton *botonComentario;
@property (weak, nonatomic) IBOutlet UIButton *botonCompartir;
@property (weak, nonatomic) IBOutlet UIButton *botonfoto;
@property (weak, nonatomic) IBOutlet UIButton *botonvideo;

@property (nonatomic,assign) id<barraSocialProtocol> delegate;
-(void)inicializa:(NSString *)modo conIdreal:(NSString *)idreal conTgusta:(NSString *)tgusta conTcomentarios:(NSString *)tcomentarios conMegusta:(NSString *)meGusta;

@property (weak, nonatomic) IBOutlet UIView *cuadroGusta;
@property (weak, nonatomic) IBOutlet UILabel *textoGusta;
@property (weak, nonatomic) IBOutlet UIView *cuadroComentarios;
@property (weak, nonatomic) IBOutlet UILabel *textoComentarios;
-(void)actualizaComentarios:(long)comentarios;
@end