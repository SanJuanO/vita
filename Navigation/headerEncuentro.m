//
//  headerEncuentro.m
//  centrovita
//
//  Created by Guillermo on 22/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import "headerEncuentro.h"
#import "PureLayout.h"
#import <sqlite3.h>
@implementation headerEncuentro
@synthesize delegate=_delegate;
#import "globales.h"
#import "color.h"
#import "databaseOperations.h"


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self)
    {
        [self setup];
        
    }
    return self;
}

-(void)setup
{
    [[NSBundle mainBundle] loadNibNamed:@"headerEncuentro" owner:self options:nil];
    [self addSubview:self.view];
    [self.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    //[self setBackgroundColor:[UIColor clearColor]];
}

-(void)inicializa:(NSString *)titulo conPaso:(long)paso conPasos:(long)pasos
{
    self.etiqueta.text=titulo;
    [self pintaElementos];
    
}

-(void)pintaElementos
{
    
}
- (IBAction)botonAnterior:(id)sender {
    [self.delegate encuentroAtras];
}

- (IBAction)botonSiguiente:(id)sender {
    [self.delegate encuentroAdelante];
}

@end
