//
//  timelineCeldaMapa.h
//  micartelera
//
//  Created by Guillermo on 09/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iwantooAPIConnection.h"
#import <MapKit/MapKit.h>
@protocol celdaMapaProtocol <NSObject>
@optional -(void)cargaMapa:(long)tagActual;
@optional -(void)cargaMaster:(NSString *)accion coniDConsulta:(NSString *)idConsulta conCual:(long)cual;
@end

@interface timelineCeldaMapa : UITableViewCell<MKMapViewDelegate>
{
    id<celdaMapaProtocol> delegate;
    iwantooAPIConnection *APIConnection;
    NSMutableArray *indice;
    NSMutableArray *indiceCompleto;
    NSMutableArray *indiceSecciones,*indiceTitles;
    NSString *modoMaster;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapa;
@property (nonatomic,strong) NSDictionary *diccionario;
@property (nonatomic,assign) id<celdaMapaProtocol> delegate;

-(void)pintaMapa;
@end


