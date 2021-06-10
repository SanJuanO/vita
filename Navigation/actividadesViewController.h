//
//  actividadesViewController.h
//  micartelera
//
//  Created by Guillermo on 16/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import "baseVentanaViewController.h"
#import <UIKit/UIKit.h>
#import "timeline.h"

@interface actividadesViewController : baseVentanaViewController<timelineProtocol,UIActionSheetDelegate,NSXMLParserDelegate>
{
    BOOL primeraVez,cargarInfinite;
    long posicionTimeline;
    NSMutableDictionary *diccionarioAccion;
    NSTimer *timerX;
    NSString *statusence,*idconcFinal;
    float pagarTotal;
    int acompananTempo;
    NSMutableArray *pagarArreglo;
    NSString *statusActual;
    NSInteger botonGuia;
    NSString *enCalendario;
    NSDictionary *diccionarioCalendario;
    
    NSMutableArray *calendarArray;
    

}

@property (weak, nonatomic) IBOutlet headerPrincipal *headerPrincipal;
@property (weak, nonatomic) IBOutlet timeline *timeline;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timelineDistancia;
@property (weak, nonatomic) IBOutlet UIView *vistaBotones;
@property (weak, nonatomic) IBOutlet UIButton *bactividades;
@property (weak, nonatomic) IBOutlet UIButton *bformacion;
@property (weak, nonatomic) IBOutlet UIButton *bencuentros;
@property (weak, nonatomic) IBOutlet UIButton *bmiagenda;
@property (weak, nonatomic) IBOutlet UIImageView *bactividadesT;
@property (weak, nonatomic) IBOutlet UIImageView *bformacionT;
@property (weak, nonatomic) IBOutlet UIImageView *bencuentrosT;
@property (weak, nonatomic) IBOutlet UIImageView *bmiagendaT;

@property (weak, nonatomic) IBOutlet UIView *vistaBotones2;
@property (weak, nonatomic) IBOutlet UIButton *bparroquias;
@property (weak, nonatomic) IBOutlet UIButton *bpadres;
@property (weak, nonatomic) IBOutlet UIImageView *bparroquiasT;
@property (weak, nonatomic) IBOutlet UIImageView *bpadresT;
-(void)abreCosas:(NSString *)ventanaSiguiente;
@property (weak, nonatomic) IBOutlet UIView *vistaAccion;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posicionVistaAccion;
@property (weak, nonatomic) IBOutlet UILabel *vistaAccionTexto;
-(void)detieneAudio:(BOOL)cerrar;

@property (weak, nonatomic) IBOutlet UIView *vistaBotonesConceptos;
@property (weak, nonatomic) IBOutlet UIButton *btodos;
@property (weak, nonatomic) IBOutlet UIButton *bpendientes;
@property (weak, nonatomic) IBOutlet UIButton *bpagados;
@property (weak, nonatomic) IBOutlet UIButton *bcancelados;
@property (weak, nonatomic) IBOutlet UIImageView *btodosT;
@property (weak, nonatomic) IBOutlet UIImageView *bpendientesT;
@property (weak, nonatomic) IBOutlet UIImageView *bpagadosT;
@property (weak, nonatomic) IBOutlet UIImageView *bcanceladosT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posicionVistaBotonesConceptos;
@property (weak, nonatomic) IBOutlet UIButton *botonAnteriorEncuentro;
@property (weak, nonatomic) IBOutlet UIButton *botonSiguienteEncuentro;

@property (nonatomic, strong) NSMutableDictionary *dictData;
@property (nonatomic,strong) NSMutableArray *marrXMLData;
@property (nonatomic,strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *mdictXMLPart;
@end

