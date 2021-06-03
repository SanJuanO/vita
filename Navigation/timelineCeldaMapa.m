//
//  timelineCeldaMapa.m
//  micartelera
//
//  Created by Guillermo on 09/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaMapa.h"

@implementation timelineCeldaMapa
@synthesize diccionario=_diccionario;
@synthesize delegate=_delegate;
- (void)awakeFromNib {
    APIConnection = [[iwantooAPIConnection alloc] init];
    indice=[[NSMutableArray alloc] init];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)pintaMapa
{
    NSLog(@"%@",self.diccionario);
    NSString *geolocalizacion=[APIConnection getStringJSON:self.diccionario  withKey:@"geolocalizacion" widthDefValue:@""];
    if(![geolocalizacion isEqualToString:@""])
    {
        NSString *titulo=[APIConnection getStringJSON:self.diccionario  withKey:@"titulo" widthDefValue:@""];
        BOOL interactivo=[APIConnection getBOOLJSON:self.diccionario withKey:@"interactivo" widthDefValue:false];
        
        NSArray* coordenadas = [geolocalizacion componentsSeparatedByString: @","];
        if([coordenadas count]>1)
        {
            
            self.mapa.tag=10001;
            [self.mapa setDelegate:self];
            CLLocationCoordinate2D location;
            location.latitude = [[coordenadas objectAtIndex: 0] doubleValue];
            location.longitude  = [[coordenadas objectAtIndex: 1] doubleValue];
            
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1500, 1500);
            [self.mapa setRegion:[self.mapa regionThatFits:region] animated:YES];
            
            // Add an annotation
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            point.coordinate = location;
            point.title = titulo;
            point.subtitle = @"";
            
            [self.mapa addAnnotation:point];
            
            if(!interactivo)
            {
                self.mapa.zoomEnabled = NO;
                self.mapa.scrollEnabled = NO;
                self.mapa.userInteractionEnabled = NO;
                self.mapa.userInteractionEnabled=true;
                UITapGestureRecognizer *singleFingerTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(abreMapa:)];
                [self.mapa addGestureRecognizer:singleFingerTap2];
            }
            
            
        }
    }
    else
        [self cargaDatosMapa];
    
}

-(void)cargaDatosMapa
{
    APIConnection = [[iwantooAPIConnection alloc] init];
    indiceCompleto=[[NSMutableArray alloc] init];
    [self.mapa setDelegate:self];
    NSString *geo=@"",*tit=@"";
    NSArray* coordenadas;
    CLLocationCoordinate2D location;
    
    indice=[APIConnection getArrayJSON:self.diccionario withKey:@"indice"];
    
    if([indice count]>0)
    {
        for(NSDictionary *elementoActual in indice)
        {
            geo=[APIConnection getStringJSON:elementoActual withKey:@"geolocalizacion" widthDefValue:@""];
            tit=[APIConnection getStringJSON:elementoActual withKey:@"titulo" widthDefValue:@""];
            modoMaster=[APIConnection getStringJSON:elementoActual withKey:@"modo" widthDefValue:@""];
            coordenadas = [geo componentsSeparatedByString: @","];
            if([coordenadas count]>1)
            {
                location.latitude = [[coordenadas objectAtIndex: 0] doubleValue];
                location.longitude  = [[coordenadas objectAtIndex: 1] doubleValue];
                [indiceCompleto addObject:[NSString stringWithFormat:@"%10.10f,%10.10f",location.latitude,location.longitude]];
                
                @try {
                    if(location.latitude>=-90 && location.latitude<=90 && location.longitude>=-180 && location.longitude<=180)
                    {
                        // Add an annotation
                        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                        point.coordinate = location;
                        point.title = tit;
                        [self.mapa addAnnotation:point];
                    }
                }
                @catch (NSException * e) {
                    NSLog(@"Exception: %@ %@", e,elementoActual);
                }
                @finally {
                    // Added to show finally works as well
                }
                
                
                
                //[self.mapa selectAnnotation:point animated:YES];
                
            }
            else [indiceCompleto addObject:@""];
        }
        [self zoomToFitMapAnnotations:self.mapa];
    }
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@""];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    if([modoMaster isEqualToString:@"master"]) // hay master en el registro, mostraremos detalle
    {
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [rightButton setTitle:@"" forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"verdetalle.png"]forState:UIControlStateNormal];
        rightButton.tag=0;
        [annotationView setRightCalloutAccessoryView:rightButton];
        
        
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    NSString *cadena=[NSString stringWithFormat:@"%10.10f,%10.10f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude];
    
    long valor = [indiceCompleto indexOfObject:cadena];
    if(valor>[indiceCompleto count]) valor=0;
    
    NSDictionary *elementoActual=[indice objectAtIndex:valor];
    
    [self.delegate cargaMaster:[APIConnection getStringJSON:elementoActual withKey:@"accion" widthDefValue:@""] coniDConsulta:[APIConnection getStringJSON:elementoActual withKey:@"idConsulta" widthDefValue:@""] conCual:self.tag];
}


- (void)abreMapa:(UITapGestureRecognizer *)recognizer
{
    [self.delegate cargaMapa:self.tag];
}


@end
