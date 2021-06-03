//
//  mapaTimelineViewController.h
//  micartelera
//
//  Created by Guillermo on 09/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import "baseVentanaViewController.h"
#import <MapKit/MapKit.h>
#import "headerPrincipal.h"

@interface mapaTimelineViewController : baseVentanaViewController<MKMapViewDelegate>
{
    NSMutableArray *indiceCompleto;
    NSMutableArray *indiceSecciones,*indiceTitles;
    NSString *modoMaster,*geolocalizacion;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapa;
@property (weak, nonatomic) IBOutlet headerPrincipal *headerPrincipal;
-(void)pintaMapa;
-(void)detieneAudio:(BOOL)cerrar;
@end
