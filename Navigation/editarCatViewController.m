//
//  editarCatViewController.m
//  centrovita
//
//  Created by Guillermo on 01/02/17.
//  Copyright © 2017 Tammy L Coron. All rights reserved.
//

#import "editarCatViewController.h"
#import "SVProgressHUD.h"
@interface editarCatViewController ()

@end

@implementation editarCatViewController
#import "color.h"
#import "globales.h"
-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    if([senderValue isEqualToString:@"editar"])
    {
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        if(response)
        {
            NSDictionary *cat=[APIConnection getDictionaryJSON:response withKey:@"cat"];
            if(cat)
            {
                nombreT=[APIConnection getStringJSON:cat withKey:@"nombrecat" widthDefValue:@""];
                textoT=[APIConnection getStringJSON:cat withKey:@"textocat" widthDefValue:@""];
                self.nombre.text=nombreT;
                self.texto.text=textoT;
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"Información no encontrada"];
            [self cerrar];
        }
    }
    else  if([senderValue isEqualToString:@"editarNota"])
    {
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        if(response)
        {
            NSDictionary *nota=[APIConnection getDictionaryJSON:response withKey:@"nota"];
            if(nota)
            {
                nombreT=[APIConnection getStringJSON:nota withKey:@"titulonotas" widthDefValue:@""];
                textoT=[APIConnection getStringJSON:nota withKey:@"textonotas" widthDefValue:@""];
                self.nombre.text=nombreT;
                self.texto.text=textoT;
                audioremoto=true;
                [self cargaAudio:[APIConnection getStringJSON:nota withKey:@"audionotas" widthDefValue:@""]];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"Información no encontrada"];
            [self cerrar];
        }
    }
    else if([senderValue isEqualToString:@"editarGuardar"])
    {
        stringToPass=@"refrescarEditar";
        [self cerrar];
    }
    else if([senderValue isEqualToString:@"subirAudioNota"])
    {
        stringToPass=@"refrescarEditar";
        [self cerrar];

    }
    else if([senderValue isEqualToString:@"subirAudioCaso"])
    {
        stringToPass=@"refrescarEditar";
        [self cerrar];
        
    }
    
}

- (void)viewDidLoad {
    
    audioremoto=false;
    [self.vistaPrincipal setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.view setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    [self.descripcion setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];

    audioGrabado=false;
    [self.vistaAudio setHidden:true];
    self.vistaAudioPosicion.constant=10;
    [self.vistaGrabador setHidden:true];
    [self.view setNeedsLayout];
    
    UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    
    self.texto.layer.borderColor = borderColor.CGColor;
    self.texto.layer.borderWidth = 1.0;
    self.texto.layer.cornerRadius = 5.0;
    
    APIConnection=[[iwantooAPIConnection alloc] init];
    APIConnection.delegationListener=self;
    if([self.ventanaActual isEqualToString:@"editarCaso"])
    {
        self.titulo.text=@"Editar caso";
        self.nombre.placeholder=@"Nombre del caso";
        [self.vistaAudio setHidden:false];
        self.vistaAudioPosicion.constant=58;
        [self.view setNeedsLayout];
    }
    else if([self.ventanaActual isEqualToString:@"agregarCaso"])
    {
        self.titulo.text=@"Agregar caso";
        self.nombre.placeholder=@"Nombre del caso";
        [self.vistaGrabador setHidden:false];
        [self.vistaAudio setHidden:false];
        self.vistaAudioPosicion.constant=58;
        [self.view setNeedsLayout];
    }
    else if([self.ventanaActual isEqualToString:@"editarActuar"])
    {
        self.titulo.text=@"Editar Actuar";
        self.nombre.placeholder=@"Nombre del actuar";
    }
    else if([self.ventanaActual isEqualToString:@"agregarActuar"])
    {
        self.titulo.text=@"Agregar Actuar";
        self.nombre.placeholder=@"Nombre del actuar";
    }
    else if([self.ventanaActual isEqualToString:@"editarNota"])
    {
        self.titulo.text=@"Editar Nota";
        self.nombre.placeholder=@"Título de la nota";
        self.descripcion.text=@"Nota";
        [self.vistaAudio setHidden:false];
        self.vistaAudioPosicion.constant=58;
        [self.view setNeedsLayout];

    }
    else if([self.ventanaActual isEqualToString:@"agregarNota"])
    {
        self.titulo.text=@"Agregar Nota";
        self.nombre.placeholder=@"Título de la nota";
        self.descripcion.text=@"Nota";
        [self.vistaGrabador setHidden:false];
        [self.vistaAudio setHidden:false];
        self.vistaAudioPosicion.constant=58;
        [self.view setNeedsLayout];

    }
    
    if(self.diccionario)
    {
        self.nombre.text=[APIConnection getStringJSON:self.diccionario withKey:@"nombrecat" widthDefValue:@""];
        self.texto.text=[APIConnection getStringJSON:self.diccionario withKey:@"textocat" widthDefValue:@""];
    }
    else
    {
        self.nombre.text=@"";
        self.texto.text=@"";
    }
    
    
    if([self.ventanaActual isEqualToString:@"agregarNota"] || [self.ventanaActual isEqualToString:@"agregarCaso"])
    {
        // Disable Stop/Play button when application launches
        //[self.botonGrabar setEnabled:NO];
        [self.botonReproducir setEnabled:NO];
        
        // Set the audio file
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   @"audioGenerado.m4a",
                                   nil];
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        
        // Setup audio session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        // Define the recorder setting
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        // Initiate and prepare the recorder
        recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
        recorder.delegate = self;
        recorder.meteringEnabled = YES;
        [recorder prepareToRecord];
    }
    nombreT=self.nombre.text;
    textoT=self.texto.text;
    [self.nombre becomeFirstResponder];
    
    if([self.ventanaActual isEqualToString:@"editarCaso"] || [self.ventanaActual isEqualToString:@"editarActuar"])
    {
        [APIConnection connectAPI:[NSString stringWithFormat:@"catLeer.php?modo=%@&idreal=%@",self.ventanaActual,self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"editar" willContinueLoading:false];
    }
    else if([self.ventanaActual isEqualToString:@"editarNota"])
    {
        [APIConnection connectAPI:[NSString stringWithFormat:@"notas.php?modo=editarNota&idreal=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"editarNota" willContinueLoading:false];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)cancelar:(id)sender {
    [self cerrar];
}

-(void)cerrar
{
    [self.movieplayer pause];

    [recorder stop];
    
    [timerMemo invalidate];
    if (timeObserverToken)
    {
        [self.movieplayer removeTimeObserver:timeObserverToken];
        timeObserverToken = nil;
    }
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}

- (IBAction)guardar:(id)sender
{
    if(audioGrabado)
    {
        [self termineGrabar];
    }
    
    if([self.nombre.text isEqualToString:@""])
        [SVProgressHUD showErrorWithStatus:@"Escribe un nombre"];
    else if([self.texto.text isEqualToString:@""] &&
            ![self.ventanaActual isEqualToString:@"editarNota"] &&
            ![self.ventanaActual isEqualToString:@"agregarNota"] &&
            ![self.ventanaActual isEqualToString:@"editarActuar"] &&
            ![self.ventanaActual isEqualToString:@"agregarActuar"])
        [SVProgressHUD showErrorWithStatus:@"Escribe una descripción/texto"];
    else if(![self.nombre.text isEqualToString:nombreT] || ![self.texto.text isEqualToString:textoT])
    {
        NSString *modoTempo=@"";
        if([self.ventanaActual isEqualToString:@"editarCaso"])
            modoTempo=@"editarCasoGuardar";
        else if([self.ventanaActual isEqualToString:@"editarActuar"])
            modoTempo=@"editarActuarGuardar";
        else if([self.ventanaActual isEqualToString:@"agregarCaso"])
            modoTempo=@"agregarCasoGuardar";
        else if([self.ventanaActual isEqualToString:@"agregarActuar"])
            modoTempo=@"agregarActuarGuardar";
        else
            modoTempo=self.ventanaActual;
        
        if([self.ventanaActual isEqualToString:@"editarNota"] || [self.ventanaActual isEqualToString:@"agregarNota"])
        {
            if([self.ventanaActual isEqualToString:@"agregarNota"] && audioGrabado)
            {
                [APIConnection connectAPI:[NSString stringWithFormat:@"notas.php?modo=subirAudioNota&idreal=%@&nombre=%@&texto=%@",self.idreal,self.nombre.text,self.texto.text] withData:@"" withMethod:@"POST" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"subirAudioNota" willContinueLoading:false];

            }
            else
            {
                [APIConnection connectAPI:[NSString stringWithFormat:@"notas.php?modo=%@Guardar&idreal=%@&nombre=%@&texto=%@",modoTempo,self.idreal,self.nombre.text,self.texto.text] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"editarGuardar" willContinueLoading:false];

            }
        }
        else if([self.ventanaActual isEqualToString:@"editarCaso"] || [self.ventanaActual isEqualToString:@"agregarCaso"])
        {
            if([self.ventanaActual isEqualToString:@"agregarCaso"] && audioGrabado)
            {
                [APIConnection connectAPI:[NSString stringWithFormat:@"catLeer.php?modo=agregarCasoGuardarAudio&idreal=%@&nombre=%@&texto=%@",self.idreal,self.nombre.text,self.texto.text] withData:@"" withMethod:@"POST" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"subirAudioCaso" willContinueLoading:false];
                                
            }
            else
            {
                [APIConnection connectAPI:[NSString stringWithFormat:@"catLeer.php?modo=%@&idreal=%@&nombre=%@&texto=%@",modoTempo,self.idreal,self.nombre.text,self.texto.text] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"editarGuardar" willContinueLoading:false];
            }
        }
        else
            [APIConnection connectAPI:[NSString stringWithFormat:@"catLeer.php?modo=%@&idreal=%@&nombre=%@&texto=%@",modoTempo,self.idreal,self.nombre.text,self.texto.text] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"editarGuardar" willContinueLoading:false];

    }
    else [self cerrar];
}

-(NSString *)convierteTiempo:(float)tiempo
{
    NSString *respuesta=@"";
    
    long segundos=round(tiempo);
    long minutos=floor(segundos/60);
    long segundosReales=segundos-minutos*60;
    respuesta=[NSString stringWithFormat:@"%02ld:%02ld",minutos,segundosReales];
    return respuesta;
}

-(void)cargaAudio:(NSString *)urlCargar
{
    if(![urlCargar isEqualToString:@""])
    {
        if(!self.movieplayer)
        {
           self.movieplayer = [[AVPlayer alloc] init];
        }
        urlCargar = [urlCargar stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        urlCargar=[NSString stringWithFormat:@"%@%@",GAPIURLImages,urlCargar];
        
        [SVProgressHUD showWithStatus:@"..."];
        NSURL *fileURL =  [NSURL URLWithString:urlCargar];
        self.movieplayer = [AVPlayer playerWithURL:fileURL];
        [self.movieplayer play];

        [self.vistaAudio setHidden:false];
        [self.vistaGrabador setHidden:false];
        [self.botonGrabar setHidden:true];
        [self.botonReproducir setImage:[UIImage imageNamed:@"botonDetener"] forState:UIControlStateNormal];
        reproduciendo=true;
        
        timeObserverToken =
        [self.movieplayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 2)
                                                   queue:dispatch_get_main_queue()
                                              usingBlock:^(CMTime time)
                                              {
            float tiempo=CMTimeGetSeconds(time);
            float duracion=CMTimeGetSeconds(self.movieplayer.currentItem.duration);
            if(tiempo>0) [SVProgressHUD dismiss];
            self.grabarVoz.text=[NSString stringWithFormat:@"%@/%@",[self convierteTiempo:tiempo],[self convierteTiempo:duracion]];
                                              }];
        
        self.movieplayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.movieplayer currentItem]];
        
    }
    else
        
    {
        [self.vistaAudio setHidden:true];
        self.vistaAudioPosicion.constant=8;
        [self.view setNeedsLayout];
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    [self.movieplayer pause];
    [self.botonReproducir setImage:[UIImage imageNamed:@"botonReproducir"] forState:UIControlStateNormal];
    reproduciendo=false;
}



- (IBAction)recordPauseTapped:(id)sender {
    if (player2.playing) {
        [player2 stop];
    }
    
    [self.botonReproducir setEnabled:NO];

    if (!recorder.recording) {
        audioGrabado=true;
        [self.botonReproducir setEnabled:false];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *error1;
        NSError *error2;
        
        [session setActive:YES error:&error1];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error2];
        if(error1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error 1"
                                                            message:[error1 localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            NSLog(@"A %@",[error1 localizedDescription]);
        }
        if(error2)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error 2"
                                                            message:[error2 localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            NSLog(@"B %@",[error2 localizedDescription]);
        }
        [recorder record];
        
        [self.botonGrabar setImage:[UIImage imageNamed:@"botonDetener"] forState:UIControlStateNormal];
        cuentaTimer=0;
        timerMemo=[NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(onTick:)
                                       userInfo:nil
                                        repeats:YES];
        
    } else {
        NSLog(@"aca");
        [self termineGrabar];
    }
}

-(void)termineGrabar
{
    NSLog(@"termino");
    [self.botonReproducir setEnabled:YES];
    [self.botonGrabar setEnabled:YES];
    [recorder stop];
    [self.botonGrabar setImage:[UIImage imageNamed:@"botonGrabar"] forState:UIControlStateNormal];
    
    [timerMemo invalidate];
    self.grabarVoz.text=@"Grabar voz";
    
}

-(void)onTick:(NSTimer *)timer {
    cuentaTimer++;
     self.grabarVoz.text=[NSString stringWithFormat:@"Grabar voz: %lds",cuentaTimer];
    if(cuentaTimer>=60)
    {
        [SVProgressHUD showInfoWithStatus:@"Tiempo máximo alcanzado"];
        [self termineGrabar];
    }
}

- (IBAction)stopTapped:(id)sender {
    
    [recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (IBAction)playTapped:(id)sender {
    
    if(audioremoto)
    {
        if(!reproduciendo)
        {
            [self.botonReproducir setImage:[UIImage imageNamed:@"botonDetener"] forState:UIControlStateNormal];
            reproduciendo=true;
            [self.movieplayer play];
        }
        else
        {
            [self.botonReproducir setImage:[UIImage imageNamed:@"botonReproducir"] forState:UIControlStateNormal];
           reproduciendo=false;
           [self.movieplayer pause];
        }
    }
    else
    {

        if (!recorder.recording){
            
            if(!reproduciendo)
            {
                if(!player2)
                {
                    [self.botonGrabar setEnabled:NO];

                    player2 = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
                    [player2 setDelegate:self];
                }
                [player2 play];
                [self.botonReproducir setImage:[UIImage imageNamed:@"botonDetener"] forState:UIControlStateNormal];
                reproduciendo=true;
            }
            else
            {
                [self.botonGrabar setEnabled:YES];

                [self.botonReproducir setImage:[UIImage imageNamed:@"botonReproducir"] forState:UIControlStateNormal];
                [player2 stop];
                reproduciendo=false;
                player2=nil;
            }
        }
    }
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [self.botonReproducir setEnabled:YES];
    [self.botonGrabar setEnabled:YES];
}

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.botonReproducir setImage:[UIImage imageNamed:@"botonReproducir"] forState:UIControlStateNormal];
    reproduciendo=false;
    player2=nil;
    [self.botonGrabar setEnabled:YES];


}

-(void)stopRecording
{
    
}




@end
