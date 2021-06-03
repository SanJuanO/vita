//
//  mapaViewController.h
//  1123xti
//
//  Created by GUILLERMO FERNANDEZ M on 08/10/13.
//  Copyright (c) 2013 GUILLERMO FERNANDEZ M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fontMuseo.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol formMapaProtocol <NSObject>
-(void)devuelveTexto:(NSString *)texto conCampo:(NSString *)campo;
@end

@interface mapaViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    id<formMapaProtocol> delegate;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapa;
@property (nonatomic,strong) NSString *geolocalizacion,*cualCampo;
@property (nonatomic,assign) id<formMapaProtocol> delegate;

@end



