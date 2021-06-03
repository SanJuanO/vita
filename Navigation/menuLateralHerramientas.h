//
//  menuLateralHerramientas.h
//  kiwilimontest
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 24/05/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#ifndef kiwilimontest_menuLateralHerramientas_h
#define kiwilimontest_menuLateralHerramientas_h


// herramientas de menu lateral
-(void)menuLateralGenera
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"menuLateral" owner:self options:nil];
    menuLateralVista = [subviewArray objectAtIndex:0];
    [menuLateralVista acomoda];
    menuLateralVista.delegate=self;
    [self.view addSubview:menuLateralVista];
    [menuLateralVista setHidden:true];
    
    menuLateralVista.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *imageViewTop = [NSLayoutConstraint constraintWithItem:menuLateralVista attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:menuLateralVista.superview attribute:NSLayoutAttributeTopMargin multiplier:1 constant:0];
    imageViewLeft = [NSLayoutConstraint constraintWithItem:menuLateralVista attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:menuLateralVista.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:-300];
    NSLayoutConstraint *imageViewRight = [NSLayoutConstraint constraintWithItem:menuLateralVista attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:menuLateralVista.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *imageViewBottom = [NSLayoutConstraint constraintWithItem:menuLateralVista attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:menuLateralVista.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [menuLateralVista.superview addConstraints:@[imageViewTop, imageViewLeft, imageViewRight, imageViewBottom]];
    [self.view layoutIfNeeded];
}

-(void)menuLateralMuestra
{
    if(!menuLateralVista)
        [self menuLateralGenera];
    else
        [menuLateralVista generaMenu];
    
    imageViewLeft.constant = -300;
    [self.view layoutIfNeeded];
    [menuLateralVista setHidden:false];
    imageViewLeft.constant = 0;
    if([token isEqualToString:@""])
    {
        [menuLateralVista.usuarioboton setTitle:@"Conectarme" forState:UIControlStateNormal];
        menuLateralVista.usuarionombre.text=@"";
        //[menuLateralVista.usuarioimagen setHidden:true];
        [menuLateralVista.usuarioPerfil setHidden:true];
    }
    else
    {
        [menuLateralVista.usuarioimagen setHidden:false];

        [menuLateralVista.usuarioboton setTitle:@"Desconectarme" forState:UIControlStateNormal];
        menuLateralVista.usuarionombre.text=tokenName;
        NSLog(@"tokenMember %@",tokenMember);
        
        if ([tokenMember intValue]==0) {
            [menuLateralVista.imagenPerfil setImage:[UIImage imageNamed:@"firma"]];
        } else {
            [menuLateralVista.imagenPerfil setImage:[UIImage imageNamed:@"imagenMenu"]];
        }
        [menuLateralVista.usuarioPerfil setHidden:false];

    }
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
}

-(void)menuLateralOculta
{
    imageViewLeft.constant = -300;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [menuLateralVista setHidden:true];
    }];
}

-(void)popViewController
{
    [self detieneAudio:true];
    [self.navigationController popViewControllerAnimated:true];
}


-(void)abreHerramienta:(NSString *)cual conDiccionario:(NSDictionary *)diccionario
{
    NSString *operacionActual=[APIConnection getStringJSON:diccionario withKey:@"operacion" widthDefValue:@""];
    NSString *accionActual=[APIConnection getStringJSON:diccionario withKey:@"accion" widthDefValue:@""];
    
    if([operacionActual isEqualToString:@"url"])
    {
        [self abreURLDirecta:[APIConnection getStringJSON:diccionario withKey:@"idreal" widthDefValue:@""] conModo:@"web" conOperacion:@"" conIdreal:@""];
    }
    else if([operacionActual isEqualToString:@"email"])
    {
        NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=Comentarios y sugerencias VITA",[diccionario objectForKey:@"email"]];
        
        NSString *body = [NSString stringWithFormat:@"&body=VITA"];
        
        NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
        
        email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",email);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    }
    else
    {
        if(![cual isEqualToString:self.ventanaActual])
        {
            if([cual isEqualToString:@"salir"])
            {
                // poner aqui todas las rutinas de salir
                [menuLateralVista setHidden:true];
                [APIConnection limpiaSesion];
                [SVProgressHUD showInfoWithStatus:@"Saliste correctamente"];
                recienFirmado=true;
                [self abreFirma];
                [self.navigationController popToRootViewControllerAnimated:true];
            }
            else if([cual isEqualToString:@"entrar"])
            {
                // poner aqui todas las rutinas de salir
                [menuLateralVista setHidden:true];
                [self abreFirma];
            }
            else // es otra
            {
                [menuLateralVista setHidden:true];
                if([accionActual isEqualToString:self.ventanaActual2]) // estamos en la misma ventana
                {
                    [self performSelector:@selector(abreCosas:) withObject:cual];
                }
                else
                {
                    
                    if([self.ventanaActual isEqualToString:@"home"]) // no estamos en el home, cerramos todo y regresamos
                        [self abreVentanaNavigation:cual conDiccionario:diccionario];
                    else
                    {
                        
                        proximaVentana=cual;
                        proximoDiccionario=[NSDictionary dictionaryWithDictionary:diccionario];
                        [self.navigationController popToRootViewControllerAnimated:true];
                    }
                }
                
                
            }
            
        }
    }
}

-(void)abreVentanaNavigation:(NSString *)cual conDiccionario:(NSDictionary *)diccionario
{
    NSString *operacionActual=[APIConnection getStringJSON:diccionario withKey:@"operacion" widthDefValue:@""];
    NSString *accionActual=[APIConnection getStringJSON:diccionario withKey:@"accion" widthDefValue:@""];
    NSString *ventanaActual=[APIConnection getStringJSON:diccionario withKey:@"ventana" widthDefValue:@""];
    if([cual isEqualToString:@"entrar"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"formulario" bundle:nil];
        firmaViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"firma"];
        [self presentViewController:vc animated:true completion:nil];
        
    }
    else if([ventanaActual isEqualToString:@"actividades"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        actividadesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"actividades"];
        vc.ventanaActual=operacionActual;
        vc.ventanaActual2=accionActual;
        vc.idreal=[APIConnection getStringJSON:diccionario withKey:@"idreal" widthDefValue:@""];
        [self.navigationController pushViewController:vc animated:true];
    }
    
    else if([cual isEqualToString:@"perfil"])
    {
        if(![token isEqualToString:@""])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            perfilViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"perfil"];
            
            [self presentViewController:vc animated:true completion:^{
                
                
            }];
            
        }
        else [self abreFirma];
    }
}


-(void)veAlHome
{
    [self detieneAudio:true];
    [self.navigationController popToRootViewControllerAnimated:true];
}



#endif
