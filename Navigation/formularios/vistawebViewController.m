//
//  vistawebViewController.m
//  voluntariosapp
//
//  Created by Guillermo on 01/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "vistawebViewController.h"
#import "SVProgressHUD.h"
#import "NSString+URLEncoding.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import <sqlite3.h>
@interface vistawebViewController ()

@end

@implementation vistawebViewController
@synthesize barraInferior=_barraInferior;
@synthesize anterior = _anterior;
@synthesize siguiente = _siguiente;
@synthesize pagina = _pagina;
@synthesize cargando = _cargando;
@synthesize url = _url;
@synthesize modo = _modo;

#import "databaseOperations.h"
#import "color.h"
#import "globales.h"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    if([senderValue isEqualToString:@"noticiaHtmlPuro"])
    {
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        NSMutableArray *indiceTemporal=[[NSMutableArray alloc] init];
        indiceTemporal=[APIConnection getArrayJSON:response withKey:@"noticias"];
        
        if([indiceTemporal count]>0)
        {
            self.textoHTML=[APIConnection getStringJSON:[indiceTemporal objectAtIndex:0] withKey:@"textonoti" widthDefValue:@""];       [self generaHtml:@"nucleoTexto"];
            
        }
    }
}

-(void)generaHtml:(NSString *)archivoNucleo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:archivoNucleo ofType:@"html"];
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    html = [html stringByReplacingOccurrencesOfString:@"<contenido>"
                                           withString:self.textoHTML];
    [self.pagina loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

-(void)generaHtmlCompleto:(NSString *)archivoNucleo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:archivoNucleo ofType:@"html"];
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    html = [html stringByReplacingOccurrencesOfString:@"<contenido>"
                                           withString:self.textoHTML];
    html = [html stringByReplacingOccurrencesOfString:@"<colorFondo1>" withString:[configPrincipal objectForKey:@"colorFondo1"]];
    html = [html stringByReplacingOccurrencesOfString:@"<colorTexto>" withString:[configPrincipal objectForKey:@"colorTexto"]];
    [self.pagina loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (IBAction)descargar:(id)sender {
    NSLog(@"%@",self.url);
    controller = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:self.url]];
    controller.delegate = self;
    CGRect navRect = self.view.frame;
    [controller presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
}

- (void)viewDidLoad
{
    
    
    [self.barraInferior setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo3"] withAlpha:1.0]];
    [self.anterior setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo3"] withAlpha:1.0] forState:UIControlStateNormal];
    [self.siguiente setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo3"] withAlpha:1.0] forState:UIControlStateNormal];
    [self.cargando setColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo3"] withAlpha:1.0]];
    self.bCompartir.hidden = true;
    APIConnection=[[iwantooAPIConnection alloc] init];
    APIConnection.delegationListener=self;
    [self.cargando setHidden:true];

    if([self.modo isEqualToString:@"noticiaHtmlPuro"])
    {
        [APIConnection connectAPI:[NSString stringWithFormat:@"notiDetalle.php?modo=noticiaHtmlPuro&idreal=%@",self.url] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"noticiaHtmlPuro" willContinueLoading:false];
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"noticiaHtmlPuro"]
                                                              action:self.url
                                                               label:nil
                                                               value:nil] build]];
    }
    else if([self.modo isEqualToString:@"video"])
    {
        [self.pagina layoutIfNeeded];
        self.textoHTML=[NSString stringWithFormat:@"<iframe height='%f' width='%f' src='https://www.youtube.com/embed/%@?rel=0' frameborder='0' allowfullscreen></iframe>'",self.pagina.frame.size.height,self.pagina.frame.size.width,self.url];

        [self generaHtml:@"nucleoVideoVR"];
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"web%@",self.modo]
                                                              action:self.url
                                                               label:nil
                                                               value:nil] build]];
    }
    
    else if([self.modo isEqualToString:@"texto"] )
    {
        [self generaHtmlCompleto:@"nucleoTexto"];
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"web%@",self.modo]
                                                              action:self.url
                                                               label:nil
                                                               value:nil] build]];
    }
    
    else
    {
        
        
        NSString *string = self.url;
        if ([string rangeOfString:@".pdf"].location == NSNotFound) {
            
            NSURL *url = [NSURL URLWithString:self.url];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            [self.pagina loadRequest:requestObj];
            [self.anterior setHidden:false];
            [self.siguiente setHidden:false];
            [self updateButtons];

        } else {
            
            
            
            NSString *stringURL = self.url;
            NSURL  *url = [NSURL URLWithString:stringURL];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            
                NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString  *documentsDirectory = [paths objectAtIndex:0];
                
                filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"documento.pdf"];
                [urlData writeToFile:filePath atomically:YES];
            
            
            // Now create Request for the file that was saved in your documents folder
            NSURL *urlf = [NSURL fileURLWithPath:filePath];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlf];
            self.bCompartir.hidden = false;
            [self.pagina setUserInteractionEnabled:YES];
            [self.pagina setDelegate:self];
            [self.pagina loadRequest:requestObj];
        }
        
        
       
        
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"urlVisitada"
                                                              action:self.url
                                                               label:nil
                                                               value:nil] build]];
        
        
        
        
    }
    
    self.pagina.delegate=self;
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"hola");
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.cargando setHidden:false];
    [self.cargando startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.cargando setHidden:true];
    [self.cargando stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.cargando setHidden:true];
    [self.cargando stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

- (void)updateButtons
{
    [self.siguiente setHidden:!self.pagina.canGoForward];
    [self.anterior setHidden:!self.pagina.canGoBack];
}

- (IBAction)anterior:(id)sender {
    [self.pagina goBack];
}
- (IBAction)siguiente:(id)sender {
    [self.pagina goForward];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)cerrar:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
}

- (IBAction)compartirPdf:(id)sender {
    NSURL *pdfURL = [NSURL fileURLWithPath:filePath];// your pdf link.
    controller = [UIDocumentInteractionController interactionControllerWithURL:pdfURL];
    controller.delegate = self;
    //present a drop down list of the apps that support the file type, click an item in the list will open that app while passing in the file.
    [controller presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

@end



