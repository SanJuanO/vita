//
//  formMemoViewController.m
//  tenerMascota
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 21/08/13.
//  Copyright (c) 2013 Imagen Central. All rights reserved.
//

#import "formMemoViewController.h"
@interface formMemoViewController ()

@end

@implementation formMemoViewController
@synthesize texto = _texto;
@synthesize cualCampo = _cualCampo;
@synthesize delegate = _delegate;
@synthesize textoValor = _textoValor;
@synthesize tituloPrincipal=_tituloPrincipal;

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
    CGRect marco = self.texto.frame;
    marco.size.height = screenHeight-44-216;
    self.tituloPrincipal.text=self.titulo;
    self.texto.frame=marco;
    [self.texto setBackgroundColor:[UIColor clearColor]];
    
    [self.texto becomeFirstResponder];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cerrar:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:^{ }];
}
- (IBAction)guardar:(id)sender {
    [self.delegate devuelveTexto:self.texto.text conCampo:self.cualCampo];
    [self dismissViewControllerAnimated:true completion:^{ }];
}

- (void)viewDidUnload {
    [self setTexto:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.texto.text = self.textoValor;
}
@end
