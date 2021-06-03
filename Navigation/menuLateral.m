//
//  menuLateral.m
//  kiwilimontest
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 23/05/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "menuLateral.h"
#import "UIImageView+AFNetworking.h"
#import <sqlite3.h>
@implementation menuLateral
@synthesize contenedor=_contenedor;
@synthesize imagen=_imagen;
@synthesize celdaMenuLateral=_celdaMenuLateral;
@synthesize delegate=_delegate;
@synthesize vista=_vista;

#import "globales.h"
#import "color.h"
#import "databaseOperations.h"


-(void)generaMenu
{
    [elementos removeAllObjects];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          NSLocalizedString(@"Lo último", ),@"titulo",
                          @"",@"operacion",
                          @"titulo",@"pintar",nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Manual de oraciones",@"titulo",
                          @"url",@"operacion",
                          @"http://www.biznessapps.com/mobile/?appcode=RCMobile&controller=InfoItemsViewController&tab_id=1152903&back_url=none",@"url",
                          @"boton",@"pintar",
                          nil]];
   
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Reflexión evangélica",@"titulo",
                          @"actividades",@"ventana",
                          @"ReflexionDelDia",@"operacion",
                          @"ReflexionDelDia",@"accion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Misal diario",@"titulo",
                          @"actividades",@"ventana",
                          @"misal",@"accion",
                          @"mis",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Encuentro con Cristo",@"titulo",
                          @"ultimoEncuentro",@"operacion",
                          @"ultimoEncuentro",@"accion",
                          @"actividades",@"ventana",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Agenda",@"titulo",
                          @"actividades",@"ventana",
                          @"calendario",@"accion",
                          @"mia",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    
    
    

    
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          NSLocalizedString(@"Accesos directos", ),@"titulo",
                          @"",@"operacion",
                          @"titulo",@"pintar",nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Actividades",@"titulo",
                          @"actividades",@"ventana",
                          @"actividades",@"accion",
                          @"act",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Formación",@"titulo",
                          @"actividades",@"ventana",
                          @"formacion",@"accion",
                          @"for",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Encuentros semanales",@"titulo",
                          @"actividades",@"ventana",
                          @"encuetros",@"accion",
                          @"enc",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    
    
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Noticias",@"titulo",
                          @"actividades",@"ventana",
                          @"noticias",@"accion",
                          @"noti",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Biblioteca",@"titulo",
                          @"actividades",@"ventana",
                          @"pdfs",@"accion",
                          @"catpdf",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Catálogo de Apostolados",@"titulo",
                          @"actividades",@"ventana",
                          @"apostolados",@"accion",
                          @"apo",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    
    
    
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Agenda sacramental",@"titulo",
                          @"",@"operacion",
                          @"titulo",@"pintar",nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Parroquias",@"titulo",
                          @"actividades",@"ventana",
                          @"agenda",@"accion",
                          @"par",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Padres",@"titulo",
                          @"actividades",@"ventana",
                          @"agenda",@"accion",
                          @"pad",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Manual de oraciones",@"titulo",
                          @"url",@"operacion",
                          @"http://www.biznessapps.com/mobile/?appcode=RCMobile&controller=InfoItemsViewController&tab_id=1152903&back_url=none",@"url",
                          @"boton",@"pintar",
                          nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Misal diario",@"titulo",
                          @"actividades",@"ventana",
                          @"misal",@"accion",
                          @"mis",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
   /* [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Reflexiones del día",@"titulo",
                          @"actividades",@"ventana",
                          @"reflexiones",@"accion",
                          @"ref",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    */
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Somos RC",@"titulo",
                          @"",@"operacion",
                          @"titulo",@"pintar",nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Noticias",@"titulo",
                          @"actividades",@"ventana",
                          @"rss",@"accion",
                          @"rss",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
   
    
    
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          NSLocalizedString(@"Mi perfil", ),@"titulo",
                          @"",@"operacion",
                          @"titulo",@"pintar",nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Editar perfil",@"titulo",
                          @"",@"ventana",
                          @"",@"accion",
                          @"perfil",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Estado de cuenta",@"titulo",
                          @"actividades",@"ventana",
                          @"conceptos",@"accion",
                          @"conc",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Mis pagos",@"titulo",
                          @"actividades",@"ventana",
                          @"pagos",@"accion",
                          @"pag",@"operacion",
                          @"0",@"idreal",
                          @"boton",@"pintar",
                          nil]];
    
    
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          NSLocalizedString(@"Generales", ),@"titulo",
                          @"",@"operacion",
                          @"titulo",@"pintar",nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"¿Qué es VITA?",@"titulo",
                          @"url",@"operacion",
                          @"http://www.vitamexico.org/index.php?modo=quees",@"url",
                          @"boton",@"pintar",
                          nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Preguntas frecuentes",@"titulo",
                          @"url",@"operacion",
                          @"http://www.vitamexico.org/index.php?modo=preguntas",@"url",
                          @"boton",@"pintar",
                          nil]];
    [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"Aviso de privacidad",@"titulo",
                          @"url",@"operacion",
                          @"http://www.vitamexico.org/index.php?modo=aviso",@"url",
                          @"boton",@"pintar",
                          nil]];
    
    
    if(![token isEqualToString:@""])
    {
        [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                              @"Más",@"titulo",
                              @"",@"operacion",
                              @"titulo",@"pintar",nil]];
        [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                              @"Comentarios y sugerencias",@"titulo",
                              @"",@"ventana",
                              @"comentarios",@"accion",
                              @"email",@"operacion",
                              @"0",@"idreal",
                              @"boton",@"pintar",
                              @"rescorza@nemi.com.mx",@"email",
                              nil]];
        [elementos addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                              @"Desconectarme",@"titulo",
                              @"",@"ventana",
                              @"desconectar",@"accion",
                              @"par",@"operacion",
                              @"0",@"idreal",
                              @"boton",@"pintar",
                              nil]];

    }
    
    [self.contenedor reloadData];
}
-(void)acomoda
{
    
    
    [self generaMenu];
    
}

-(void)awakeFromNib
{
    self.contenedor.delegate=self;
    self.contenedor.dataSource=self;
    [self.contenedor setBackgroundColor:[UIColor clearColor]];
    elementos = [[NSMutableArray alloc] init];
    [self.imagen setBackgroundColor:[self colorDesdeString:@"#f2f2f2" withAlpha:1.0]];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [elementos count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *elemento = [elementos objectAtIndex:indexPath.row];
    
    static NSString *cellMainNibID = @"celdaMenuLateral";
    
    self.celdaMenuLateral = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
    if (self.celdaMenuLateral == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"celdaMenuLateral" owner:self options:nil];
    }
    
    UILabel *imageTitle = (UILabel *)[_celdaMenuLateral viewWithTag:2];
    imageTitle.text = [NSString stringWithFormat:@"%@", [elemento objectForKey:@"titulo"]];
    
    NSString *pintar=[elemento objectForKey:@"pintar"];
    
    
    
    if([pintar isEqualToString:@"titulo"] || [pintar isEqualToString:@"espaciador"])
    {
        [imageTitle setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
        [self.celdaMenuLateral.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo1"] withAlpha:1.0]];

    }
    else
    {
        [imageTitle setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorSubtitulo"] withAlpha:1.0]];
        [self.celdaMenuLateral.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo2"] withAlpha:1.0]];
    }

    return self.celdaMenuLateral;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *elemento = [elementos objectAtIndex:indexPath.row];
    
    if([[elemento objectForKey:@"operacion"] isEqualToString:@"perfil"])
        [self.delegate abreHerramienta:@"perfil" conDiccionario:nil];
    if([[elemento objectForKey:@"operacion"] isEqualToString:@"url"])
    {
        [self.delegate abreURLDirecta:[elemento objectForKey:@"url"] conModo:@"web" conOperacion:[elemento objectForKey:@"operacion"] conIdreal:[elemento objectForKey:@"idreal"]];
        [self.delegate menuLateralOculta];
    }
    else if(![[elemento objectForKey:@"operacion"] isEqualToString:@""])
    {
        if([[elemento objectForKey:@"accion"] isEqualToString:@"desconectar"])
        {
            [self desconectarte:nil];
        }
        if([[elemento objectForKey:@"accion"] isEqualToString:@"comentarios"])
        {
            
            [self.delegate abreHerramienta:[elemento objectForKey:@"operacion"] conDiccionario:elemento];
        }
        else
        {
            [self.delegate abreHerramienta:[elemento objectForKey:@"operacion"] conDiccionario:elemento];
            [self.delegate menuLateralOculta];
        }
        
    }
}


- (IBAction)ocultarMenu:(id)sender {
    [self.delegate menuLateralOculta];
}

- (IBAction)cerremosSwipe:(id)sender {
    [self.delegate menuLateralOculta];
}
- (IBAction)desconectarte:(id)sender {
    if([token isEqualToString:@""])
        [self.delegate abreHerramienta:@"entrar" conDiccionario:nil];
    else
        [self.delegate abreHerramienta:@"salir" conDiccionario:nil];
    [self.delegate menuLateralOculta];
}


- (IBAction)abrePerfil:(id)sender {
    [self.delegate abreHerramienta:@"perfil" conDiccionario:nil];
}


@end

