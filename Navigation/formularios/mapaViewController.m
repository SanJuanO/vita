//
//  mapaViewController.m
//  1123xti
//
//  Created by GUILLERMO FERNANDEZ M on 08/10/13.
//  Copyright (c) 2013 GUILLERMO FERNANDEZ M. All rights reserved.
//

#import "mapaViewController.h"
#import "AZDraggableAnnotationView.h"
#import "AppDelegate.h"

@interface mapaViewController ()

@end

@implementation mapaViewController
@synthesize mapa = _mapa;
@synthesize geolocalizacion = _geolocalizacion;
@synthesize cualCampo=_cualCampo;
@synthesize delegate=_delegate;
#import "globales.h"
#import "color.h"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    if(![self.geolocalizacion isEqualToString:@""])
    {
        
        NSArray *arreglo=[self.geolocalizacion componentsSeparatedByString:@","];
        if([arreglo count]==2)
        {
            CLLocation *LocationAtual=[[CLLocation alloc] initWithLatitude:[[arreglo objectAtIndex:0] floatValue] longitude:[[arreglo objectAtIndex:1] floatValue]];
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(LocationAtual.coordinate, 250, 250);
            [self.mapa setRegion:[self.mapa regionThatFits:region] animated:YES];
        }
        else self.geolocalizacion=@"";
    }
    
    if([self.geolocalizacion isEqualToString:@""])
    {
        locationManager = [[CLLocationManager alloc] init];
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        
        locationManager.delegate = self;
        //locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
        [locationManager startUpdatingLocation];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    CLLocation *newLocation = [locations lastObject];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 250, 250);
    [self.mapa setRegion:[self.mapa regionThatFits:region] animated:YES];
    [locationManager stopUpdatingLocation];
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed %ld",(long)[error code]);
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [mv dequeueReusableAnnotationViewWithIdentifier:@"DraggableAnnotationView"];
    
    if (!annotationView) {
        annotationView = [[AZDraggableAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"DraggableAnnotationView"];
        annotationView.draggable = YES;
    }
    
    return annotationView;
}

- (IBAction)salir:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}
- (IBAction)guardar:(id)sender {
    [self.delegate devuelveTexto:[NSString stringWithFormat:@"%f,%f",self.mapa.centerCoordinate.latitude,self.mapa.centerCoordinate.longitude] conCampo:self.cualCampo];
    [self dismissViewControllerAnimated:true completion:^{
        
        
    }];
}



@end
