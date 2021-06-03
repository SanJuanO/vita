//
//  galeriaPrincipal.m
//  kiwilimon
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 18/05/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "galeriaPrincipal.h"
#import "UIImageView+AFNetworking.h"
#import "PureLayout.h"
#import <sqlite3.h>
@implementation galeriaPrincipal
@synthesize modo=_modo;

#import "color.h"
#import "globales.h"
#import "databaseOperations.h"

@synthesize delegate=_delegate;

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
    [[NSBundle mainBundle] loadNibNamed:@"galeriaPrincipal" owner:self options:nil];
    [self addSubview:self.view];
    [self.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.contenedor registerNib:[UINib nibWithNibName:@"galeriaPrincipalCelda" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
}



-(void)awakeFromNib
{
    self.contenedor.backgroundColor = [UIColor clearColor];
    self.contenedor.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
   
    self.paginador.pageIndicatorTintColor = [self colorDesdeString:@"#CCCCCC" withAlpha:1.0];
    self.paginador.currentPageIndicatorTintColor = [self colorDesdeString:@"#999999" withAlpha:1.0];
    
    indice=[[NSMutableArray alloc] init];
    self.contenedor.dataSource=self;
    self.contenedor.delegate=self;
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [indice count];
    //return 10;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    galeriaPrincipalCelda *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    //[[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    //[[cell contentView] setFrame:CGRectMake(0, 0, 320, 240)];
    //[[cell contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    NSDictionary *elementoActual=[indice objectAtIndex:indexPath.row];
    NSString *imagen=[elementoActual objectForKey:campoImagenLocal];
    NSString *tamano=@"N";
    if([self.modo isEqualToString:@"mini"])
        tamano=@"M";
    
    [cell.botonVideo setHidden:true];
    if([elementoActual objectForKey:@"urlimagenvid"])
    {
        imagen=[elementoActual objectForKey:@"urlimagenvid"];
        [cell.botonVideo setHidden:false];
    }
    else if([elementoActual objectForKey:@"archivofoto"])
        imagen=[elementoActual objectForKey:@"archivofoto"];
    
    [cell.imagen setImage:nil];
    if ([imagen rangeOfString:@"http://"].location == NSNotFound && [imagen rangeOfString:@"https://"].location == NSNotFound) {
        [cell.imagen setImageWithURL:[NSURL URLWithString:[self extraeArchivoReal:imagen conModo:tamano]]];
    } else {
        [cell.imagen setImageWithURL:[NSURL URLWithString:imagen]];
    }
    
    return cell;

}

-(void)pintaGaleria:(NSMutableArray *)indicePasado enTabla:(BOOL)tabla conPaginaActual:(int)pagina conCampoImagen:(NSString *)campoImagen conCampoTexto:(NSString *)campoTexto   conCostoTexto:(NSString *)costoTexto
{
    if([self.modo isEqualToString:@"mini"])
    {
        self.contenedor.pagingEnabled=false;
        [self.paginador setHidden:true];
    }
    else
    {
        self.contenedor.pagingEnabled=true;
        [self.paginador setHidden:false];
    }
    costoTextoLocal = costoTexto;
    
    if(![costoTextoLocal isEqualToString:@""]){
        UIView *fontoTexto = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 45)];
        [fontoTexto setBackgroundColor:[UIColor blackColor]];
        [fontoTexto setAlpha:0.5];
        [self.view addSubview:fontoTexto];
        UILabel *costo = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, screenWidth-20, 21)];
        costo.text = costoTextoLocal;
        costo.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:24];
        costo.textColor = [UIColor whiteColor];
        costo.shadowColor = [UIColor blackColor];
        costo.shadowOffset = CGSizeMake(1.0, 1.0);
        costo.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:costo];
    }
    campoImagenLocal=campoImagen;
    campoTextoLocal=campoTexto;
    tablaInterna=tabla;
    indice = [NSMutableArray arrayWithArray:indicePasado];
    [self.paginador setNumberOfPages:[indice count]];
    
    if([indice count]==1)
        [self.paginador setHidden:true];
    else
        [self.paginador setHidden:false];
    [self.contenedor reloadData];
    paginaActual=pagina;
    
    if(pagina>0)
    {
        CGFloat pageWidth = self.contenedor.frame.size.width;
        [self.contenedor setContentOffset:CGPointMake(anchoFuturo * paginaActual, 0.0) animated:NO];
        self.paginador.currentPage = self.contenedor.contentOffset.x / pageWidth;
    }
    
}

-(void)yaRote
{
    if(!tablaInterna)
    {
        anchoFuturo = self.contenedor.bounds.size.width;
        [self.contenedor setContentOffset:CGPointMake(anchoFuturo * paginaActual, 0.0) animated:NO];
    }
    [[self.contenedor collectionViewLayout] invalidateLayout];
}


// calulamos el tamaño de las celdas y la paginación
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if([self.modo isEqualToString:@"mini"])
        return CGSizeMake(120,90);
    else
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    /*
    // es iphone vertical
    if(![dispositivo isEqualToString:@"ipad"] && UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    else // en cualquier otro caso calculamos 4x3 dependiendo del ancho
    {
        float ancho=self.view.frame.size.height*320/240;
        return CGSizeMake(ancho, self.view.frame.size.height);
    }*/
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.contenedor.frame.size.width;
    self.paginador.currentPage = self.contenedor.contentOffset.x / pageWidth;
    paginaActual=self.paginador.currentPage;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *elemento=[indice objectAtIndex:indexPath.row];
    [self.delegate abreFotoVideoDesdeGaleria:elemento];
//    [self.delegate abreFotoGaleria:(int)paginaActual];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
