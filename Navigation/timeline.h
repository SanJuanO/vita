//
//  timeline.h
//  cut
//
//  Created by Guillermo on 24/07/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "timelineCeldaNoticia.h"
#import "timelineCeldaTitulo.h"
#import "timelineCeldaTituloImagen.h"
#import "timelineCeldaTexto.h"
#import "timelineCeldaTextoSeleccion.h"
#import "timelineCeldaBoton.h"
#import "timelineCeldaGaleria.h"
#import "timelineCeldaTextoPeque.h"
#import "timelineGeneralSeparador.h"
#import "timelineGeneralFoto.h"
#import "timelineCeldaSelecciona.h"
#import "timelineCeldaRenglon.h"
#import "timelineCeldaBotones.h"
#import "timelineCeldaMapa.h"
#import "timelineCeldaTituloInterno.h"
#import "timelineCeldaAudio.h"
#import "timelineCeldaAviso.h"
#import "timelineCeldaCalificacion.h"
#import "timelineCeldaConc.h"
#import "timelineCeldaPag.h"
#import "timelineCeldatextoPantallaCompleta.h"
#import "timelineCeldaCita.h"
#import "timelineCeldaSubtitulo.h"

#import "iwantooAPIConnection.h"
#import <MediaPlayer/MediaPlayer.h>

@protocol timelineProtocol <NSObject>
@optional
-(void)abreVentana:(NSString *)tipo conDiccionario:(NSDictionary *)diccionario conIDreal:(NSString *)idreal;
-(void)abreVentanaNavigation:(NSString *)cual conDiccionario:(NSDictionary *)diccionario;
-(void)abrePerfil:(long)cual conDiccionario:(NSDictionary *)diccionario;
-(void)ocultaTeclado;
-(void)abreVentanacomentarios:(NSString *)idregistro conTabla:(NSString *)tabla conModo:(NSString *)modo conRow:(long)row;
-(void)compartirDesdeTimeLine:(NSString *)URL;
-(void)abreFirma;
-(void)actualizaSeleccion:(NSMutableDictionary *)diccionario conMarcado:(NSString *)marcado;
-(void)abreTextFieldComentario;
-(void)abreURLDirecta:(NSString *)URLAbrir conModo:(NSString *)modo conOperacion:(NSString *)operacion conIdreal:(NSString *)idreal;
-(void)abreHerramienta:(NSString *)cual conDiccionario:(NSDictionary *)diccionario;
-(void)recargaContenido;
-(void)abreMiPerfil;
-(void)subirFoto;
-(void)actualizaEditando:(BOOL)editandoPasado;
-(void)actualizaTotalPagar:(NSMutableArray *)arreglo conTotal:(float)total;
-(void)calificaCita:(NSString *)idcita conCalificacion:(NSString *)calificacion;
@end

@interface timeline : UIView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,celdaMapaProtocol,timelineGeneralBotonesProtocol,galeriaPrincipalProtocol,timelineCeldaTextoSeleccionProtocol,APIConnectionDelegate,timelineCeldaCalificacionProtocol,celdaConcProtocol,timelineCeldaCitaProtocol>
{
    id<timelineProtocol> delegate;
    NSMutableArray *indice,*indiceTipos;
    NSString *ventanaActual,*modoInternoAviso;
    iwantooAPIConnection *APIConnection,*APIConnection2;
    BOOL cargado;
    int numeroAudios;
    
}




@property (nonatomic,strong) IBOutlet UIView *view;
@property (nonatomic,assign) id<timelineProtocol> delegate;
@property (weak, nonatomic) IBOutlet UITableView *contenedor;
@property (weak, nonatomic) IBOutlet timelineCeldaNoticia *timelineCeldaNoticia;
@property (weak, nonatomic) IBOutlet timelineCeldaNoticia *timelineCeldaNoticia2;
@property (weak, nonatomic) IBOutlet timelineCeldaNoticia *timelineCeldaNoticia3;
@property (weak, nonatomic) IBOutlet timelineCeldaNoticia *timelineCeldaReflexion;

@property (weak, nonatomic) IBOutlet timelineCeldaTitulo *timelineCeldaTitulo;

@property (weak, nonatomic) IBOutlet timelineCeldaTituloInterno *timelineCeldaTituloInterno;

@property (weak, nonatomic) IBOutlet timelineCeldaTituloImagen *timelineCeldaTituloImagen;
@property (weak, nonatomic) IBOutlet timelineCeldaTexto *timelineCeldaTexto;
@property (weak, nonatomic) IBOutlet timelineCeldaTextoSeleccion *timelineCeldaTextoSeleccion;
@property (weak, nonatomic) IBOutlet timelineCeldaBoton *timelineCeldaBoton;
@property (weak, nonatomic) IBOutlet timelineCeldaGaleria *timelineCeldaGaleria;
@property (weak, nonatomic) IBOutlet timelineCeldaGaleria *timelineCeldaGaleria2;
@property (weak, nonatomic) IBOutlet timelineCeldaTextoPeque *timelineCeldaTextoPeque;

@property (weak, nonatomic) IBOutlet timelineGeneralSeparador *timelineGeneralSeparador;
@property (weak, nonatomic) IBOutlet timelineGeneralFoto *timelineGeneralFoto;
@property (weak, nonatomic) IBOutlet timelineCeldaSelecciona *timelineCeldaSelecciona;
@property (weak, nonatomic) IBOutlet timelineCeldaRenglon *timelineCeldaRenglon;
@property (weak, nonatomic) IBOutlet timelineCeldaBotones *timelineCeldaBotones;
@property (weak, nonatomic) IBOutlet timelineCeldaCalificacion *timelineCeldaCalificacion;
@property (weak, nonatomic) IBOutlet timelineCeldaConc *timelineCeldaConc;
@property (weak, nonatomic) IBOutlet timelineCeldaPag *timelineCeldaPag;

@property (weak, nonatomic) IBOutlet timelineCeldaAudio *timelineCeldaAudio;
@property (weak, nonatomic) IBOutlet timelineCeldaAviso *timelineCeldaAviso;

@property (weak, nonatomic) IBOutlet timelineCeldaMapa *timelineCeldaMapa;
@property (weak, nonatomic) IBOutlet timelineCeldaCita *timelineCeldaCita;
@property (weak, nonatomic) IBOutlet timelineCeldaSubtitulo *timelineCeldaSubtitulo;
@property (weak, nonatomic) IBOutlet timelineCeldatextoPantallaCompleta *timelineCeldatextoPantallaCompleta;
@property (nonatomic) long seleccionMaximo,seleccionMinimo,seleccionActual;
@property (nonatomic) BOOL editando;

-(void)acomoda:(NSMutableArray *)indicePasado conTipos:(NSMutableArray *)tipos conPagina:(long)pagina conSeparador:(BOOL)separador conVentana:(NSString *)ventana conAudios:(int)numAudios;
-(void)inserta:(NSMutableArray *)indicePasado conTipos:(NSMutableArray *)tipos conPosicion:(long)posicion;
-(void)quita:(long)cual;
-(void)limpia;
-(void)actualizaBarraSocial:(long)cual conValor:(long)valor;
@property (weak, nonatomic) IBOutlet UIView *noinfo;
@property (weak, nonatomic) IBOutlet UILabel *textoAviso;
@property (weak, nonatomic) IBOutlet UIButton *botonAviso;

@property (nonatomic,strong) NSString *idence;
-(void)mostrarAviso:(NSString *)modo;
-(void)pintaEsperaMinutoXMinuto;
-(void)calculaSeleccionActual;

@end
