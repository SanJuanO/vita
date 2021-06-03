//
//  formCelda.m
//  otroEjemplo
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 14/08/13.
//  Copyright (c) 2013 Imagen Central. All rights reserved.
//

#import "formCelda.h"
#import <QuartzCore/QuartzCore.h>

@implementation formCelda

@synthesize label = _label;
@synthesize campo = _campo;
@synthesize tipo = _tipo;
@synthesize subtipo = _subtipo;
@synthesize valorReal = _valorReal;
@synthesize sectionReal = _sectionReal;
@synthesize rowReal = _rowReal;
@synthesize delegate = _delegate;
@synthesize diccionario = _diccionario;
@synthesize imagen = _imagen;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)elswitchCambio:(id)sender
{
    int valor;
    if(self.elswitch.on) valor = 1;
    else valor=0;
    
    [self.delegate actualizaModelo:[selectorTextos objectAtIndex:valor] conReal:[selectorValores objectAtIndex:valor] conActual:self.tag conActualiza:false];
}

- (IBAction)elcontrolCambio:(id)sender
{
    long valor = self.elcontrol.selectedSegmentIndex;
    [self.delegate actualizaModelo:[selectorTextos objectAtIndex:valor] conReal:[selectorValores objectAtIndex:valor] conActual:self.tag conActualiza:false];
}

-(void)pintaPickerInterno
{
    NSString *subtipo=[self.diccionario objectForKey:@"subtipo"];
    
    [selectorTextos removeAllObjects];
    [selectorValores removeAllObjects];
    
    // leamos los valores de los arreglos
    NSArray *elementos = [[self.diccionario objectForKey:@"opcionestextos"] componentsSeparatedByString: @","];
    selectorTextos = [NSMutableArray arrayWithArray:elementos];
    elementos = [[self.diccionario objectForKey:@"opcionesvalores"] componentsSeparatedByString: @","];
    selectorValores = [NSMutableArray arrayWithArray:elementos];
    
    if([subtipo isEqual:@"switch"])
    {
        [self.elswitch setHidden:false];
        if([self.valorReal isEqualToString:@"0"])
            [self.elswitch setOn:false animated:false];
        else [self.elswitch setOn:true animated:false];
    }
    else if([subtipo isEqual:@"control"])
    {
        [self.elcontrol setHidden:false];
        [self.elcontrol removeAllSegments];
                
        int seleccionado=0;
        for(int i=0; i<=[selectorTextos count]-1; i++)
        {
            [self.elcontrol insertSegmentWithTitle:[selectorTextos objectAtIndex:i] atIndex:i animated:false];
            // veremos si esta seleccionado
            if([self.valorReal isEqualToString:[selectorValores objectAtIndex:i]])
                seleccionado = i;
        }
        
        [self.elcontrol setSelectedSegmentIndex:seleccionado];
    }
    else
    {
        
        
        long cualIndex=[selectorValores indexOfObject:self.valorReal];
        if(NSNotFound != cualIndex) {
            self.campo.text = [selectorTextos objectAtIndex:cualIndex];
        }
        
    }
    
}

- (IBAction)elsliderCambio:(id)sender {
    [sender setValue:((int)((self.elslider.value + incrementoSlider/2) / incrementoSlider) * incrementoSlider) animated:NO];
    [self.delegate actualizaModelo:[NSString stringWithFormat:@"%f",self.elslider.value] conReal:[NSString stringWithFormat:@"%f",self.elslider.value] conActual:self.tag conActualiza:false];
    
    if([self.tipo isEqualToString:@"I"])
        self.campo.text = [NSString stringWithFormat:@"%.0f", roundf( self.elslider.value*100.0)/100.0];
    else self.campo.text = [NSString stringWithFormat:@"%.1f", self.elslider.value];
}

-(void)pintaSlider
{
    [self.elslider setHidden:false];
    [self.campo setHidden:false];
    float real=[self.campo.text floatValue];
    float minimo=[self getFloatJSON2:self.diccionario withKey:@"minimo" widthDefValue:@"0"];
    float maximo=[self getFloatJSON2:self.diccionario withKey:@"maximo" widthDefValue:@"100"];
    incrementoSlider=[self getFloatJSON2:self.diccionario withKey:@"incremento" widthDefValue:@"1"];
    
    [self.elslider setMinimumValue:minimo];
    [self.elslider setMaximumValue:maximo];
    [self.elslider setValue:real];
    
    CGRect marco = self.campo.frame;
    marco.size.width = 45;
    self.campo.frame = marco;
    //[self.campo setTextAlignment:NSTextAlignmentRight];
    
    if([self.tipo isEqualToString:@"I"])
        self.campo.text = [NSString stringWithFormat:@"%.0f", roundf( self.elslider.value*100.0)/100.0];
    else self.campo.text = [NSString stringWithFormat:@"%.1f", self.elslider.value];
    
    marco = self.label.frame;
    marco.origin.y=12;
    self.label.frame=marco;
}

-(void)pintaCampo
{
    [self.campo setHidden:false];
    CGRect marco = self.campo.frame;
    marco.size.width = 190;
    self.campo.frame = marco;
    [self.campo setTextAlignment:NSTextAlignmentLeft];
    if([[self.diccionario objectForKey:@"espassword"] isEqual:@"1"])
        [self.campo setSecureTextEntry:true];
    else [self.campo setSecureTextEntry:false];
    marco = self.label.frame;
    marco.origin.y=12;
    self.label.frame=marco;
}

-(void)pintaCampoIT
{
    [self.campo setHidden:false];
    CGRect marco = self.campo.frame;
    marco.size.width = 160;
    self.campo.frame = marco;
    [self.campo setTextAlignment:NSTextAlignmentLeft];
    marco = self.label.frame;
    marco.origin.y=12;
    self.label.frame=marco;
}

-(void)pintaCampoM
{
    [self.campo setHidden:false];
    CGRect marco = self.campo.frame;
    marco.size.width = 160;
    self.campo.frame = marco;
    [self.campo setTextAlignment:NSTextAlignmentLeft];
    
    marco = self.label.frame;
    marco.origin.y=12;
    self.label.frame=marco;
}

-(void)pintaCampoAI
{
    [self.campo setHidden:true];
    [self.imagen setHidden:false];
    CGRect marco = self.label.frame;
    marco.origin.y=38;
    self.label.frame=marco;
}

-(void)awakeFromNib
{
    CGRect marco = self.elcontrol.frame;
    marco.size.height = 30;
    self.elcontrol.frame = marco;
    self.elcontrol.layer.cornerRadius=20;
    
    UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.elcontrol setTitleTextAttributes:attributes
                                  forState:UIControlStateNormal];
    
    self.imagen.layer.cornerRadius=5;
    self.imagen.clipsToBounds=true;
    self.imagen.layer.shadowOffset = CGSizeMake(2, 2);
    self.imagen.layer.shadowRadius = 2;
    self.imagen.layer.shadowOpacity = 0.5;
}



-(float)getFloatJSON2:(id)dictionary withKey:(NSString *)key widthDefValue:(NSString *)defValue
{
    float newFloat;
    NSString *newString;
    @try { newString = [dictionary objectForKey:key]; }
    @catch (NSException *exception) { newString = defValue; }
    @finally {  }
    if(newString == NULL || [newString isEqual: [NSNull null]]) newString = defValue;
    
    newFloat = [newString floatValue];
    return newFloat;
}


@end
