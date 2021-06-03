//
//  imagenViewController.m
//  cut
//
//  Created by Guillermo on 24/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "imagenViewController.h"
#import "UIImageView+AFNetworking.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import <sqlite3.h>
@interface imagenViewController ()

@end

@implementation imagenViewController
@synthesize imagen=_imagen;
@synthesize archivo=_archivo;

#import "databaseOperations.h"
#import "globales.h"
#import "color.h"

- (void)viewDidLoad {
    [self.view setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo3"] withAlpha:1.0]];
    
    if ([self.archivo rangeOfString:@"http://"].location == NSNotFound && [self.archivo rangeOfString:@"https://"].location == NSNotFound) {
        [self.imagen setImageWithURL:[NSURL URLWithString:[self extraeArchivoReal:self.archivo conModo:@"N"]]];
    } else {
        [self.imagen setImageWithURL:[NSURL URLWithString:self.archivo]];
    }
    
    self.scroll.maximumZoomScale = 5.0;
    self.scroll.delegate = self;
    [self initZoom];
    // Set the content:
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"imagen"
                                                          action:@"abre"
                                                           label:self.archivo
                                                           value:nil] build]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// Zoom to show as much image as possible
- (void) initZoom {
    float minZoom = MIN(self.view.bounds.size.width / self.imagen.frame.size.width,
                        self.view.bounds.size.height / self.imagen.frame.size.height);
    if (minZoom > 1) return;
    self.scroll.minimumZoomScale = minZoom;
    self.scroll.zoomScale = minZoom;
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imagen;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cerrar:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
