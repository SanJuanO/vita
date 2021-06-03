//
//  editarCatViewController.h
//  centrovita
//
//  Created by Guillermo on 01/02/17.
//  Copyright © 2017 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iwantooAPIConnection.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "botonSuperior.h"
@interface editarCatViewController : UIViewController<APIConnectionDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    NSString *nombreT,*textoT;
    iwantooAPIConnection *APIConnection;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player2;
    BOOL reproduciendo,audioGrabado;
    NSTimer *timerMemo;
    long cuentaTimer;
    id<NSObject> timeObserverToken;
    BOOL audioremoto;
}
@property (weak, nonatomic) IBOutlet UIView *vistaPrincipal;
@property (weak, nonatomic) IBOutlet botonSuperior *botonCancelar;
@property (weak, nonatomic) IBOutlet UILabel *grabarVoz;
@property (weak, nonatomic) IBOutlet UILabel *descripcion;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UITextField *nombre;
@property (weak, nonatomic) IBOutlet UITextView *texto;
@property (nonatomic, strong) NSMutableDictionary *diccionario;
@property (nonatomic) long pasoActual;
@property (nonatomic,strong) NSString *idreal,*ventanaActual;
-(void)cargaAudio:(NSString *)urlCargar;
@property (nonatomic,strong) AVPlayer *movieplayer;
@property (weak, nonatomic) IBOutlet UIView *vistaAudio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vistaAudioPosicion;
@property (weak, nonatomic) IBOutlet UIView *vistaGrabador;
@property (weak, nonatomic) IBOutlet UIButton *botonGrabar;
@property (weak, nonatomic) IBOutlet UIButton *botonReproducir;

@end



